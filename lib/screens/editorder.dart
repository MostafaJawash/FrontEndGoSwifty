import 'package:delivery/Services/apiorder.dart';
import 'package:delivery/screens/store.dart';
import 'package:flutter/material.dart';

class UpdateOrderScreen extends StatefulWidget {
  final int orderId;
  final int orderProduct_id;

  UpdateOrderScreen({required this.orderId,required this.orderProduct_id});

  @override
  _UpdateOrderScreenState createState() => _UpdateOrderScreenState();
}

class _UpdateOrderScreenState extends State<UpdateOrderScreen> {
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController orderLocationController = TextEditingController();
  String? selectedPaymentMethod;
  final ApiUpdateOrder apiService = ApiUpdateOrder();
  final tokens = Authmos.tokenmos;
  Future<void> updateOrder() async {
    if (selectedPaymentMethod == null) {
      showErrorDialog('يرجى اختيار طريقة الدفع');
      return;
    }

    try {
      final quantity = int.tryParse(quantityController.text) ?? 1;
      final orderLocation = orderLocationController.text;

      final response = await apiService.updateOrder(
        token: '$tokens',
        orderId: '${widget.orderId}',
        orderProductId:'${widget.orderProduct_id}' ,
        quantity: quantity,
        paymentMethod: selectedPaymentMethod!,
        location: orderLocation,
      );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("تم التحديث بنجاح"),
          content: Text(response['message']),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("حسنًا"),
            ),
          ],
        ),
      );
    } catch (error) {
      showErrorDialog(error.toString());
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("خطأ"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("إغلاق"),
          ),
        ],
      ),
    );
  }

  void _showPaymentOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('اختر طريقة الدفع'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Cash'),
                leading: Icon(Icons.attach_money),
                onTap: () {
                  setState(() {
                    selectedPaymentMethod = 'Cash';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Card'),
                leading: Icon(Icons.mobile_friendly),
                onTap: () {
                  setState(() {
                    selectedPaymentMethod = 'Card';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('CashSyriatel'),
                leading: Icon(Icons.mobile_friendly),
                onTap: () {
                  setState(() {
                    selectedPaymentMethod = 'CashSyriatel';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('CashMTN'),
                leading: const Icon(Icons.mobile_screen_share),
                onTap: () {
                  setState(() {
                    selectedPaymentMethod = 'CashMTN';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _customInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.deepPurple),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.purpleAccent, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'تحديث الطلب',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Enter the quantity :',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: quantityController,
              decoration: _customInputDecoration('الكمية'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Enter the location :',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: orderLocationController,
              decoration: _customInputDecoration('الموقع'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showPaymentOptionsDialog(context),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                backgroundColor: const Color.fromARGB(255, 156, 11, 223),
              ),
              child: Text(
                style: TextStyle(color: Colors.white, fontSize: 20),
                selectedPaymentMethod == null
                    ? 'اختر طريقة الدفع'
                    : '$selectedPaymentMethod',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateOrder,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                backgroundColor: Color.fromARGB(255, 156, 11, 223),
              ),
              child: Text(
                'تحديث الطلب',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
