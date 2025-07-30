import 'package:finura_frontend/services/local_database/local_database_helper.dart';
import 'package:finura_frontend/services/server%20connection/sync__service.dart';
import 'package:finura_frontend/views/loninPage/login.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await FinuraLocalDbHelper().resetDatabase(); // 🔥 Wipes old DB

  // 🔥 Start sync right on app startup
  await SyncService.syncAll();

  runApp(
    MyApp(), // Wrap your app
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finora the budgetbot',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
      ),
      navigatorKey: FinuraLocalDbHelper.navigatorKey,

      //debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
