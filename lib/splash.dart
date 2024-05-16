import 'package:flutter/material.dart';

import 'MyHomePage.dart';

class Splash extends StatefulWidget{
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    _navigatetohome();

  }
  _navigatetohome()async{
    await Future.delayed(const Duration(seconds: 3), () {});
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context)=> const MyHomePage()));
  }

  @override
  Widget build(BuildContext context) {

   return Scaffold(
     backgroundColor:  const Color.fromARGB(255, 250, 174, 57),
     body: Center(
       child: Container(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [ Container(height: 150, width: 250, color: Colors.black,),
             const SizedBox(height: 20),
             const Text('PhotoCut Pro', style: TextStyle(
               fontSize: 35,
               fontWeight: FontWeight.w700
             ),),
           ],
         )
       ),
     ),
   );
  }
}