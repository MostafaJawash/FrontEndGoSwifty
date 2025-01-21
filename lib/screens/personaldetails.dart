import 'package:delivery/Services/apiServicesAuth.dart';
import 'package:delivery/screens/globals.dart';
import 'package:delivery/screens/store.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController =
      TextEditingController(text: Authmos.firstName ?? '');
  TextEditingController _lastNameController =
      TextEditingController(text: Authmos.lastName ?? '');
  TextEditingController _phoneController =
      TextEditingController(text: Authmos.phoneNumber ?? '');
  TextEditingController _LocationController =
      TextEditingController(text: Authmos.location ?? '');
  TextEditingController _emailController =
      TextEditingController(text: Authmos.email ?? '');

  XFile? _userImage;
  final imagee = Authmos.image;
  String imagehttp = AppImage.appImage;

Widget buildImageWidget() {
  if (imagee == null) {
    return Center(
      child: _userImage == null
          ? CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.camera_alt, size: 40, color: Colors.white),
            )
          : CircleAvatar(
              radius: 50,
              backgroundImage: FileImage(File(_userImage!.path)),
              //FileImage(File(_userImage!.path)),
            ),
    );
  } else {
    return Center(
      child: ClipOval(
        child: FadeInImage(
          placeholder: AssetImage('lib/assest/mostafa.jpg'), 
          image: NetworkImage('$imagee'),
          fit: BoxFit.cover,
          width: 150,
          height: 150,
          imageErrorBuilder: (context, error, stackTrace) => CircleAvatar(
            radius: 75,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.error, color: Colors.red, size: 50),
          ),
        ),
      ),
    );
  }
}



  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _userImage = pickedFile;
      });
    }
  }



  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Updating profile...')),
      );

      final response = await ApiUpdateProfile.updateProfile(
        token: Authmos.tokenmos ?? '',
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        location: _LocationController.text,
        image: _userImage != null ? File(_userImage!.path) : null,
      );

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Language == true ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title:  Text(
            Language == true ? 'ملفي الشخصي' : 'User Profile',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 118, 45, 177),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                buildImageWidget(),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text(
                    
                     Language == true ? 'اختيار صورة' : 'Pick an Image',
                    ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 226, 148, 255),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 144, 29, 186)),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 144, 29, 186)),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'First name is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 144, 29, 186)),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 144, 29, 186)),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Last name is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 144, 29, 186)),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 144, 29, 186)),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 144, 29, 186)),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 144, 29, 186)),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                            .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _LocationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 144, 29, 186)),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 144, 29, 186)),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Location is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _updateProfile,
                  child: Text(
                   Language == true ? 'حفظ' : 'Save',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 226, 148, 255),
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
