// ignore: file_names
import 'package:delivery/screens/loginScreen.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class FirstScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen>
    with SingleTickerProviderStateMixin {
  String? email;
  String? password;

  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 9),
      vsync: this,
    )..repeat();

    _animation = Tween<Offset>(
      begin:const Offset(-1.0, 0.0),
      end:const Offset(1.0, 0.0),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xff303644),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
          const  SizedBox(
              height: 85,
            ),
            SlideTransition(
              position: _animation,
              child: Image.asset(
                'lib/assest/image1.jpg',
                height: 250,
              ),
            ),
          const  SizedBox(
              height: 56,
            ),
           const Center(
                child: Text(
              'GOSwifty',
              style: TextStyle(
                  fontSize: 52,
                  color: Color.fromARGB(255, 136, 245, 225),
                  fontFamily: 'Pacifico',
                  fontWeight: FontWeight.bold),
            )),
           const SizedBox(
              height: 36,
            ),
           const Text(
              'From Us to you , Faster Than Ever',
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
           const SizedBox(
              height: 16,
            ),
          const  Text(
              " Let's Start .. ",
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
              ),
            ),
          const  SizedBox(
              height: 36,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                     onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Loginscreen()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:const Color.fromARGB(255, 136, 245, 225),
                        borderRadius: BorderRadius.circular(96),
                      ),
                      height: 50,
                      width: 50,
                      child:const Icon(
                        size: 52,
                        Icons.navigate_next,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
