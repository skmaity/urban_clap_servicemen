import 'package:flutter/material.dart';
import 'package:urbanclap_servicemen/dash_pages/bookings/bookings_page.dart';
import 'package:urbanclap_servicemen/dash_pages/earnings/earnings_page.dart';
import 'package:urbanclap_servicemen/dash_pages/home/home_page.dart';
import 'package:urbanclap_servicemen/dash_pages/profile_page_dash.dart';
import 'package:urbanclap_servicemen/theme.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
 
  final List<Widget> _pages = [
    HomePage(),
    BookingsPage(),
    EarningsPage(),
    ProfilePageDash()
  ];



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Dashboard'),
      //   backgroundColor: MyTheme.logoColorTheme,
      // ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: MyTheme.logoColorTheme,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Bookings',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.chat),
          //   label: 'Chat',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_rupee_rounded),
            label: 'Earnings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
