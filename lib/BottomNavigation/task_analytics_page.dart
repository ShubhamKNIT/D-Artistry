import 'package:flutter/material.dart';

class TaskAnalyticsPage extends StatelessWidget {
  const TaskAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Task Analytics Page',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text('Display task analytics and charts here'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement a feature to refresh or update analytics
          // For example, fetch and display the latest data

        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
