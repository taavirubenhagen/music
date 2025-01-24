import 'package:flutter/material.dart';
import 'package:v1/player/player.dart';
import 'package:v1/shelf/shelf.dart';


final recordPlayer = RecordPlayer();


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const Shelf(title: 'Flutter Demo Home Page'),
    );
  }
}