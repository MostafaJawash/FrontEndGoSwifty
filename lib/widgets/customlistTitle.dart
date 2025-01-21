import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String nameWidget;
  final IconData icon;

  final VoidCallback? ontap;

  const CustomListTile({
    super.key,
    required this.nameWidget,
    required this.icon,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            nameWidget,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          leading: Icon(
            icon,
            color: const Color.fromARGB(255, 136, 245, 225),
          ),
          onTap: ontap,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Divider(),
        ),
      ],
    );
  }
}
