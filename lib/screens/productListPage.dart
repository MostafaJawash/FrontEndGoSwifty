import 'package:delivery/Services/apifetch.dart';
import 'package:delivery/screens/favoritesPage.dart';
import 'package:delivery/screens/globals.dart';
import 'package:delivery/screens/productDetailPage.dart';
import 'package:delivery/screens/shoppingcartScreen.dart';
import 'package:delivery/widgets/createproduct.dart';
import 'package:flutter/material.dart';

import 'store.dart';

class ProductListPage extends StatefulWidget {
  final Store store;
  final String token;
  final bool showButtons;

  ProductListPage(
      {required this.store, required this.token, this.showButtons = false});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late Future<List<Product>> productsFuture;
  final tokens = Authmos.tokenmos;
  String imagehttp = AppImage.appImage;
  @override
  void initState() {
    super.initState();

    productsFuture = fetchProducts(widget.token, widget.store.id);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Language == true ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
            size: 28,
          ),
          backgroundColor: const Color.fromARGB(255, 118, 45, 177),
          centerTitle: true,
          title: Text(
            widget.store.name,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.white),
              onPressed: () async {
                setState(() {
                  productsFuture = fetchProducts('$tokens',
                      widget.store.id);
                });
              },
            ),
            if (widget.showButtons)
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CreateProductDialog(
                        token: '$tokens', 
      
                        storeId: widget.store.id, 
                      );
                    },
                  );
                },
              ),
          ],
        ),
        body: FutureBuilder<List<Product>>(
          future: productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final products = snapshot.data!;
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: GestureDetector(
                          onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                product: products[index],
                              ),
                            ),
                          );
                        },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 237, 205, 249),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                       
                       
                             Center(
                                child: Container(
                                  width: 80,
                                height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.grey[
                                        200],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(
                                       '${products[index].imageUrl}',
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child; 
                                        } else {
                                         
                                          Future.delayed(Duration(seconds: 1),
                                              () {
                                          
                                          });
      
                                         
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                       
                                        return Image.asset(
                                         // 'lib/assest/motor.png',
                                          'lib/assest/stor.jpeg',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(width: 15),
                            
                            Expanded(
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                 
                                      Text(
                                        products[index].name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                   
                                      Text(
                                        '\$${products[index].price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.red,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                   
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  if (widget.showButtons)
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: Colors.blue),
                                          onPressed: () {
                                           
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return EditProductDialog(
                                                  currentName: products[index].name,
                                                  currentDescription:
                                                      products[index].description,
                                                  currentPrice:
                                                      products[index].price,
                                                  currentQuantity:
                                                      products[index].quantity,
                                                  productId: products[index].id,
                                                  token: '$tokens',
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            showDeleteProductConfirmationDialog(
                                              context: context,
                                              token: '$tokens',
                                              productId: products[index].id,
                                            );
                                          },
                                        ),
                                      ],
                                    )
                                  else
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AddToCartButton(
                                          token: '$tokens',
                                          productId: products[index].id,
                                         
                                        ),
                                       // const SizedBox(width: 5),
                                        FavoriteButton(
                                          product: products[index],
                                          id: products[index].id,
                                          title: products[index].name,
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('No products available.'));
            }
          },
        ),
      ),
    );
  }
}
