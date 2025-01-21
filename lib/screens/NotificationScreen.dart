import 'package:delivery/Services/apiNotification.dart';
import 'package:delivery/screens/globals.dart';
import 'package:delivery/screens/store.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final fetchNotificationService _service = fetchNotificationService();
  List<Map<String, dynamic>>? _notifications;
  final tokens = Authmos.tokenmos;
  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  void _fetchNotifications() async {
    final token = "$tokens";
    final notifications = await _service.fetchNotifications(token);
    if (notifications != null) {
      setState(() {
        _notifications = notifications;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Language == true ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar( iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromARGB(255, 170, 43, 193),
          title: Text(
           Language == true ? ' الاشعارات' : 'Notifications',
           style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold), 
          ),
        ),
        body: _notifications == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _notifications!.length,
                itemBuilder: (context, index) {
                   final notification = _notifications!.reversed.toList()[index];
                  return Column(
                    children: [
                      Container(
                        color: Colors.grey[200], 
                        margin: EdgeInsets.symmetric(
                            vertical: 1.0), 
                        child: ListTile(
                          title: Row(
                            children: [
                              Icon(
                                Icons.notifications_active,
                                color: Colors.purpleAccent,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                notification['message'] ?? '',
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 15),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              SizedBox(
                                width: 40,
                              ),
                              Text(notification['created_at']?.substring(0, 10) ??
                                  ''),
                            ],
                          ),
                          trailing: notification['read'] == true
                              ? Icon(Icons.check_circle, color: Colors.green)
                              : Icon(Icons.circle, color: Colors.red),
                        ),
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
