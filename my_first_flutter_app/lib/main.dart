import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 213, 230, 214),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 3, 3, 3),
      ),
     home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Profile {
  String? name;
  String? course;
  int? age;
  double? height;
  String? hobby;
  String? image;
  bool studentstatus = true;

  Profile({
     this.name,
     this.course,
     this.age,
   this.height,
   this.hobby,
   this.image,
    required this.studentstatus,
  });
}

class _MyHomePageState extends State<MyHomePage> {
  final String imagePath = 'assets/images/meepo.jpg';
  final String imagePath2 = 'assets/images/batman.jpg';

  Profile profile = Profile(
    name: 'Dominic Ocarol',
    course: 'BSIT 3 - 1',
    age: 23,
    height: 5.11,
    image: 'assets/images/batman.jpg',
    studentstatus: true,
  );

  Profile profile1 = Profile(
    name: 'John Doe',
    age: 26,
    height: 4.11,
    hobby: 'Watching Anime and Playing Games',
    image: 'assets/images/meepo.jpg',
    studentstatus: true,
  );

  Profile profile2 = Profile(
    course: 'BSIT 4 - 1',
    age: 24,
    height: 6.11,
    hobby: 'Coffe Lover',
    image: 'assets/images/meepo.jpg',
    studentstatus: true,
  );
  Profile profile3 = Profile(
    name: 'Michael Lee',
    course: 'BSIT 4 - 3',
    age: 26,
    height: 5.09,
    hobby: 'Coding and cooking',
    image: 'assets/images/meepo.jpg',
    studentstatus: true,
  );

  Profile profile4 = Profile(
    name: 'Nicol  Cruz',
    course: 'BSIT 1 - 1',
    age: 18,
    height: 4.11,
    hobby: 'Music and Gaming',
    image: 'assets/images/meepo.jpg',
    studentstatus: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Student List',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children:[
                      //Application Title
          const Text(
            'Student List\n',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          //Profile Card 1
        Card(
            color: const Color.fromARGB(255, 255, 255, 255),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                backgroundImage: const AssetImage('assets/images/batman.jpg'),
              ),
              title: Text(
                profile.name??'Unknown',
                style: const TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                'Course: ${profile.course??'Unknown'}\nAge: ${profile.age??'Unknown'}\nHeight: ${profile.height??'Unknown'}\nHobby: ${profile.hobby??'Unknown'}\nStudent Status: ${profile.studentstatus ? 'Active' : 'Inactive'}',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 20),

          //Profile Card 2
          Card(
            color: const Color.fromARGB(255, 255, 255, 255),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                backgroundImage: const AssetImage('assets/images/tuglife.jpg'),
              ),
              title: Text(
                profile1.name??'Unknown',
                style: const TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                'Course: ${profile1.course??'Unknown'}\nAge: ${profile1.age??'Unknown'}\nHeight: ${profile1.height??'Unknown'}\nHobby: ${profile1.hobby??'Unknown'}\nStudent Status: ${profile1.studentstatus ? 'Active' : 'Inactive'}',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 20),

          //Profile Card 3    
          Card(
            color: const Color.fromARGB(255, 255, 255, 255),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                backgroundImage: const AssetImage('assets/images/bard.jpg'),
              ),
              title: Text(
                profile2.name??'Unknown',
                style: const TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                'Course: ${profile2.course??'Unknown'}\nAge: ${profile2.age??'Unknown'}\nHeight: ${profile2.height??'Unknown'}\nHobby: ${profile2.hobby??'Unknown'  }\nStudent Status: ${profile2.studentstatus ? 'Active' : 'Inactive'}',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 20),

          //Profile Card 4
          Card(
            color: const Color.fromARGB(255, 255, 255, 255),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                backgroundImage: const AssetImage('assets/images/fat.jpg'),
              ),
              title: Text(
                profile3.name??'Unknown',
                style: const TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                'Course: ${profile3.course??'Unknown'}\nAge: ${profile3.age??'Unknown'}\nHeight: ${profile3.height??'Unknown'}\nHobby: ${profile3.hobby??'Unknown'}\nStudent Status: ${profile3.studentstatus ? 'Active' : 'Inactive'}',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 20),

           //Profile Card 5
          Card(
            color: const Color.fromARGB(255, 255, 255, 255),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                backgroundImage: const AssetImage('assets/images/meepo.jpg'),
              ),
              title: Text(
                profile4.name??'Unknown',
                style: const TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                'Course: ${profile4.course??'Unknown'}\nAge: ${profile4.age??'Unknown'}\nHeight: ${profile4.height??'Unknown'}\nHobby: ${profile4.hobby??'Unknown'}\nStudent Status: ${profile4.studentstatus ? 'Active' : 'Inactive'}',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          ]//cards 
        )//
      ),
    );
  }
}
