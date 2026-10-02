import 'package:central/SignUp.dart';
import 'package:flutter/material.dart';

class MainScreenPage extends StatefulWidget{
   const MainScreenPage({super.key, required this.title});

  final String title;

  @override
  State<MainScreenPage> createState() => _MainScreenPageState();
}

class _MainScreenPageState extends State<MainScreenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 185, 243, 236),
        title: const Text('Central'),
      ),
      backgroundColor: const Color.fromARGB(255, 219, 228, 227),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color.fromARGB(255, 199, 188, 126)),
              child: Text('Central',
              style: TextStyle(color: Colors.white, fontSize: 24)),
          
              ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Hashenv'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpPage(title: 'Hashenv')));
              },
            )
          ],
          ),
        ),
      );
  }
}

