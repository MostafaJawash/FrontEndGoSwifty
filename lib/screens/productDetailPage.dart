import 'package:delivery/screens/PaymentScreen.dart';
import 'package:delivery/screens/favoritesPage.dart';
import 'package:delivery/screens/store.dart';

import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  ProductDetailPage({required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  get isFavorite => null;
 final List<Map<String, String>> items = List.generate(
    10,
    (index) => {
      'id': index.toString(),
      'title': 'Item $index',
    },
  );
  @override
  Widget build(BuildContext context) {
      final manager = FavoritesManager();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 82, 92, 115),
        centerTitle: true,
        title: Text(widget.product.name,
            style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(widget.product.imageUrl,
                height: 250, width: 250, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(widget.product.name,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('\$${widget.product.price}',
                style: const TextStyle(fontSize: 24, color: Colors.green)),
            const SizedBox(height: 16),
            const Text(
                'وصف المنتج: هذا المنتج يحتوي على مواصفات رائعة ويوفر تجربة رائعة للمستخدمين.',
                style: TextStyle(fontSize: 16)),
            SizedBox(
              height: 90,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PaymentScreen(nameproduct: widget.product.name)));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 172, 66, 66),
                  borderRadius: BorderRadius.circular(96),
                ),
                child: Center(
                    child: Text('Order',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20))),
                height: 85,
                width: 120,
              ),
            ),
      FavoriteButton(
  id: widget.product.name,
  title: widget.product.name,
),
        
          ],
        ),
      ),
    );
  }
}
