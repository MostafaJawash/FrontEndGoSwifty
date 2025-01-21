
import 'dart:ui';

import 'package:delivery/Services/apiServicesAuth.dart';
import 'package:delivery/screens/homeScreen.dart';
import 'package:delivery/screens/regesterScreen.dart';
import 'package:delivery/widgets/textfield.dart';
import 'package:flutter/material.dart';

import '../widgets/customButton.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  _LoginscreenState createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  bool isLoading = false;
  String? phone;
  String? password;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff371353),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Image.asset(
              'lib/assest/first.png',
              height: 300,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'LOGIN',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Form(
              key: formkey,
              child: Column(
                children: [
                  CustomFormTextField(
                    obscureText: false,
                    onChanged: (data) {
                      phone = data;
                    },
                    lable: 'Number',
                    hintText: 'Enter number',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomFormTextField(
                    obscureText: true,
                    onChanged: (data) {
                      password = data;
                    },
                    lable: 'Password',
                    hintText: 'Enter Password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            CustomButton(
              text: 'Login',
              ontap: () async {
                if (formkey.currentState?.validate() ?? false) {
                  setState(() {
                    isLoading = true; // Show loading indicator
                  });

                  try {
                    final response = await ApiLogin.login(phone!, password!);

                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }

                    if (response['success'] == true) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                        (route) => false,
                      );
                    } else {
                      setState(() {
                        isLoading = false; // Hide loading indicator
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            response['message'] == 'Invalid credentials'
                                ? 'Please check your information or register.'
                                : 'Login failed. Please try again.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (e) {
                    setState(() {
                      isLoading = false; // Hide loading indicator
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                            'Please check your internet connection.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'don\'t have an account ?',
                  style: TextStyle(color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegesterPage(),
                      ),
                    );
                  },
                  child: const Text(
                    '  Register',
                    style: TextStyle(color: Color.fromARGB(251, 21, 189, 222)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
