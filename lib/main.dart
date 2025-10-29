import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/db_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBService.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Roti',
      theme: ThemeData(primarySwatch: Colors.brown),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
