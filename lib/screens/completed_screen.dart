import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../global.dart';
import '../models/schedule_item.dart';
import '../widgets/form_dialog.dart';

class CpmpletedScreen extends StatefulWidget {
  const CpmpletedScreen({super.key});

  @override
  State<CpmpletedScreen> createState() => _CpmpletedScreenState();
}

class _CpmpletedScreenState extends State<CpmpletedScreen> {
  @override
  Widget build(BuildContext context) {
    List<ScheduleItem> completedItems =
        Provider.of<CompletedItemsProvider>(context).completedItems;
    return ListView.builder(
      itemCount: completedItems.length,
      itemBuilder: (context, index) {
        ScheduleItem submission = completedItems[index];
        return completedItems.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/lottie files/welcome.json'),
                    const Text('Waiting to ADD Schedules'),
                  ],
                ),
              )
            : SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: Card(
                  elevation: 3,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 10,
                      backgroundColor:
                          submission.priority == NotificationPriority.high
                              ? Colors.redAccent
                              : Colors.green,
                    ),
                    title: RichText(
                      text: TextSpan(
                        text: submission.subject,
                        style: myTextStyle.copyWith(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ),
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
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}
