import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MyHomePage());
  }
}

class Profile {
  String? name;
  String? gname;
  String? messages;
  bool? gamestatus;
  bool? isactive;

  Profile({
    this.name,
    this.gname,
    this.messages,
    this.gamestatus = false,
    this.isactive = false,
  });
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Profile> profiles = [
    Profile(
      name: 'MissYouLikeKrazy',
      gname: 'VALORANT',
      gamestatus: true,
      isactive: true,
    ),
    Profile(name: 'bread', 
    gname: 'VALORANT', 
    gamestatus: true, 
    isactive: true
    ),
    Profile(
      name: 'The14th',
      gname: 'VALORANT',
      gamestatus: true,
      isactive: true,
    ),
    Profile(
      name: 'Carlvendish',
      gname: 'VALORANT',
      gamestatus: true,
      isactive: true,
    ),
    Profile(name: 'D1yah',
     gname: 'VALORANT', 
     gamestatus: true, 
     isactive: true),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        title: Text(
          'Social',
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
            fontFamily: 'sans-serif',
          ),
        ),
      ),

      body: ListView(
        children: [
          Row(
            children: [
              SizedBox(width: 20),

              Text(
                'Friends',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(width: 30),

              Text(
                'Messages',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(width: 30),

              Text(
                'Requests',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          Row(
            children: [
              SizedBox(width: 20),
              Expanded(
                child: Card(
                  color: Colors.black,
                  child: Row(
                    children: [
                      SizedBox(width: 15),
                      Icon(Icons.search, color: Colors.black),
                      SizedBox(width: 10),
                      Text(
                        'Search',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                      SizedBox(width: 15),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20),
            ],
          ),

          SizedBox(height: 20),

          Row(
            children: [
              SizedBox(width: 20),
              CircleAvatar(radius: 14, backgroundColor: Colors.red),
              SizedBox(width: 10),
              Text(
                'VALORANT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(width: 8),

              Text('3', style: TextStyle(color: Colors.grey, fontSize: 18)),
            ],
          ),

          SizedBox(height: 15),

          Row(
            children: [
              SizedBox(width: 20),
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.black,
                child: Icon(Icons.person, color: Colors.redAccent, size: 30),
              ),
              SizedBox(width: 10),
              Icon(Icons.circle, color: Colors.green, size: 16),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                  Text(
                    'MissYouLikeKrazy',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Online - VALORANT',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 15),

          Row(
            children: [
              SizedBox(width: 20),
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.black,
                child: Icon(Icons.person, color: Colors.redAccent, size: 30),
              ),
              SizedBox(width: 10),
              Icon(Icons.circle, color: Colors.green, size: 16),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'bread',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Online - VALORANT',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 15),
          Row(
            children: [
              SizedBox(width: 20),
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.black,
                child: Icon(Icons.person, color: Colors.redAccent, size: 30),
              ),
              SizedBox(width: 10),
              Icon(Icons.circle, color: Colors.green, size: 16),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The14th',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Online - VALORANT',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 25),
          Row(
            children: [
              SizedBox(width: 20),

              Text(
                'Online',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(width: 8),

              Text('4', style: TextStyle(color: Colors.black, fontSize: 18)),
            ],
          ),

          SizedBox(height: 15),

          Row(
            children: [
              SizedBox(width: 20),

              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.black,
                child: Icon(Icons.person, color: Colors.white, size: 30),
              ),

              SizedBox(width: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Carlvendish',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    'Away - Riot Mobile',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 15),

          Row(
            children: [
              SizedBox(width: 20),

              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.black,
                child: Icon(Icons.person, color: Colors.white, size: 30),
              ),

              SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'D1yah',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    'Away - Riot Mobile',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
