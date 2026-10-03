import 'package:central/SignUp.dart';
import 'package:flutter/material.dart';

class MainScreenPage extends StatefulWidget{
  const MainScreenPage({super.key, required this.title});

  final String title;

  @override
  State<MainScreenPage> createState() => _MainScreenPageState();
}

Widget squareIconButton(
  IconData icon,
  String label,
  VoidCallback onPressed,
) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(height: 30,),
      SizedBox(
        width: 70,
        height: 70,
        child: IconButton.filledTonal(
          onPressed: onPressed,
          icon: Icon(icon, size: 30),
          color: Colors.white,
          style: IconButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 113, 156, 230),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      Text(label),
    ],
  );
}
class _MainScreenPageState extends State<MainScreenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/backgroundo.jfif'),
                fit: BoxFit.cover,
              )
            ),
          ),

          Padding (
            padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  squareIconButton(
                      Icons.person_add_alt_1,
                      'Sign up',
                      () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpPage(title: 'Hashenv'))
                        );
                    },
                  ),
                  squareIconButton(
                    Icons.key,
                    'Get tokens',
                    () {}
                  ),
                  squareIconButton(
                    Icons.folder,
                    'Repositories',
                    () {},
                  ),
                  squareIconButton(
                    Icons.storage,
                    'Database',
                    () {},
                  ),
                ],
              ),
          ),
        SizedBox(
          height: 20,
        ),
        const Padding(
          padding: EdgeInsets.only(right: 350, top: 20),
          child: Text(
            'People',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          ),
        const SizedBox(height: 15,),

        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  print('Click Person ${index + 1}');
                },
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    child: Icon(
                      Icons.person,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text('Person ${index + 1}')
                ],
              )
              );
            }
        )
          
        ]
      ),
      backgroundColor: const Color.fromARGB(255, 219, 228, 227),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: [
      //       const DrawerHeader(
      //         decoration: BoxDecoration(color: Color.fromARGB(255, 199, 188, 126)),
      //         child: Text('Central',
      //         style: TextStyle(color: Colors.white, fontSize: 24)),
          
      //         ),
      //       ListTile(
      //         leading: const Icon(Icons.login),
      //         title: const Text('Hashenv'),
      //         onTap: () {
      //           Navigator.pop(context);
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => const SignUpPage(title: 'Hashenv')));
      //         },
      //       )
      //     ],
      //     ),
      //   ),
      );
  }
}

