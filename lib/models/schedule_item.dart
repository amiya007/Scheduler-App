import '../widgets/form_dialog.dart';

class ScheduleItem {
  final String subject;
  final DateTime startTime;
  final DateTime endTime;
  final NotificationPriority? priority;
  final Occurence? occurence;
  bool? isCompleted;

  ScheduleItem({
    required this.subject,
    required this.startTime,
    required this.endTime,
    required this.priority,
    required this.occurence,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'priority': priority.toString(),
      'occurence': occurence.toString(),
      'isCompleted': isCompleted.toString(),
    };
  }

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    Occurence? parseOccurence(String? value) {
      if (value == 'Occurence.daily') {
        return Occurence.daily;
      } else if (value == 'Occurence.weekly') {
        return Occurence.weekly;
      }
      return null;
    }

    NotificationPriority? parsePriority(String? value) {
      if (value == 'NotificationPriority.high') {
        return NotificationPriority.high;
      } else if (value == 'NotificationPriority.low') {
        return NotificationPriority.low;
      }
      return null;
    }

    bool? parseBool(String? value) {
      if (value == 'true') {
        return true;
      } else if (value == 'false') {
        return false;
      }
      return null;
    }

    return ScheduleItem(
        subject: json['subject'],
        startTime: DateTime.parse(json['startTime']),
        endTime: DateTime.parse(json['endTime']),
        occurence: parseOccurence(json['occurence']),
        priority: parsePriority(json['priority']),
        isCompleted: parseBool(json['isCompleted']));
  }

  static List<ScheduleItem> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ScheduleItem.fromJson(json)).toList();
  }
}
