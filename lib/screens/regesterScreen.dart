
import 'package:delivery/screens/homeScreen.dart';
import 'package:delivery/widgets/customButton.dart';
import 'package:delivery/widgets/textfield.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RegesterPage extends StatelessWidget {
 RegesterPage({super.key});
 bool isLoading = false;
  String? email;

  String? password;
  GlobalKey<FormState> formkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff303644),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
               SizedBox(
                height: 30,
              ),
              Image.asset(
                 'lib/assest/image1.jpg',
                height: 140,
              ),
            
              SizedBox(
                height: 25,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Regester',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),CustomFormTextField(
                obscureText: true,
                onChanged: (data) {
                  email = data;
                },
                lable:'First name' ,
                hintText: 'Enter First name',
              ),
               SizedBox(
                height: 15,
              ),CustomFormTextField(
                obscureText: true,
                onChanged: (data) {
                  email = data;
                },
                lable:'Last name' ,
                hintText: 'Enter Last name',
              ), SizedBox(
                height: 15,
              ),
              CustomFormTextField(
                obscureText: true,
                onChanged: (data) {
                  email = data;
                },
                lable:'E-mail' ,
                hintText: 'Enter E-mail',
              ),
              SizedBox(
                height: 15,
              ),
              CustomFormTextField(
                obscureText: true,
                onChanged: (data) {
                  email = data;
                },lable:'number' ,
                hintText: 'Enter number',
              ),
              SizedBox(
                height: 15,
              ),
              CustomFormTextField(
                obscureText: true,
                onChanged: (data) {
                  password = data;
                },lable: 'Password',
                hintText: 'Enter Password',
              ), SizedBox(
                height: 15,
              ),
              CustomFormTextField(
                obscureText: true,
                onChanged: (data) {
                  password = data;
                },lable: 'Password again',
                hintText: 'Enter Password again',
              ),
              SizedBox(
                height: 25,
              ),
              CustomButton(text: 'Regester', ontap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                    }),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'don\'t have an account ?',
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      '  Login',
                      style: TextStyle(color: Color.fromARGB(251, 21, 189, 222)),
                    ),
                  ),
                ],
              ), SizedBox(
                height: 35,
              ),
              
            ],
          ),
        ));
  }
}

