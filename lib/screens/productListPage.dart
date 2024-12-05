import 'package:delivery/screens/favoritesPage.dart';
import 'package:delivery/screens/productDetailPage.dart';
import 'package:delivery/screens/store.dart';
import 'package:flutter/material.dart';

class ProductListPage extends StatelessWidget {
  final Store store;

  ProductListPage({required this.store});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 104, 117, 147),
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: const Color.fromARGB(255, 255, 255, 255),
            size: 28,
            opacity: 99),
        backgroundColor: const Color.fromARGB(255, 60, 68, 85),
        centerTitle: true,
        title: Text(
          store.name,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: store.products.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(200, 255, 255, 255),
                borderRadius: BorderRadius.circular(26),
              ),
              height: 100,
              child: Center(
                child: ListTile(
                  leading: Image.asset(store.products[index].imageUrl,
                      width: 70, height: 70, fit: BoxFit.cover),
                  title: Text(
                    store.products[index].name,
                    style: TextStyle(fontSize: 22),
                  ),
                  subtitle: Text(
                    '\$${store.products[index].price}',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(
                          product: store.products[index],
                        ),
                      ),
                    );
                  },
                  
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
