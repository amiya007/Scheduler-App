import 'dart:developer';

import 'package:brandbakerz_assignment/blocs/sign_in_bloc.dart';
import 'package:brandbakerz_assignment/global.dart';
import 'package:brandbakerz_assignment/screens/sign_up.dart';
import 'package:brandbakerz_assignment/widgets/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_10y.dart';
import '../screens/home.dart';
import 'package:flutter/material.dart';
import 'blocs/sign_up_bloc.dart';

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initializeTimeZones();

  AndroidInitializationSettings androidSettings =
      const AndroidInitializationSettings("@mipmap/ic_launcher");

  DarwinInitializationSettings iosSettings = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      requestSoundPermission: true);

  InitializationSettings initializationSettings =
      InitializationSettings(android: androidSettings, iOS: iosSettings);

  bool? initialized = await notificationsPlugin.initialize(
    initializationSettings,
  );
  await Firebase.initializeApp();
  log("Notifications: $initialized");
  final authService = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  runApp(MyApp(
    authService: authService,
    firestore: firestore,
  ));
}

class MyApp extends StatelessWidget {
  final FirebaseAuth authService;
  final FirebaseFirestore firestore;

  const MyApp({Key? key, required this.authService, required this.firestore})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignUpBloc>(
          create: (BuildContext context) =>
              SignUpBloc(firebaseAuth: firebaseAuth, firestore: firestore),
        ),
        BlocProvider<SignInBloc>(
          create: ((BuildContext context) {
            return SignInBloc(SignInInitial());
          }),
        ),
      ],
      child: ChangeNotifierProvider(
      create: (_) => CompletedItemsProvider(), 
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: '/splashscreen',
          routes: {
            '/home': (_) => const HomePage(),
            '/signup': (_) => const SignUpForm(),
            '/splashscreen': (_) => const SplashScreen()
          },
        ),
      ),
    );
  }
}
