import 'package:flutter/material.dart';
import 'package:speedometer/main.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatelessWidget{
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 42, 90, 112),
        
      ),
      backgroundColor: Color.fromARGB(255, 95, 140, 146),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Text(
              'Welcome to Central',
              style: GoogleFonts.dancingScript(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),

          const SizedBox(height: 20,),

          ElevatedButton(onPressed: () {
            Navigator.push(context,
             MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Central'),
             ));
          },
          child: const Text('Continue'),
          ),

          ],
        ),
      ),
    );
  }


}

