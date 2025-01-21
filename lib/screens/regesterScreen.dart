import 'package:delivery/Services/apiServicesAuth.dart';
import 'package:flutter/material.dart';
import 'package:delivery/screens/homeScreen.dart';
import 'package:delivery/widgets/customButton.dart';
import 'package:delivery/widgets/textfield.dart';

class RegesterPage extends StatefulWidget {
  RegesterPage({super.key});

  @override
  _RegesterPageState createState() => _RegesterPageState();
}

class _RegesterPageState extends State<RegesterPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? firstName,
      lastName,
      phoneNumber,
      email,
      password,
      passwordConfirmation;
  bool isLoading = false;

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!value.contains('@gmail') || !value.endsWith('.com')) {
      return 'Please enter a valid email (e.g., example@gmail.com)';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters';
    } else if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
      return 'Password must contain letters';
    } else if (!RegExp(r'\d').hasMatch(value)) {
      return 'Password must contain numbers';
    }
    return null;
  }

  String? confirmPasswordValidator(String? value) {
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff371353),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const SizedBox(height: 30),
            Image.asset(
              'lib/assest/first.png',
              height: 200,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Form(
              key: formKey,
              child: Column(
                children: [
                  CustomFormTextField(
                    obscureText: false,
                    onChanged: (data) => firstName = data,
                    lable: 'First name',
                    hintText: 'Enter First name',
                  ),
                  const SizedBox(height: 15),
                  CustomFormTextField(
                    obscureText: false,
                    onChanged: (data) => lastName = data,
                    lable: 'Last name',
                    hintText: 'Enter Last name',
                  ),
                  const SizedBox(height: 15),
                  CustomFormTextField(
                    obscureText: false,
                    onChanged: (data) => email = data,
                    lable: 'E-mail',
                    hintText: 'Enter E-mail',
                    validator: emailValidator,
                  ),
                  const SizedBox(height: 15),
                  CustomFormTextField(
                    obscureText: false,
                    onChanged: (data) => phoneNumber = data,
                    lable: 'Phone Number',
                    hintText: 'Enter Phone Number',
                  ),
                  const SizedBox(height: 15),
                  CustomFormTextField(
                    obscureText: true,
                    onChanged: (data) => password = data,
                    lable: 'Password',
                    hintText: 'Enter Password',
                    validator: passwordValidator,
                  ),
                  const SizedBox(height: 15),
                  CustomFormTextField(
                    obscureText: true,
                    onChanged: (data) => passwordConfirmation = data,
                    lable: 'Password again',
                    hintText: 'Enter Password again',
                    validator: confirmPasswordValidator,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            CustomButton(
              text: isLoading ? 'Loading...' : 'Register',
              ontap: () async {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    isLoading = true;
                  });

                  final response = await ApiRegister.register(
                    firstName: firstName!,
                    lastName: lastName!,
                    phoneNumber: phoneNumber!,
                    email: email!,
                    password: password!,
                    passwordConfirmation: passwordConfirmation!,
                  );

                  setState(() {
                    isLoading = false;
                  });

                  if (response['success']) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                      (route) => false,
                    );
                  } else if (response['errors'] != null) {
                    if (response['errors'].containsKey('email') ||
                        response['errors'].containsKey('phone_number')) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Account Exists'),
                            content: const Text(
                              'This account already exists. Please log in instead.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.pop(context);
                                },
                                child: const Text('Go to Login'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(response['message']),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account?',
                  style: TextStyle(color: Colors.white),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    '  Login',
                    style: TextStyle(color: Color.fromARGB(251, 21, 189, 222)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}
