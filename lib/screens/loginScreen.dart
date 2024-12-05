import 'package:delivery/screens/homeScreen.dart';
import 'package:delivery/screens/regesterScreen.dart';
import 'package:delivery/widgets/customButton.dart';
import 'package:delivery/widgets/textfield.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Loginscreen extends StatelessWidget {
  Loginscreen({super.key});
  bool isLoading = false;
  String? email;

  String? password;
  GlobalKey<FormState> formkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:const Color(0xff303644),
      
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
           const  SizedBox(
                height: 65,
              ),
              Image.asset(
                 'lib/assest/image1.jpg',
                height: 200,
              ),
           
            const  SizedBox(
                height: 25,
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
              CustomFormTextField(
                obscureText: true,
                onChanged: (data) {
                  email = data;
                },
                lable:'number' ,
                hintText: 'Enter number',
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
              ),
            const  SizedBox(
                height: 35,
              ),
              CustomButton(text: 'Login', ontap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
                    },),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>RegesterPage()));
                    },
                    child:const Text(
                      '  Regester',
                      style: TextStyle(color: Color.fromARGB(251, 21, 189, 222)),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ));
  }
}
