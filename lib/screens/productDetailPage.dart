import 'package:delivery/screens/globals.dart';
import 'package:flutter/material.dart';
import 'package:delivery/screens/PaymentScreen.dart';
import 'package:delivery/screens/favoritesPage.dart';
import 'package:delivery/screens/shoppingcartScreen.dart';
import 'package:delivery/screens/store.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  ProductDetailPage({required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final tokens = Authmos.tokenmos;
  String imagehttp = AppImage.appImage;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Language == true ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 118, 45, 177),
          centerTitle: true,
          title: Text(
            widget.product.name,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
          
             fontWeight: FontWeight.bold,
            ),
          ),   iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
           
               Center(
                                child: Container(
                                 width: 180,
                height: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.grey[
                                        200], 
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(
                                      '${widget.product.imageUrl}',
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
              const SizedBox(height: 16),
              Container(
                width: 200,
                height: 70,
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80),
                    topRight: Radius.circular(80),
                  ),
                  color: Color.fromARGB(255, 232, 202, 244),
                ),
                child: Text(
                  widget.product.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 232, 202, 244),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      RowWidget(
                        name: ': السعر',
                        disc: '\$${widget.product.price}',
                      ),
                      RowWidget(
                        name: ': الخصم',
                        disc: '\$${widget.product.discount}',
                      ),
                      RowWidget(
                        name: ': الكمية',
                        disc: '${widget.product.quantity}',
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.product.description,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 200,
                height: 70,
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  color: Color.fromARGB(255, 232, 202, 244),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FavoriteButton(
                      product: widget.product,
                      id: widget.product.id,
                      title: widget.product.name,
                    ),
                    AddToCartButton(
                      token: '$tokens',
                      productId: widget.product.id,
                    
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(
                        product: widget.product,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 172, 66, 66),
                    borderRadius: BorderRadius.circular(96),
                  ),
                  child: Center(
                    child: Text(
                      'Order',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  height: 85,
                  width: 120,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RowWidget extends StatelessWidget {
  RowWidget({required this.disc, required this.name});
  final String name;
  final String disc;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 24,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            disc,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.green,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
