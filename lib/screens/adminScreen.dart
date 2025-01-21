
import 'package:delivery/Services/apiMakeadmi.dart';
import 'package:delivery/screens/globals.dart';
import 'package:delivery/screens/orderScreen.dart';
import 'package:delivery/screens/store.dart';
import 'package:delivery/screens/storeListPage.dart';
import 'package:flutter/material.dart';


class Adminscreen extends StatefulWidget {
  const Adminscreen({super.key});

  @override
  State<Adminscreen> createState() => _AdminscreenState();
}

class _AdminscreenState extends State<Adminscreen> {
     final tokens = Authmos.tokenmos;

  void _showMakeAdminDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => MakeAdminDialog(token:  '$tokens'),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Language == true ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              Language == true ? ' لوحة الإدارة' : 'Admin ',
      
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color.fromARGB(255, 88, 31, 132),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            ButtonAdmin(
              name: 
                Language == true ? ' اضف مشرف' :'Make Admin',
              ontap: () => _showMakeAdminDialog(context),
            ), Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 5 ),
              child: Divider(),
            ),
            
            ButtonAdmin(
              name:
                 Language == true ? ' المتاجر & المنتجات ' :'Store & Product',
              ontap: () =>Navigator.push(
                    context, MaterialPageRoute(builder: (_) => StoreListPage(showButtons: true,))),
            ), Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 5 ),
              child: Divider(),
            ),
            
            ButtonAdmin(
              name: 
                Language == true ? ' الموافقة على الطلبات او الرفض' :'Ordeer accepted & declined',
      
              ontap: () =>Navigator.push(context,
                    MaterialPageRoute(builder: (_) => OrdersScreen(showButtons: true,)))
            ),
          
          ],
        ),
      ),
    );
  }
}

class ButtonAdmin extends StatelessWidget {
  ButtonAdmin({required this.name, required this.ontap});
  final String name;
  final VoidCallback? ontap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      child: GestureDetector(
        onTap: ontap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            color: Color.fromARGB(255, 192, 76, 221),
          ),
          height: 60,
          child: Center(
            child: Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}




class MakeAdminDialog extends StatefulWidget {
  final String token;

  MakeAdminDialog({required this.token});

  @override
  _MakeAdminDialogState createState() => _MakeAdminDialogState();
}

class _MakeAdminDialogState extends State<MakeAdminDialog> {
  final _phoneNumberController = TextEditingController();


  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.purple),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.purple, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.purple, width: 2),
      ),
    );
  }


  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('User has been made an admin successfully.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }


  void _showFailureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Failed to make user admin. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Make Admin',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 16),
   
            TextFormField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: _inputDecoration('Enter Phone Number'),
            ),
            const SizedBox(height: 16),
       
            ElevatedButton(
              onPressed: () async {
                String phoneNumber = _phoneNumberController.text;
                if (phoneNumber.isNotEmpty) {
                  bool success = await makeAdmin(
                      phoneNumber: phoneNumber, token: widget.token);
                  if (success) {
                    Navigator.pop(context);
                    _showSuccessDialog();


} else {
                    _showFailureDialog();
                  }
                } else {
                  _showFailureDialog();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
              child: const Text('OK',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}