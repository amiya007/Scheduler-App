import 'dart:async';
import 'dart:convert';

import 'package:brandbakerz_assignment/models/schedule_item.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/form_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ScheduleItem> inCompletedItems = [];
  bool isChecked = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  void handleFormSubmit(String subject, DateTime startTime, DateTime endTime,
      NotificationPriority? priority, Occurence? occurence) {
    ScheduleItem submission = ScheduleItem(
      subject: subject,
      startTime: startTime,
      priority: priority,
      occurence: occurence,
      endTime: endTime,
    );
    setState(() {
      inCompletedItems.add(submission);
    });
    _saveFormSubmissions();
  }

  void loadAllTasks() async {
    final jsonData = await storage.read(key: 'allTasks');
    if (jsonData != null) {
      final List<dynamic> jsonList = jsonDecode(jsonData);

      setState(() {
        allItems = jsonList.map((json) => ScheduleItem.fromJson(json)).toList();
        inCompletedItems =
            allItems.where((item) => !(item.isCompleted!)).toList();
      });
    }
  }

  void _saveFormSubmissions() async {
    final jsonData = inCompletedItems.map((item) => item.toJson()).toList();
    await storage.write(key: 'allTasks', value: jsonEncode(jsonData));
  }

  void _deleteFormSubmission(int index) {
    setState(() {
      ScheduleItem completedItem = inCompletedItems.removeAt(index);
      completedItem.isCompleted = true;
      _saveFormSubmissions();
      Provider.of<CompletedItemsProvider>(context, listen: false)
          .addCompletedItem(completedItem);
      isChecked = false;
    });
  }

  Future<void> cancelNotification(int notificationId) async {
    await notificationsPlugin.cancel(notificationId);
  }

  @override
  void initState() {
    super.initState();
    loadAllTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: inCompletedItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/lottie files/welcome.json'),
                  const Text('Waiting to ADD Schedules'),
                ],
              ),
            )
          : ListView.builder(
              itemCount: inCompletedItems.length,
              itemBuilder: (context, index) {
                ScheduleItem submission = inCompletedItems[index];
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 13, vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 10,
                        backgroundColor:
                            submission.priority == NotificationPriority.high
                                ? Colors.redAccent
                                : Colors.green,
                      ),
                      title: Text(submission.subject, style: myTextStyle),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Start Time :${DateFormat('h:mm a').format(submission.startTime)}'),
                          Text(
                              'End Time :${DateFormat('h:mm a').format(submission.endTime)}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.inversePrimary,
                            child: submission.occurence == Occurence.daily
                                ? Text(
                                    'D',
                                    style: myTextStyle,
                                  )
                                : Text(
                                    'W',
                                    style: myTextStyle,
                                  ),
                          ),
                          const SizedBox(width: 10),
                          Checkbox(
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value!;
                                _deleteFormSubmission(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) {
              return FormDialog(
                onFormSubmit: handleFormSubmit,
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
