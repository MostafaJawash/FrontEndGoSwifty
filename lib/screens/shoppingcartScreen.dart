import 'package:delivery/Services/apicart.dart';
import 'package:delivery/screens/globals.dart';
import 'package:delivery/screens/store.dart';
import 'package:flutter/material.dart';

class ShoppingCartPage extends StatefulWidget {
  final String token;

  ShoppingCartPage({
    required this.token,
  });

  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  late Future<List<CartItem>> futureCartItems;
  late ShowCartApi cartApi; 
  final tokens = Authmos.tokenmos;
  @override
  void initState() {
    super.initState();
    cartApi = ShowCartApi();
    futureCartItems = cartApi.getCart(
      widget.token,
    ); 
  }

  void _reloadCart() {
    setState(() {
      futureCartItems = cartApi.getCart(
        widget.token,
      ); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Language == true ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              Language == true ? "سلة التسوق" : 'Shopping Cart ',
            
             style: TextStyle(color: Colors.white)),
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Color.fromARGB(255, 88, 31, 132),
            actions: [
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: _reloadCart,
              ),
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                 
                  showDialog(
                    context: context,
                    builder: (context) {
                      return PlaceOrderPopup(
                        placeOrder: placeOrder, 
                        token: '$tokens',
                         onOrderSuccess: _reloadCart,
                      );
                    },
                  );
                },
              ),
            ],
          ),
          body: FutureBuilder<List<CartItem>>(
            future: futureCartItems,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('فشل في تحميل البيانات: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final cartItems = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 228, 175, 247),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                      '${item.product.image}',
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
                                        
                                          'lib/assest/stor.jpeg',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '${item.product.name}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 119, 3, 234)),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Divider(
                                  color: Color.fromARGB(255, 97, 4, 116),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Color.fromARGB(255, 124, 35, 202),
                                    ),
                                    onPressed: () async {
                                      final itemId = item.product
                                          .id; 
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('حذف المنتج'),
                                            content: Text(
                                                'هل أنت متأكد أنك تريد حذف هذا المنتج من السلة؟'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context); 
                                                },
                                                child: Text('إلغاء'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  Navigator.pop(
                                                      context); 
                                                  await CartApi.deleteCartItem(
                                                      itemId, widget.token);
                                                  _reloadCart(); 
                                                },
                                                child: Text('نعم'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  SizedBox(width: 30),
                                  IconButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 220, 134, 251),
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20)),
                                        ),
                                        builder: (BuildContext context) {
                                          return DetailsSheet(
                                            title: 'تفاصيل السلة',
                                            quantity: '${item.quantity}',
                                            location: '${item.product.storeId}',
                                            paymentMethod: 'N/A',
                                            description: item.product.description,
                                            price: '${item.product.price}',
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.expand_more),
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
              } else {
                return Center(child: Text(
                  Language == true ? 'لا يوجد عناصر مضافة الى السلة' : ' There are no items added to Shopping Cart',
                
                ));
              }
            },
          )),
    );
  }
}

class AddToCartButton extends StatefulWidget {
  final String productId;
  final String token;

  const AddToCartButton({
    Key? key,
    required this.productId,
    required this.token,
  }) : super(key: key);

  @override
  _AddToCartButtonState createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  bool isAddedToCart = false; 

  Future<void> showQuantityDialog(BuildContext context) async {
    int quantity = 1; 

  
    final result = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Center(
            child: Text(
              'Select Quantity',
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Quantity: $quantity',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove, color: Colors.deepPurple),
                        onPressed: quantity > 1
                            ? () => setState(() => quantity--)
                            : null,
                      ),
                      Text(
                        '$quantity',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.deepPurple),
                        onPressed: () => setState(() => quantity++),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context), 
              child: Text(
                'Cancel',
                style: TextStyle(color: const Color.fromARGB(255, 164, 18, 2)),
              ),
            ),
            SizedBox(
              width: 40,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.pop(context, quantity), 
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (result != null) {
      await handleAddToCart(result); 
    }
  }

