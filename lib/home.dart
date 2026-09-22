
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';






class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  void register(String email, String password) {
    print(email);
    print(password);
    
    return ;
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
    _emailController.dispose();
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
                controller: _emailController,
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
          onPressed: () {
             register(
            _emailController.text,
            _passwordController.text,
          );
          showTokenDialog('sometoken');
          },
        child: const Text('Register'),
      ),



      const SizedBox(width: 10),

  
  
  ]));
  }

}
