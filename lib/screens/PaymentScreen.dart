import 'package:delivery/Services/apiorder.dart';
import 'package:delivery/screens/globals.dart';
import 'package:delivery/screens/orderScreen.dart';
import 'package:delivery/screens/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentScreen extends StatefulWidget {
  final Product product;

  PaymentScreen({required this.product});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
  
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
final tokens = Authmos.tokenmos;
@override
void dispose() {
  locationController.dispose();
  quantityController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Language == true ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title:  Text(
          Language == true ? 'خيارات الطلب' : ' Ordering options',
          ),
          backgroundColor: const Color.fromARGB(255, 174, 56, 56),
        ),
        body: ListView(
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text(
                  'How many products do you want?',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 46),
              child: TextFormField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  label: const Text(
                    'عدد المنتجات'
                    
                    ,
                    style: TextStyle(color: Colors.black),
                  ),
                  hintText: 'أدخل العدد',
                  hintStyle: const TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(color: Color.fromRGBO(174, 56, 56, 1)),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'أدخل موقعك لتوصيل الطلب:',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: 'أدخل الموقع',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Color.fromRGBO(174, 56, 56, 1)),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Color.fromRGBO(174, 56, 56, 1)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 110),
              child: ElevatedButton(
                onPressed: () {
                  if (quantityController.text.isEmpty ||
                      locationController.text.isEmpty) {
                    _showConfirmationDialog(context, "يجب تحديد العدد والموقع");
                    return;
                  }
                  _showPaymentOptionsDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 172, 66, 66),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                child: const Text(
                  'ادفع الآن',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
void _showPaymentOptionsDialog(BuildContext context) {
  if (!mounted) return;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('اختر طريقة الدفع'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPaymentOption('Cash', Icons.attach_money),
            _buildPaymentOption('Card', Icons.account_balance),
            _buildPaymentOption('CashSyriatel', Icons.phone_android),
            _buildPaymentOption('CashMTN', Icons.mobile_screen_share),
          ],
        ),
      );
    },
  );
}


Widget _buildPaymentOption(String title, IconData icon) {
  return Card(
    color: const Color.fromARGB(255, 244, 230, 230),
    child: ListTile(
      title: Text(title),
      leading: Icon(icon, color: const Color.fromRGBO(174, 56, 56, 1)),
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop(); 
        _submitOrder(title); 
      },
    ),
  );
}



Future<void> _submitOrder(String paymentMethod) async {
  try {
    final quantity = double.tryParse(quantityController.text) ?? 0;
    final location = locationController.text;

    final response = await createOrder(
      '$tokens',
      productId: widget.product.id,
      quantity: quantity,
      paymentMethod: paymentMethod,
      orderLocation: location,
    );

 
    _showResultDialog("${response['message']}");
  } catch (e) {
    Navigator.of(context).pop();
    _showResultDialog("حدث خطأ: $e");
  }
}

void _showResultDialog(String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('نتيجة الطلب'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); 
              
            },
            child: const Text('موافق'),
          ),
        ],
      );
    },
  );
}



  void _showConfirmationDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('نتيجة الطلب'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('موافق'),
            ),
          ],
        );
      },
    );
  }
}


 