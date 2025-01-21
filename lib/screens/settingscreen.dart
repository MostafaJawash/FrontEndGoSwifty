import 'package:delivery/screens/loginScreen.dart';
import 'package:delivery/widgets/customlistTitle.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool? isDarkMode = false;
  bool? isEnglish = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(200, 167, 110, 213),
      appBar: AppBar(
        iconTheme:
            const IconThemeData(color: Colors.white, size: 28, opacity: 99),
        title: Text(
          'Setting',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(120, 55, 3, 97),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          //Color.fromARGB(120, 158, 84, 218),
          CustomListTile(
              nameWidget: 'Them',
              icon: Icons.light_mode,
              ontap: () => showThemeDialog()),
          CustomListTile(
              nameWidget: 'Language',
              icon: Icons.language,
              ontap: () => showLanguageDialog()),
          CustomListTile(
              nameWidget: 'Log Out',
              icon: Icons.logout,
              ontap: () => Loginscreen()),
        ],
      ),
    );
  }

  void showThemeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('choose the thim'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(' light Mode'),
                leading: Icon(Icons.light_mode),
                onTap: () {
                  setState(() {
                    isDarkMode = false;
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Dark Mode'),
                leading: Icon(Icons.dark_mode),
                onTap: () {
                  setState(() {
                    isDarkMode = true;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('choose the Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(' Arabic'),
                leading: Icon(Icons.language_rounded),
                onTap: () {
                  setState(() {
                    isEnglish = false;
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('English'),
                leading: Icon(Icons.language_rounded),
                onTap: () {
                  setState(() {
                    isEnglish = true;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
