import 'package:delivery/Services/apiAdminOrder.dart';
import 'package:delivery/Services/apiorder.dart';
import 'package:delivery/screens/editorder.dart';
import 'package:delivery/screens/globals.dart';
import 'package:delivery/screens/store.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class OrdersScreen extends StatefulWidget {
  final bool showButtons;
  const OrdersScreen({Key? key, this.showButtons = false}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final String? tokens = Authmos.tokenmos;
 final String baseUrl = "http://192.168.1.8:8001/api";
  void deleteOrder(
    String token,
    String orderId,
  ) async {
    final String apiUrl = '$baseUrl/orders/$orderId';

    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order $orderId deleted successfully.'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {}); 
      } else {
        throw Exception('Failed to delete order: ${response.statusCode}');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting order: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Language == true ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 88, 31, 132),
          iconTheme: const IconThemeData(color: Colors.white),
          title:  Text(
              Language == true ? ' الطلبات' : 'Order ',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchOrders('$tokens'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No orders available.'));
            }
      
            final orders = snapshot.data!;
      
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.5 / 2,
                ),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order number : ${order['id']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Total: \$${order['total_price']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Payment: ${order['payment_method']}'),
                          Text('Status: ${order['status']}'),
                          if (!widget.showButtons)
                            Row(
                              children: [
                                if (order['status'] == "Pending")
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OrderDetailsScreen(
                                            statuss: true,
                                            orderProducts:
                                                order['order_products'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'View Products',
                                      style: TextStyle(
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                if (order['status'] != "Pending")
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OrderDetailsScreen(
                                            orderProducts:
                                                order['order_products'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'View Products',
                                      style: TextStyle(
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                if (order['status'] == "Pending")
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () =>
                                        deleteOrder('$tokens', '${order['id']}'),
                                  ),
                              ],
                            ),
                          if (widget.showButtons)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (order['status'] == "Pending")
                                  IconButton(
                                    icon: Transform.scale(
                                      scale: 1.3,
                                      child: Icon(
                                        Icons.check,
                                        size: 30,
                                        weight: 30,
                                        color: Colors.green,
                                      ),
                                    ),
                                    onPressed: () async {
                                      final apiService = Apiadminorder();
      
                                      final response =
                                          await apiService.acceptOrder(
                                              '$tokens', '${order['id']}');
      
                                      if (response.containsKey("error")) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "Error: ${response['error']}"),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "Order Accepted: ${response['order']['status']}"),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                SizedBox(
                                  width: 35,
                                ),
                                if (order['status'] == "Pending")
                                  IconButton(
                                    icon: Transform.scale(
                                      scale: 1.3,
                                      child: Icon(Icons.close,
                                          size: 30, color: Colors.red),
                                    ),
                                    onPressed: () async {
                                      
                                      final apiService =
                                          Apiadminorder(); 
      
                                      final reason =
                                          "declining"; 
      
                                      
                                      final response =
                                          await apiService.declineOrder(
                                        token: '$tokens',
                                        orderId: order['id'],
                                        reason: reason,
                                      );
      
                                      
                                      if (response['error'] != null) {
                                        
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "Order decline failed: ${response['error']}"),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      } else {
                                        
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "Order declined successfully."),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class OrderDetailsScreen extends StatelessWidget {
  final List<dynamic> orderProducts;
  bool statuss;
  OrderDetailsScreen(
      {Key? key, required this.orderProducts, this.statuss = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imagehttp = AppImage.appImage;

    return Directionality(
      textDirection: Language == true ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title:
               Text(
              Language == true ? 'تفاصيل الطلب' : 'Order Products',
              style: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromARGB(255, 88, 31, 132),
        ),
        body: ListView.builder(
          itemCount: orderProducts.length,
          itemBuilder: (context, index) {
            final product = orderProducts[index];
            final productDetails = product['product_details'];
      
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                margin: const EdgeInsets.all(8),
                elevation: 4,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                  
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
                            '${productDetails['image']}',
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child; 
                              } else {
                              
                                Future.delayed(Duration(seconds: 1), () {
                              
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${productDetails['name']}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Text('Quantity: ${product['quantity']}'),
                                const SizedBox(width: 12),
                                Text('Price: \$${productDetails['price']}'),
                                const SizedBox(width: 42),
                                if (statuss)
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UpdateOrderScreen(
                                            orderId: product['order_id'] ?? 0,
                                            orderProduct_id:
                                                product['product_id'] ?? 0,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
