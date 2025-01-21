import 'package:delivery/screens/adminScreen.dart';
import 'package:delivery/Services/apiServicesAuth.dart';
import 'package:delivery/screens/globals.dart';
import 'package:delivery/widgets/customlistTitle.dart';
import 'package:flutter/material.dart';
import 'package:delivery/screens/firstScreen.dart';
import 'package:delivery/screens/personaldetails.dart';
import 'package:delivery/screens/store.dart';
import 'package:delivery/screens/favoritesPage.dart';
import 'package:delivery/screens/storeListPage.dart';
import 'package:delivery/screens/orderScreen.dart';
import 'package:delivery/screens/shoppingcartScreen.dart';


class CustomDrawer extends StatefulWidget {
  CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final tokens = Authmos.tokenmos;

  final namefirst = Authmos.firstName;

  final PhoneNumber = Authmos.phoneNumber;

  final lastname = Authmos.lastName;

  @override
  Widget build(BuildContext context) {
    final String? role = Authmos.role;

    return Drawer(
      backgroundColor: const Color.fromARGB(255, 79, 33, 117),
      child: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          SizedBox(
            height: 10,
          ),

          buildUserInfo(),
          const SizedBox(height: 30),

          buildMenuItem(
              title: 
                  Language == true ? ' ملفي الشخصي' : 'Account',
              icon: Icons.account_box,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => UserProfileScreen()))),

          buildMenuItem(
              title: Language == true ? 'المتاجر' : 'Stores',
              icon: Icons.home,
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => StoreListPage()))),

          buildMenuItem(
              title: Language == true ? 'المفضلة' : 'Favorites',
              icon: Icons.favorite,
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => FavoritesPage()))),

          buildMenuItem(
              title: Language == true ? 'الطلبات' : 'Order',
              icon: Icons.check_box,
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => OrdersScreen()))),

          buildMenuItem(
              title: Language == true ? 'السلة' : 'Shopping Cart',
              icon: Icons.shopping_cart,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ShoppingCartPage(
                            token: '${TokenManager.token}',
                          )))),
          CustomListTile(
              nameWidget: Language == true ? 'اللغة' : 'Language',
              icon: Icons.language,
              ontap: () => showLanguageDialog()),

         

          if (role == "admin")
            buildMenuItem(
              title: Language == true ? 'لوحة الإدارة' : 'Admin Panel',
              icon: Icons.admin_panel_settings,
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Adminscreen())),
            ),

          buildMenuItem(
            title: Language == true ? 'تسجيل الخروج' : 'Log Out',
            icon: Icons.logout,
            onTap: () async {
              try {
                final tokens = Authmos.tokenmos;
                await logout('$tokens');

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => FirstScreen()),
                  (Route<dynamic> route) => false,
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('فشل تسجيل الخروج: $e')),
                );
              }
            },
          ),

          if (role == "admin") const SizedBox(height: 60),
          if (role != "admin") const SizedBox(height: 130),

          ListTile(
            title: Text(
              Language == true ? "جميع الحقوق محفوظة" : 'All rights reserved',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            leading: Icon(
              Icons.copyright,
              color: Color.fromARGB(255, 136, 245, 225),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUserInfo() {
    return Row(
      children: [
        SizedBox(
          height: 10,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.asset(
            "lib/assest/mostafa.jpg",
            //'lib/assest/Classic-Burger.png',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: ListTile(
            title: Row(
              children: [
                Text("$namefirst", style: TextStyle(color: Colors.white)),
                Text(" $lastname", style: TextStyle(color: Colors.white)),
              ],
            ),
            subtitle: Text("$PhoneNumber",
                style: TextStyle(color: Color.fromARGB(255, 136, 245, 225))),
          ),
        )
      ],
    );
  }

  Widget buildMenuItem(
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          leading: Icon(
            icon,
            color: const Color.fromARGB(255, 136, 245, 225),
          ),
          onTap: onTap,
        ),
        const Divider(),
      ],
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
                title: Text(
                Language == true ? 'العربية' : ' Arabic',
                ),
                leading: Icon(Icons.language_rounded),
                onTap: () {
                  setState(() {
                    Language = true;
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text(
                Language == true ? 'الانكليزية' : 'English',
                ),
                leading: Icon(Icons.language_rounded),
                onTap: () {
                  setState(() {
                    Language = false;
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
