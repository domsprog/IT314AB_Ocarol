import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My First Flutter Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 213, 230, 214),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 3, 3, 3), 
      ),
      home: const MyHomePage(title: 'My First Flutter Application'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
         style: const TextStyle(color: Colors.white, 
         fontWeight: FontWeight.bold)
        ),
        backgroundColor: const Color.fromARGB(255, 3, 3, 3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Dominic Ocarol, BSIT-3, 07-30,2026',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            CircleAvatar(
              radius: 100,
              backgroundColor: Colors.white,
              backgroundImage: const AssetImage('assets/images/batman.jpg'),    
            ),
          ],
        ),
      ),
    );
  }
}