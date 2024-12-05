import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PaymentScreen extends StatefulWidget {
  PaymentScreen({required this.nameproduct});
  String nameproduct;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? selectedOption;
  final TextEditingController _locationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: const Color(0xff303644),
      appBar: AppBar(
        title: Text('خيارات الطلب'),
        backgroundColor: Color.fromARGB(255, 174, 56, 56),
      ),
      body: ListView(children: [
        const Center(
            child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Text(
            'How many products do you want ?',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        )),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 46),
          child: TextFormField(
            validator: (data) {
              if (data!.isEmpty) {
                return 'Field is required';
              }
            },
            decoration: InputDecoration(
              label: const Text(
                'number',
                style: TextStyle(color: Colors.black),
              ),
              hintText: 'Enter number',
              hintStyle: TextStyle(color: Colors.black),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      const BorderSide(color: Color.fromRGBO(174, 56, 56, 1))),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white)),
            ),
          ),
        ),

 const Center(
            child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            'Choose your Location to deliver the order :',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        )),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          child: Container(
        
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color.fromRGBO(174, 56, 56, 1))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: DropdownButton<String>(
                borderRadius: BorderRadius.circular(20),
                dropdownColor: Color.fromRGBO(170, 73, 73, 1),
                value: selectedOption,
                hint: Text('اختر الموقع', style: TextStyle(color: Colors.black)),
                isExpanded: true,
                items: [
                  DropdownMenuItem(
                    value: 'current',
                    child: Text('الموقع الحالي'),
                  ),
                  //  const  Divider(),
                  DropdownMenuItem(
                    value: 'new',
                    child: Text('اختيار موقع جديد'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedOption = value;
                  });
                },
              ),
            ),
          ),
        ),
        if (selectedOption == 'new') ...[
      
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 50,
            ),
            child: TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'أدخل الموقع الجديد',
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                        color: Color.fromRGBO(174, 56, 56, 1))),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Color.fromRGBO(174, 56, 56, 1),
                    )),
              ),
            ),
          ),
        ],
        const SizedBox(
          height: 60,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 110),
          child: ElevatedButton(
            onPressed: () {
              _showPaymentOptionsDialog(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 172, 66, 66),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            child: const Text(
              'ادفع الآن',
              style: TextStyle(
                fontSize: 18, // حجم النص
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ]),
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
                title: const Text('الدفع عند التوصيل'),
                leading: Icon(Icons.attach_money),
                onTap: () {
                  Navigator.of(context).pop(); // إغلاق النافذة
                  _showConfirmationDialog(
                      context, 'تم اختيار الدفع عند التوصيل');
                },
              ),
              ListTile(
                title: const Text('الدفع الإلكتروني'),
                leading: Icon(Icons.credit_card),
                onTap: () {
                  Navigator.of(context).pop(); // إغلاق النافذة
                  _showElectronicPaymentOptions(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showElectronicPaymentOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('اختر طريقة الدفع الإلكتروني'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('سيريتل كاش'),
                leading: Icon(Icons.mobile_friendly),
                onTap: () {
                  Navigator.of(context).pop(); // إغلاق النافذة
                  _showPinConfirmationDialog(context, 'سيريتل كاش');
                },
              ),
              ListTile(
                title: const Text('MTN كاش'),
                leading: const Icon(Icons.mobile_screen_share),
                onTap: () {
                  Navigator.of(context).pop(); // إغلاق النافذة
                  _showPinConfirmationDialog(context, 'MTN كاش');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPinConfirmationDialog(BuildContext context, String paymentMethod) {
    TextEditingController pinController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد الرمز السري'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('أدخل الرمز السري الخاص بـ $paymentMethod'),
              TextField(
                controller: pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'الرمز السري',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // إلغاء
              },
              child: Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق النافذة
                _showConfirmationDialog(
                    context, 'تم الدفع بنجاح عبر $paymentMethod');
              },
              child: Text('تأكيد'),
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
          title: Text('عملية الدفع'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('موافق'),
            ),
          ],
        );
      },
    );
  }
}



// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: LocationScreen(),
//     );
//   }
// }

// class LocationScreen extends StatefulWidget {
//   @override
//   _LocationScreenState createState() => _LocationScreenState();
// }

// class _LocationScreenState extends State<LocationScreen> {
//   String? _selectedOption;
//   final TextEditingController _locationController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('اختيار الموقع'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             DropdownButton<String>(
//               value: _selectedOption,
//               hint: Text('اختر الموقع'),
//               isExpanded: true,
//               items: [
//                 DropdownMenuItem(
//                   value: 'current',
//                   child: Text('الموقع الحالي'),
//                 ),
//                 DropdownMenuItem(
//                   value: 'new',
//                   child: Text('اختيار موقع جديد'),
//                 ),
//               ],
//               onChanged: (value) {
//                 setState(() {
//                   _selectedOption = value;
//                 });
//               },
//             ),
//             if (_selectedOption == 'new') ...[
//               SizedBox(height: 20),
//               TextField(
//                 controller: _locationController,
//                 decoration: InputDecoration(
//                   labelText: 'أدخل الموقع الجديد',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }