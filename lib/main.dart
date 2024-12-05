import 'package:delivery/screens/firstScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Delivery());
}

class Delivery extends StatelessWidget {
  const Delivery({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     // theme:ThemeData.dark() ,
      debugShowCheckedModeBanner: false,
      home: FirstScreen(),
    );
  }
}