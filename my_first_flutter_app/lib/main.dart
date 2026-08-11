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
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color.fromARGB(255, 3, 3, 3),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //Application Title
          const Text(
            'Welcome to My First Flutter Application\n',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          CircleAvatar(
            radius: 100,
            backgroundColor: Colors.white,
            backgroundImage: const AssetImage('assets/images/batman.jpg'),
          ),

          const SizedBox(height: 20),

          // Name and Course
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Dominic Ocarol\n',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 20),

              const Text(
                'BSIT 3 - 1\n',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Hobby
          const Text(
            'Hobby: Playing Video Games, Watching Movies, and Reading Books\n',
            style: TextStyle(fontSize: 24, color: Colors.white),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 5),

          // Date
          const Text(
            'June 6, 2024',
            style: TextStyle(fontSize: 15, color: Colors.white),

            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Favorite Game
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: const [
                  Text(
                    'My favorite game is:  Dota2 , Valorant',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Favorite Movie and Food
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'My favorite movie is: The Dark Knight\n',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Favorite Food
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'My favorite Food is: Adobo\n',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          
        ],
      ),
    );
  }
}
