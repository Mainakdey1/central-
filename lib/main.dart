import 'package:central/mainScreen.dart';
import 'package:central/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main () async {
  WidgetsFlutterBinding.ensureInitialized();
  print('before dotenv');
  await dotenv.load(fileName: ".env");
  print('after dotevn');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Central',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 81, 8, 150)),
      ),
      home: const WelcomePage(),
    );
  }
}

