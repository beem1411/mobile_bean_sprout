import 'package:flutter/material.dart';
import 'package:mobile/constant/app_state.dart';
import 'package:provider/provider.dart';

class NotificationTile extends StatelessWidget {
  final String title;
  final String? subtitle;

  NotificationTile({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: Icon(
          Icons.notifications,
          color: Colors.green,
        ),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle!) : null,
      ),
    );
  }
}

class NotificationSreen extends StatelessWidget {
  const NotificationSreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("การแจ้งเตือน"),
        backgroundColor: const Color.fromARGB(255, 48, 248, 108),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              appState.clearNotifications();
            },
          ),
        ],
      ),
      body: appState.notifications.isEmpty
          ? Center(child: Text("ไม่มีการแจ้งเตือน"))
          : ListView.builder(
              itemCount: appState.notifications.length,
              itemBuilder: (context, index) {
                final notification = appState.notifications[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    leading: Icon(Icons.notifications, color: Colors.green),
                    title: Text(notification['title']!),
                    subtitle: Text(notification['subtitle']!),
                  ),
                );
              },
            ),
    );
  }
}
