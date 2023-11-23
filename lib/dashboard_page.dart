import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:space_lab_tasks/BottomNavigation/task_analytics_page.dart';
import 'package:space_lab_tasks/BottomNavigation/todo_list_page.dart';
import 'package:space_lab_tasks/Profile%20UI/profile_ui.dart';
import 'package:space_lab_tasks/first_page.dart';
import 'package:space_lab_tasks/theme_manager.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedItem = 0; // default selected item index

  final List<Widget> _pages = <Widget>[
    TodoListPage(themeManager: ThemeManager()),
    const TaskAnalyticsPage(),
    const ProfileUI(),
  ];

  void _onItemTapped(int index) {
    setState(
      () {
        _selectedItem = index;
      },
    );
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
    final themeManager = Provider.of<ThemeManager>(context);
    return PopScope(
      child: Theme(
        data: themeManager.isLightTheme ? ThemeData.light() : ThemeData.dark(),
        child: Scaffold(
          body: _selectedItem == 0
              ? TodoListPage(
                  themeManager: ThemeManager(),
                ) // Display TodoListPage when "Home" is selected
              : _pages.elementAt(_selectedItem),
          appBar: AppBar(
            automaticallyImplyLeading: false, // back button removed

            centerTitle: true,

            // Theme logo at the left position
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  themeManager.toggleTheme();
                },
                icon: themeManager.isLightTheme
                    ? const Icon(Icons.dark_mode)
                    : const Icon(Icons.light_mode),
              ),
            ),

            title: const Text('Space Lab Tasks'),

            actions: <Widget>[
              // Sign out button
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
            selectedItemColor: Colors.blue,
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
      ),
      canPop: false,
    );
  }
}
