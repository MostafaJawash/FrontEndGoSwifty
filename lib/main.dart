import 'package:delivery/screens/firstScreen.dart';
import 'package:delivery/screens/homeScreen.dart';
import 'package:delivery/screens/store.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await TokenManager.loadSavedData();

  if (TokenManager.token != null) {
    Authmos.saveAllData(
      mos: TokenManager.token!,
      role: TokenManager.role,
      firstName: TokenManager.firstName,
      lastName: TokenManager.lastName,
      email: TokenManager.email,
      phoneNumber: TokenManager.phoneNumber,
      location: TokenManager.location,
      image: TokenManager.image,
    );
  }

  runApp(Delivery());
}

class Delivery extends StatelessWidget {
  const Delivery({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = TokenManager.token != null;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? HomeScreen() : FirstScreen(),
    );
  }
}
