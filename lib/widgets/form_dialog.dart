import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../global.dart';
import '../main.dart';

class FormDialog extends StatefulWidget {
  final void Function(
          String, DateTime, DateTime, NotificationPriority?, Occurence?)
      onFormSubmit;
  const FormDialog({super.key, required this.onFormSubmit});

  @override
  State<FormDialog> createState() => _FormDialogState();
}

enum NotificationPriority { high, low }

enum Occurence { daily, weekly }

class _FormDialogState extends State<FormDialog> {
  NotificationPriority? selectedPriority = NotificationPriority.high;
  Occurence? selectedOccurence = Occurence.daily;
  final _subjectController = TextEditingController();
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();

  String startTimeText = 'Start Time';
  String endTimeText = 'End Time';

  Future<void> scheduleNotifications() async {
    DateTime startDateTime = startTime;
    DateTime endDateTime = endTime;

    AndroidNotificationDetails startAndroidNotificationDetails =
        const AndroidNotificationDetails(
      'start_channel_id',
      'Start Time Notification',
      importance: Importance.max,
      playSound: true,
      priority: Priority.max,
      fullScreenIntent: true,
    );
    DarwinNotificationDetails startIOSNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    var startNotificationDetails = NotificationDetails(
        android: startAndroidNotificationDetails,
        iOS: startIOSNotificationDetails);

    AndroidNotificationDetails endAndroidNotificationDetails =
        const AndroidNotificationDetails(
      'end_channel_id',
      'End Time Notification',
      importance: Importance.max,
      playSound: true,
      priority: Priority.max,
      fullScreenIntent: true,
    );
    DarwinNotificationDetails endIOSNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    var endNotificationDetails = NotificationDetails(
        android: endAndroidNotificationDetails, iOS: endIOSNotificationDetails);

    await notificationsPlugin.zonedSchedule(
        0, // Unique ID for start time notification
        'Start Time Notification',
        'It\'s time for ${_subjectController.text} to start!',
        tz.TZDateTime.from(startDateTime, tz.local),
        startNotificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        // ignore: deprecated_member_use
        androidAllowWhileIdle: true);

    await notificationsPlugin.zonedSchedule(
        1, // Unique ID for end time notification
        'End Time Notification',
        'It\'s time for ${_subjectController.text} to end!',
        tz.TZDateTime.from(endDateTime, tz.local),
        endNotificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        // ignore: deprecated_member_use
        androidAllowWhileIdle: true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(8),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Create Schedule'),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.cancel),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) {
                      return SizedBox(
                        height: 300,
                        child: CupertinoDatePicker(
                            initialDateTime: DateTime.now(),
                            mode: CupertinoDatePickerMode.time,
                            onDateTimeChanged: (newtime) {
                              setState(() {
                                startTime = newtime;
                                startTimeText =
                                    '${newtime.hour}:${newtime.minute}';
                              });
                            }),
                      );
                    },
                  );
                },
                child: Text(
                  startTimeText,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) {
                      return SizedBox(
                        height: 300,
                        child: CupertinoDatePicker(
                            initialDateTime: DateTime.now(),
                            mode: CupertinoDatePickerMode.time,
                            onDateTimeChanged: (newtime) {
                              setState(() {
                                endTime = newtime;
                                endTimeText =
                                    '${newtime.hour}:${newtime.minute}';
                              });
                            }),
                      );
                    },
                  );
                },
                child: Text(
                  endTimeText,
                ),
              ),
            ],
          ),

          //
          // Set NotificationPriority
          Text('Set Priority',
              style: myTextStyle.copyWith(
                  fontSize: 16, fontWeight: FontWeight.w500)),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: RadioListTile<NotificationPriority>(
                    title: const Text('High'),
                    value: NotificationPriority.high,
                    groupValue: selectedPriority,
                    onChanged: (NotificationPriority? value) {
                      setState(() {
                        selectedPriority = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: RadioListTile<NotificationPriority>(
                    title: const Text('Low'),
                    value: NotificationPriority.low,
                    groupValue: selectedPriority,
                    onChanged: (NotificationPriority? value) {
                      setState(() {
                        selectedPriority = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          //
          // Set Occurence
          Text('Set Occerence',
              style: myTextStyle.copyWith(
                  fontSize: 16, fontWeight: FontWeight.w500)),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: RadioListTile<Occurence>(
                    title: const Text('Daily'),
                    value: Occurence.daily,
                    groupValue: selectedOccurence,
                    onChanged: (Occurence? value) {
                      setState(() {
                        selectedOccurence = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.38,
                  child: RadioListTile<Occurence>(
                    title: const Text('Weekly'),
                    value: Occurence.weekly,
                    groupValue: selectedOccurence,
                    onChanged: (Occurence? value) {
                      setState(() {
                        selectedOccurence = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_subjectController.text.isNotEmpty &&
                  startTimeText != 'Start Time' &&
                  endTimeText != 'End Time' && endTime.isAfter(startTime)) {
                String subject = _subjectController.text;
                DateTime startTime = this.startTime;
                DateTime endTime = this.endTime;
                NotificationPriority? priority = selectedPriority;
                Occurence? occurence = selectedOccurence;

                widget.onFormSubmit(
                  subject,
                  startTime,
                  endTime,
                  priority,
                  occurence,
                );
                scheduleNotifications();
                Navigator.pop(context);
              }
            },
            child: const Text('Done'),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