  Future<void> handleAddToCart(int quantity) async {
  
    final cartApi = CartApi(widget.token);

 
    final success = await cartApi.addToCart(
      productId: widget.productId,
      quantity: quantity.toDouble(),
    );

   
    if (success) {
      setState(() {
        isAddedToCart = true; 
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add product!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isAddedToCart ? Icons.shopping_cart : Icons.add_shopping_cart,
        color: isAddedToCart
            ? Colors.green
            : const Color.fromARGB(255, 155, 155, 155),
        size: 30,
      ),
      onPressed: () => showQuantityDialog(context),
      tooltip: isAddedToCart ? 'Added to Cart' : 'Add to Cart',
    );
  }
}

class DetailsSheet extends StatelessWidget {
  final String title;
  final String quantity;
  final String location;
  final String paymentMethod;
  final String description; 
  final String price; 

  const DetailsSheet({
    Key? key,
    required this.title,
    required this.quantity,
    required this.location,
    required this.paymentMethod,
    required this.description,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.deepPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(Icons.shopping_cart, 'Quantity', quantity),

          const SizedBox(height: 16),
          _buildDetailRow(
              Icons.description, 'Description', description), 
          const SizedBox(height: 16),
          _buildDetailRow(Icons.attach_money, 'Price', price), 
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255)),
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.purple),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              ' $value',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceOrderPopup extends StatefulWidget {
  final Future<Map<String, dynamic>> Function(
      String token, String paymentMethod, String location) placeOrder;
  final String token;
  final VoidCallback onOrderSuccess; 

  const PlaceOrderPopup({
    required this.placeOrder,
    required this.token,
    required this.onOrderSuccess,
    Key? key,
  }) : super(key: key);

  @override
  _PlaceOrderPopupState createState() => _PlaceOrderPopupState();
}

class _PlaceOrderPopupState extends State<PlaceOrderPopup> {
  final TextEditingController _locationController = TextEditingController();
  String? _selectedPaymentMethod;
  final List<String> _paymentMethods = ['Cash', 'Card', 'CashMTN','CashSyriatel'];


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Text(
        'إنشاء الطلب',
        style: TextStyle(color: Color.fromARGB(255, 124, 35, 202)),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('اختر أسلوب الدفع:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedPaymentMethod,
              items: _paymentMethods.map((method) {
                return DropdownMenuItem<String>(
                  value: method,
                  child: Text(method),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                filled: true,
                fillColor: const Color.fromARGB(255, 240, 240, 240),
              ),
            ),
            const SizedBox(height: 20),
            const Text('أدخل الموقع:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'الموقع',
                filled: true,
                fillColor: const Color.fromARGB(255, 240, 240, 240),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
            child: const Text('إلغاء',style: TextStyle(color: Colors.white),),
        ),SizedBox(width: 25,),
        ElevatedButton(
          onPressed: () async {
            if (_selectedPaymentMethod == null || _locationController.text.isEmpty) {
             
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('خطأ'),
                  content: const Text('يرجى تعبئة جميع الحقول قبل المتابعة.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إغلاق'),
                    ),
                  ],
                ),
              );
              return;
            }

            
            final response = await widget.placeOrder(
              widget.token,
              _selectedPaymentMethod!,
              _locationController.text,
            );

            if (response.containsKey('error')) {
             
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('خطأ'),
                  content: Text(response['error']),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إغلاق'),
                    ),
                  ],
                ),
              );
            } else {
         
              widget.onOrderSuccess(); 
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('نجاح'),
                  content: const Text('تم إنشاء الطلب بنجاح!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context); 
                      },
                      child: const Text('إغلاق'),
                    ),
                  ],
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 124, 35, 202),
          ),
         child: const Text('تاكيد',style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }
}
