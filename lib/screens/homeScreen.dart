import 'package:delivery/Services/apiNotification.dart';
import 'package:delivery/Services/apifetch.dart';
import 'package:delivery/screens/NotificationScreen.dart';
import 'package:delivery/screens/favoritesPage.dart';
import 'package:delivery/screens/orderScreen.dart';
import 'package:delivery/screens/shoppingcartScreen.dart';
import 'package:delivery/widgets/customsearchfiled.dart';
import 'package:flutter/material.dart';
import 'package:delivery/screens/productListPage.dart';
import 'package:delivery/screens/store.dart';
import 'package:delivery/widgets/customdrawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  String imagehttp = AppImage.appImage;
  bool isLoading = true;
  String? errorMessage;
  List<Store> stores = [];
  final tokens = Authmos.tokenmos;
  final NotificationService _service = NotificationService();
  int? _notificationNumber;

  void _fetchNumber() async {
    final token = '$tokens'; 
    final number = await _service.fetchNotificationNumber(token);
    if (number != null) {
      setState(() {
        _notificationNumber = number;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchNumber();
    _fetchStores();

    _pageController.addListener(() {
      setState(() {
        _currentIndex = _pageController.page!.round();
      });
    });
  }

  Future<void> _fetchStores() async {
    try {
      final token = '$tokens';
      final fetchedStores = await fetchStoresApi(token);
      setState(() {
        stores = fetchedStores;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
            size: 28,
          ),
          title: const Text(
            "GoSwift",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              //    fontFamily: 'Pacifico',
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 88, 31, 132),
        ),
        drawer: CustomDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  height: 100,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FavoritesPage(),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.purple.shade200,
                              child: const Icon(Icons.favorite,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 5),

                            
                          ],
                        ),
                      ),
GestureDetector(
  onTap: () {
    setState(() {
      _notificationNumber = 0; 
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationScreen(),
      ),
    );
  },
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Stack(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.purple.shade200,
            child: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),
          if (_notificationNumber != null && _notificationNumber! > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$_notificationNumber',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    ],
  ),
),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShoppingCartPage(
                                token: '$tokens',
                              ),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.purple.shade200,
                              child: const Icon(Icons.shopping_cart,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 5),

                           
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrdersScreen(),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.purple.shade200,
                              child: const Icon(Icons.list_alt,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 5),

                           
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SearchField(),
                const SizedBox(height: 30),
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 186, 114, 245),
                        width: 4),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: PageView(
                      controller: _pageController,
                      children: [
                        Image.asset('lib/assest/8d4f097eeec47d61530abf75beac274e.jpg',
                            fit: BoxFit.fitHeight),
                        Image.asset('lib/assest/a28fa20543ccb24d94bfead317a11899.jpg',
                            fit: BoxFit.fitHeight),
                        Image.asset('lib/assest/4d4b7d45a927e10b0fcc2e261f988cf9.jpg',
                            fit: BoxFit.fitHeight),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 20,
                      height: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: index == _currentIndex
                            ? const Color.fromARGB(255, 171, 95, 233)
                            : const Color.fromARGB(98, 192, 145, 231),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    );
                  }),
                ),
                isLoading
                    ? const CircularProgressIndicator()
                    : errorMessage != null
                        ? Text('Error: $errorMessage')
                        : Column(
                            children: List.generate(stores.length, (index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductListPage(
                                        store: stores[index],
                                        token: '$tokens',
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 237, 205, 249),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 2),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: SizedBox(
                                    height: 180,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                
                                        Center(
                                          child: Container(
                                            width: 100,
                                            height: 150,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: Colors.grey[
                                                  200], 
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              child: Image.network(
                                                '${stores[index].imageUrl}',
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child; 
                                                  } else {
                                                   
                                                    Future.delayed(
                                                        Duration(seconds: 1),
                                                        () {
                                                     
                                                    });

                                                   
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  }
                                                },
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                               
                                                  return Image.asset(
                                                    'lib/assest/ones.jpg',
                                                    fit: BoxFit.cover,
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 20),

                                        Expanded(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    stores[index].name,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 25,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    Icon(Icons.location_on),
                                                    Text(
                                                      '${stores[index].address}....',
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  stores[index].description,
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                  textDirection:
                                                      TextDirection.ltr,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
