import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';



Future<void> pairDevice(String deviceTokenId) async {
    final apiUrl = dotenv.env['SERVER_URL'];
    final response = await http.post(
      Uri.parse('$apiUrl/devices/register'),


      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'deviceToken': deviceTokenId,
      }),
    );

    if (response.statusCode < 200 || response.statusCode > 300) {
      throw Exception('Device pairing failed with error: ${response.body}');
    }
}
class DeviceQrScannerPage extends StatefulWidget {
  final Future<void> Function(String deviceTokenId) onPairDevice;

  const DeviceQrScannerPage({
    super.key,
    required this.onPairDevice,
  });
  @override
  State<DeviceQrScannerPage> createState() => 
  _DeviceQrScannerPageState();
}

class _DeviceQrScannerPageState extends State<DeviceQrScannerPage> {
  late final MobileScannerController _controller;

  bool _processing = false;
  String? _errorMessage;

  static final RegExp _uuidRegex = RegExp(
    r'^[0-9a-fA-F]{8}-'
    r'[0-9a-fA-F]{4}-'
    r'[0-9a-fA-F]{4}-'
    r'[0-9a-fA-F]{4}-'
    r'[0-9a-fA-F]{12}$',
  );

@override
void initState() {
  super.initState();

  _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );
}

Future<void> _handleDetection(BarcodeCapture capture) async {
  if (_processing) return;

  String? deviceTokenId;

  for (final barcode in capture.barcodes) {
    final value = barcode.rawValue?.trim();

    if (value != null && value.isNotEmpty) {
      deviceTokenId = value;
      break;
    }
  }

  if (deviceTokenId == null) return;
  if (!_uuidRegex.hasMatch(deviceTokenId)) {
    if (mounted) {
      setState(() {
        _errorMessage = 'Invalid QR code. Scan a valid code';
      });
    }
    return;
  }

  _processing = true;

  try {
    await _controller.stop();

    if (!mounted) return;
    setState(() {
      _errorMessage = null;
    });

  debugPrint('Scanned QR: $deviceTokenId');
  await widget.onPairDevice(deviceTokenId);
  if (!mounted) return;

  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AlertDialog(
      icon: const Icon(
        Icons.verified_rounded,
        color: Colors.green,
        size: 44,
      ),
      title: const Text('Device paired'),
      content: const Text(
        'Your HashEnv device was logged in!',
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext), 
          child: const Text('Continue'),),
      ],
    ),
  );
  if (mounted) {
    Navigator.of(context).pop(deviceTokenId);
  }
} catch (error) {
  if (!mounted) return;

  setState(() {
    _errorMessage = 'Pairing Failed: $error';
  });
  _processing = false;
  await _controller.start();
}
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Pair Hashenv Device'),
      centerTitle: true,
    ),
    backgroundColor:  const Color.fromARGB(255, 113, 156, 230),
    body: SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 24,),
          const Text(
            'Scan your device QR code',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 8,),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 28),
          child: Text(
            'Open HashENV in your terminal and scan the QR code displayed there.',
            textAlign: TextAlign.center,
          ),
          ),

        const SizedBox(height: 28),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      MobileScanner(
                        controller: _controller,
                        onDetect: _handleDetection,
                      ),
                      IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blueAccent,
                              width: 4,
                            ),
                            borderRadius: BorderRadius.circular(24)
                          ),
                        ),
                      ),
                      if (_processing)
                      Container(
                        color: Colors.black54,
                        child: const Center(
                          child: CircularProgressIndicator(),
                          ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ),
        if (_errorMessage != null)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          ),
          const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Keep the QR code inside the scanning fram',
                textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
  );
}
}