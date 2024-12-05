// ignore: file_names
import 'package:delivery/screens/favoritesPage.dart';
import 'package:delivery/screens/firstScreen.dart';
import 'package:delivery/screens/loginScreen.dart';
import 'package:delivery/screens/personaldetails.dart';
import 'package:delivery/screens/productListPage.dart';
import 'package:delivery/screens/setting.dart';
import 'package:delivery/screens/store.dart';
import 'package:delivery/screens/storeListPage.dart';
import 'package:delivery/widgets/customlistTitle.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Store> stores = [
    Store('Restaurant', 'lib/assest/motor.png',
        'نقدم لك أفضل المأكولات من البرجر والبيتزا.', [
      Product('برجر لذيذ', 'lib/assest/motor.png', 10.0),
      Product('بيتزا مارجريتا', 'lib/assest/motor.png', 12.0),
    ]),
    Store('Clothes', 'lib/assest/motor.png',
        'نحن نقدم ملابس عصرية وجميلة لجميع الأذواق.', [
      Product('قميص رجالي', 'lib/assest/motor.png', 25.0),
      Product('فستان نسائي', 'lib/assest/motor.png', 40.0),
    ]),
    Store('Elecotronices', 'lib/assest/motor.png',
        'أفضل الأجهزة الإلكترونية بأحدث التقنيات.', [
      Product('هاتف ذكي', 'lib/assest/motor.png', 300.0),
      Product('سماعات لاسلكية', 'lib/assest/motor.png', 50.0),
    ]),
    Store('Elecotronices', 'lib/assest/motor.png',
        'أفضل الأجهزة الإلكترونية بأحدث التقنيات.', [
      Product('هاتف ذكي', 'lib/assest/motor.png', 300.0),
      Product('سماعات لاسلكية', 'lib/assest/motor.png', 50.0),
    ]),
    Store('Elecotronices', 'lib/assest/motor.png',
        'أفضل الأجهزة الإلكترونية بأحدث التقنيات.', [
      Product('هاتف ذكي', 'lib/assest/motor.png', 300.0),
      Product('سماعات لاسلكية', 'lib/assest/motor.png', 50.0),
    ]),
    Store('Elecotronices', 'lib/assest/motor.png',
        'أفضل الأجهزة الإلكترونية بأحدث التقنيات.', [
      Product('هاتف ذكي', 'lib/assest/motor.png', 300.0),
      Product('سماعات لاسلكية', 'lib/assest/motor.png', 50.0),
    ]),
  ];
  int currentIndex = 0;
  List<Widget> listwidget = [
    StoreListPage(),
    Loginscreen(),
    FirstScreen()
  ]; //            هون لازم نحط الصفحات اللي بدنا نرجعهن و بالترتيب
 final List<FavoriteItem> favorites = [];

  void toggleFavorite(FavoriteItem item) {
    setState(() {
      if (favorites.any((fav) => fav.id == item.id)) {
        favorites.removeWhere((fav) => fav.id == item.id);
      } else {
        favorites.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Color.fromARGB(144, 136, 245, 225),
            onTap: (val) {
              setState(() {
                currentIndex = val;

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            listwidget.elementAt(currentIndex)));
              });
            },
            currentIndex: currentIndex,
            iconSize: 40,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.black,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_box), label: "Account"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart), label: "Shopping Cart"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.check_box), label: " Order"),
            ]),
        backgroundColor: const Color.fromARGB(255, 82, 92, 115),

        //   backgroundColor: Color(0xff303644),
        appBar: AppBar(
          iconTheme: const IconThemeData(
              color: Color.fromARGB(255, 255, 255, 255), size: 28, opacity: 99),
          title: const Text("GoSwifty",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Pacifico',
                fontSize: 25,
                color: Colors.white,
              )),
          backgroundColor: const Color.fromARGB(255, 60, 68, 85),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0, top: 8),
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search_outlined,
                    color: Colors.white,
                    size: 34,
                  )),
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: const Color.fromARGB(255, 61, 69, 87),
          child: Container(
            padding: const EdgeInsets.all(15),
            child: ListView(
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.asset(
                          "lib/assest/motor.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Expanded(
                        child: ListTile(
                      title: Text(
                        "Mostafa",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        "0954345865",
                        style: TextStyle(
                          color: Color.fromARGB(255, 136, 245, 225),
                        ),
                      ),
                    ))
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                ListTile(
                  title: const Text(
                    "Account",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  leading: const Icon(
                    Icons.account_box,
                    color: Color.fromARGB(255, 136, 245, 225),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserProfileScreen()));
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text(
                    "Stores",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  leading: const Icon(
                    Icons.home,
                    color: Color.fromARGB(255, 136, 245, 225),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StoreListPage()));
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text(
                    "Favorites",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  leading: const Icon(
                    Icons.favorite,
                    color: Color.fromARGB(255, 136, 245, 225),
                  ),
                 onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesPage(),
                ),
              );
            },
                ),
                const Divider(),
                ListTile(
                  title: const Text(
                    "Order",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  leading: const Icon(
                    Icons.check_box,
                    color: Color.fromARGB(255, 136, 245, 225),
                  ),
                  onTap: () {},
                ),
                const Divider(),
                ListTile(
                  title: const Text(
                    "Shopping Cart",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  leading: const Icon(
                    Icons.shopping_cart,
                    color: Color.fromARGB(255, 136, 245, 225),
                  ),
                  onTap: () {},
                ),
                const Divider(),
                ListTile(
                  title: const Text(
                    "Setting",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  leading: const Icon(
                    Icons.settings,
                    color: Color.fromARGB(255, 136, 245, 225),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingScreen()));
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text(
                    "Contact Us",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  leading: const Icon(
                    Icons.phone_android_outlined,
                    color: Color.fromARGB(255, 136, 245, 225),
                  ),
                  onTap: 
                    ()=>  showContatDialog()
                
                ),
                const Divider(),
                ListTile(
                  title: const Text(
                    "Log Out ",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  leading: const Icon(
                    Icons.logout,
                    color: Color.fromARGB(255, 136, 245, 225),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                //      CustomListTile(nameWidget: 'bbbb', icon:Icons.vaccines , nextPage: HomeScreen()),
                const SizedBox(
                  height: 120,
                ),

                const ListTile(
                  title: Text(
                    "جميع الحقوق محفوظة",
                    style: TextStyle(
                        color: Color.fromARGB(224, 255, 255, 255),
                        fontSize: 18),
                  ),
                  leading: Icon(
                    Icons.copyright,
                    color: Color.fromARGB(255, 136, 245, 225),
                  ),
                ),
              ],
            ),
          ),
        ),

        body: Theme(
          data: Theme.of(context).copyWith(
            listTileTheme: const ListTileThemeData(
              minVerticalPadding: 0,
              dense: true,
            ),
          ),
          child: Column(children: [
            Expanded(
              child: ListView.builder(
                itemCount: stores.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: const Color.fromARGB(201, 255, 255, 255),
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    elevation: 5,
                    child: SizedBox(
                      height: 160,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            stores[index].imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          stores[index].name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        subtitle: Text(
                          stores[index].description,
                          style: const TextStyle(fontSize: 20),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductListPage(store: stores[index]),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            // Container(
            //     decoration: const BoxDecoration(
            //         color: Color.fromARGB(144, 136, 245, 225),
            //         borderRadius: BorderRadius.only(
            //           topLeft: Radius.circular(12),
            //           topRight: Radius.circular(12),
            //         )),
            //     width: double.infinity,
            //     height: 50,
            //     child: Row(children: [
            //       Padding(
            //         padding: const EdgeInsets.only(right: 16.0, left: 66),
            //         child: IconButton(
            //             onPressed: () {},
            //             icon: const Icon(
            //               Icons.account_box,
            //               color: Color.fromARGB(255, 82, 92, 115),
            //               size: 34,
            //             )),
            //       ),
            //     const  VerticalDivider(
            //         color: Colors.black,
            //         thickness: 1.5,
            //         width: 20,
            //       ),
            //        Padding(
            //         padding: const EdgeInsets.only(right: 26.0, left: 26),
            //         child: IconButton(
            //             onPressed: () {},
            //             icon: const Icon(
            //                Icons.shopping_cart,
            //               color: Color.fromARGB(255, 82, 92, 115),
            //               size: 34,
            //             )),
            //       ),
            //     const  VerticalDivider(
            //         color: Colors.black,
            //         thickness: 1.5,
            //         width: 20,
            //       ),
            //        Padding(
            //         padding: const EdgeInsets.only(right: 46, left: 16),
            //         child: IconButton(
            //             onPressed: () {},
            //             icon: const Icon(
            //                  Icons.check_box,
            //               color: Color.fromARGB(255, 82, 92, 115),
            //               size: 34,
            //             )),
            //       ),

            //     ]))
          ]),
        ),

        //floatingActionButton: Container(color: Colors.white,height: 50,)
      ),
    );
  }
  void showContatDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('choose the thim'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('mostafajawash1@gmail.com',style: TextStyle(fontSize: 14),),
                leading: Icon(Icons.email),
                onTap: () {
                  
                  Navigator.of(context).pop(); // إغلاق النافذة
                },
              ),
              ListTile(
                title: Text('00963954345865'),
                leading: Icon(Icons.numbers),
                onTap: () {
                 
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








// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:geolocator/geolocator.dart';
// import 'dart:io';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: UserProfileScreen(),
//       theme: ThemeData(
//         primaryColor: Colors.blue,
//         hintColor: Colors.blueAccent,
//       ),
//     );
//   }
// }


