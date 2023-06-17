import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'models/schedule_item.dart';

const FlutterSecureStorage storage = FlutterSecureStorage();
var firestore = FirebaseFirestore.instance;
final firebaseAuth = FirebaseAuth.instance;
late List<ScheduleItem> allItems;

class CompletedItemsProvider with ChangeNotifier {
  List<ScheduleItem> _completedItems = [];

  List<ScheduleItem> get completedItems => _completedItems;

  void addCompletedItem(ScheduleItem item) {
    _completedItems.add(item);
    notifyListeners();
  }

  void removeCompletedItem(ScheduleItem item) {
    _completedItems.remove(item);
    notifyListeners();
  }
}

TextStyle myTextStyle = const TextStyle(
  fontSize: 20,
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

InputDecoration myTextfieldDecoration = InputDecoration(
  enabled: true,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
  ),
  filled: true,
  fillColor: Colors.grey[300],
  labelText: 'name',
);

ButtonStyle myButtonDecoration = ButtonStyle(
  elevation: const MaterialStatePropertyAll(6),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: const BorderSide(color: Colors.indigo))),
  backgroundColor: MaterialStateProperty.all(Colors.indigo),
);
