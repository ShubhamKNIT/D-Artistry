import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:space_lab_tasks/BottomNavigation/profile_page.dart';
import 'package:space_lab_tasks/BottomNavigation/task_analytics_page.dart';
import 'package:space_lab_tasks/BottomNavigation/todo_list_page.dart';
import 'package:space_lab_tasks/first_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedItem = 0; // default selected item index

  final List<Widget> _pages = <Widget>[
    const TodoListPage(),
    const TaskAnalyticsPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedItem = index;
    });
  }

  // Sign out of Firebase Auth
  Future<void> _signout() async {
    await FirebaseAuth.instance.signOut();

    // Navigate to the first page after successful signout
    // ignore: use_build_context_synchronously
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FirstPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: _selectedItem == 0
            ? const TodoListPage() // Display TodoListPage when "Home" is selected
            : _pages.elementAt(_selectedItem),

        appBar: AppBar(
          automaticallyImplyLeading: false, // back button removed
          title: const Text('Space Lab Tasks'),

          actions: <Widget>[
            IconButton(
              onPressed: () {
                _signout();
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),

        // Bottom Navigation Bar with 3 items (Home, Task Analytics, Profile)
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: 'Task Analytics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedItem,
          onTap: _onItemTapped,
        ),
      ), 
      onWillPop: () async { // Disable back button
        return false;
      }
    );
  }
}
