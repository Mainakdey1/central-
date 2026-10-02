import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';






class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.title});

  final String title;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();


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
    _confirmPasswordController.dispose();
    super.dispose();
  }



//Main UI starts here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color.fromARGB(255, 243, 191, 202),
      ),
    backgroundColor: const Color.fromARGB(255, 230, 208, 190),

      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 250,
                child: TextField(
                  controller: _userController,
                  decoration: InputDecoration(
                    hintText: 'Enter your username',
                    labelText: 'username',
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
                child: TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Make a password',
                    labelText: 'Password',
                    border: OutlineInputBorder()
                  ),
                ),
              ),
              SizedBox(
                height: 10,
                width: 250,
              ),
              SizedBox(
                width: 250,
                child: TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    hintText: 'Confirm password',
                    labelText: 'Confirm password',
                    border: OutlineInputBorder()
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          
      ),
      ),

    floatingActionButton: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FilledButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()){
              return;
            }
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
