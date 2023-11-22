import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:space_lab_tasks/Firestore/analytics_crud.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskAnalyticsPage extends StatefulWidget {
  const TaskAnalyticsPage({Key? key});

  @override
  State<TaskAnalyticsPage> createState() => _TaskAnalyticsPageState();
}

class _TaskAnalyticsPageState extends State<TaskAnalyticsPage> {
  int completedTasks = 0;
  int pendingTasks = 0;
  int totalTasks = 0;

  @override
  void initState() {
    super.initState();
    fetchTaskAnalytics();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchTaskAnalytics();
  }

  Future<void> fetchTaskAnalytics() async {
    try {
      final FirestoreAnalyticsCRUD analyticsCRUD = FirestoreAnalyticsCRUD();
      User? user = FirebaseAuth.instance.currentUser;
      Map<String, int> taskAnalytics = await analyticsCRUD.getTotalTasks(user!.uid);

      totalTasks = taskAnalytics['totalTasks'] ?? 0;
      int completed = taskAnalytics['completedTasks'] ?? 0;

      setState(() {
        completedTasks = completed;
        pendingTasks = totalTasks - completed;
      });
    } catch (e) {
      print('Error fetching task analytics: $e');
      // Handle the error appropriately (e.g., show a snackbar, display a message, etc.)
    }
  }

  List<charts.Series<WeekData, String>> _createSampleData() {
    DateTime currentDate = DateTime.now();

    final completedData = List.generate(7, (index) {
      DateTime date = currentDate.subtract(Duration(days: 6 - index));
      String formattedDate = DateFormat('dd MMM').format(date);
      return WeekData(formattedDate, completedTasks);
    });

    final pendingData = List.generate(7, (index) {
      DateTime date = currentDate.subtract(Duration(days: 6 - index));
      String formattedDate = DateFormat('dd MMM').format(date);
      return WeekData(formattedDate, pendingTasks);
    });

    final totalData = List.generate(7, (index) {
      DateTime date = currentDate.subtract(Duration(days: 6 - index));
      String formattedDate = DateFormat('dd MMM').format(date);
      return WeekData(formattedDate, totalTasks);
    });

    return [
      charts.Series<WeekData, String>(
        id: 'Completed',
        domainFn: (WeekData task, _) => task.week,
        measureFn: (WeekData task, _) => task.tasks,
        data: completedData,
        fillColorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.green),
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.green),
      ),
      charts.Series<WeekData, String>(
        id: 'Pending',
        domainFn: (WeekData task, _) => task.week,
        measureFn: (WeekData task, _) => task.tasks,
        data: pendingData,
        fillColorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.red),
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.red),
      ),
      charts.Series<WeekData, String>(
        id: 'Total',
        domainFn: (WeekData task, _) => task.week,
        measureFn: (WeekData task, _) => task.tasks,
        data: totalData,
        fillColorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.blue),
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.blue),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Completed Tasks',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      Text(
                        "$completedTasks",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
                width: MediaQuery.of(context).size.width / 2.5,
                height: MediaQuery.of(context).size.height / 5,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Pending Tasks',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      Text(
                        "$pendingTasks",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
                width: MediaQuery.of(context).size.width / 2.5,
                height: MediaQuery.of(context).size.height / 5,
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: charts.BarChart(
                _createSampleData(),
                animate: true,
                barGroupingType: charts.BarGroupingType.grouped,
                behaviors: [
                  charts.SeriesLegend(
                    position: charts.BehaviorPosition.bottom,
                    horizontalFirst: false,
                    cellPadding: EdgeInsets.all(4.0),

                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WeekData {
  final String week;
  final int tasks;

  WeekData(this.week, this.tasks);
}
