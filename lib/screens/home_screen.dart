import 'package:flutter/material.dart';
import 'package:mobile/constant/app_state.dart';
import 'package:mobile/screens/login.dart';
import 'package:provider/provider.dart';
import 'home_tab.dart';
import 'history_tab.dart';
import 'profile_tab.dart';
import 'notification.dart';
import 'package:badges/badges.dart' as badges;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Color.fromARGB(255, 108, 253, 132),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.home), label: 'หน้าหลัก'),
          NavigationDestination(icon: Icon(Icons.history), label: 'ประวัติ'),
          NavigationDestination(icon: Icon(Icons.person), label: 'โปรไฟล์'),
        ],
      ),
      appBar: AppBar(
        title: Text('ระบบปลูกถั่วงอก'),
        backgroundColor: const Color.fromARGB(255, 48, 248, 108),
        actions: [
          Padding(
            padding: EdgeInsets.only(top: 10, right: 15),
            child: badges.Badge(
              position: badges.BadgePosition.topEnd(top: -1, end: -1),
              showBadge: appState.hasUnreadNotifications,
              badgeStyle: badges.BadgeStyle(
                badgeColor: Colors.redAccent,
                borderRadius: BorderRadius.circular(8),
                padding: EdgeInsets.all(6),
                borderSide:
                    BorderSide(color: Colors.white, width: 2), // ขอบสีขาว
              ),
              badgeContent: appState.hasUnreadNotifications
                  ? Text(
                      '${appState.notifications.length}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    )
                  : null,
              child: IconButton(
                icon: Icon(Icons.notifications,
                    size: 28, color: const Color.fromARGB(255, 5, 95, 52)),
                onPressed: () {
                  appState.markNotificationsAsRead();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationSreen(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: [
          HomeTab(), // แถบเมนู "หน้าหลัก"
          HistoryTab(), // แถบเมนู "ประวัติ"
          ProfileTab(
            authController: authController,
          ), // แถบเมนู "โปรไฟล์"
        ],
      ),
    );
  }
}
