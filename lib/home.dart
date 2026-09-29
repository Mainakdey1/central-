
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';






class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


Future<void> register(String username, String password) async {
  try {
    final apiUrl = dotenv.env['SERVER_URL'];
    final response = await http.post(
      Uri.parse('$apiUrl/register'),


      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user': username,
        'password': password,
      }),
    );
    if (!mounted) return;
    if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Registration Successful!'),
        backgroundColor: Colors.green,
        )
    );
    } else if (response.statusCode == 409) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User already exists'),
          backgroundColor: Colors.red,
        )
      );
    } else {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed with message: $data'),
          backgroundColor: Colors.red,
      ),);
    }
    print('$apiUrl/register');
    print('Status: ${response.statusCode}');
    print('Response: ${response.body}');
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Registration failed: $e'),
        backgroundColor: Colors.red,
        ));
  }
  }
  void showTokenDialog(String token) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Registration Successful'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Save this token please'
              ),
              const SizedBox(height: 15,),
              SelectableText(token),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(text: token)
                );
              }, child: const Text('Copy'),
            ),
          TextButton(onPressed: () {
            Navigator.of(context).pop();
          }, child: const Text('Done'))
          ],
        );
      }
      );
  }





  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),



      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 250,
              child: TextField(
                controller: _userController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 10,
              width: 250,
            ),
            SizedBox(
              width: 250,
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder()
                ),
              ),
            )
          ],
        ),
        
  ),

    floatingActionButton: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FilledButton(
          onPressed: () async {
            await register(
            _userController.text,
            _passwordController.text,
          );
          // showTokenDialog('sometoken');
          },
        child: const Text('Register'),
      ),



      const SizedBox(width: 10),

  
  
  ]));
  }

}
