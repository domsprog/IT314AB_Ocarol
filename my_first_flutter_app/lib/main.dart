import 'package:flutter/material.dart';
import 'student_details.dart';
import 'student_list.dart';
import 'student_add.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/student-list',
      routes: {
        '/student-list': (context) => const MyHomePage(),
        '/add-student': (context) => AddStudent(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/student-details') {
          final profile = settings.arguments as Profile;
          return MaterialPageRoute(
            builder: (context) => StudentDetails(profile: profile),
          );
        }
        return null;
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Profile {
  String? studentId;
  String? name;
  String? email;
  String? course;
  int? age;
  double? height;
  String? hobby;
  String? image;
  bool studentstatus = true;
  String? favoriteSubject;
  bool isFavorite;

  Profile({
    this.studentId,
    this.name,
    this.email,
    this.course,
    this.age,
    this.height,
    this.hobby,
    this.image,
    required this.studentstatus,
    this.favoriteSubject,
    this.isFavorite = false,
  });
}

class _MyHomePageState extends State<MyHomePage> {
  List<Profile> profiles = [
    Profile(
      studentId: '125690',
      name: 'Dominic Ocarol',
      email: 'dominic@email.com',
      course: 'BSIT 3 - 1',
      age: 23,
      height: 5.11,
      image: 'assets/images/batman.jpg',
      hobby: 'Playing Games and Watching Anime',
      studentstatus: false,
      favoriteSubject: 'History',
    ),
    Profile(
      studentId: '324567',
      name: 'John Doe',
      email: 'john@email.com',
      course: 'BSIT 4 - 2',
      age: 26,
      height: 4.11,
      hobby: 'Watching Anime and Playing Games',
      image: 'assets/images/meepo.jpg',
      studentstatus: false,
      favoriteSubject: 'IT 423',
    ),
    Profile(
      studentId: '097125',
      name: 'Jane Smith',
      email: 'jane@email.com',
      course: 'BSIT 4 - 1',
      age: 24,
      height: 6.11,
      hobby: 'Coffee Lover',
      image: 'assets/images/tuglife.jpg',
      studentstatus: true,
      favoriteSubject: 'COMP 563',
    ),
    Profile(
      studentId: '452891',
      name: 'Michael Lee',
      email: 'micheal@yahoo.com',
      course: 'BSIT 4 - 3',
      age: 26,
      height: 5.09,
      hobby: 'Coding and Cooking',
      image: 'assets/images/bard.jpg',
      studentstatus: true,
      favoriteSubject: 'IT 203',
    ),
    Profile(
      studentId: '023423',
      name: 'Nicol Cruz',
      email: 'nicol@email.com',
      course: 'BSIT 1 - 1',
      age: 18,
      height: 4.11,
      hobby: 'Music and Gaming',
      image: 'assets/images/fat.jpg',
      studentstatus: true,
      favoriteSubject: 'IT 101',
    ),
    Profile(
      studentId: '452215',
      name: 'Ikon Cruz',
      email: 'ikon@yahoo.com',
      course: 'BSIT 2 - 2',
      age: 18,
      height: 4.11,
      hobby: 'Music and Gaming',
      image: 'assets/images/woody.jpg',
      studentstatus: true,
      favoriteSubject: 'MATH 101',
    ),
  ];

  bool isloading = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isloading = false;
      });
    });
  }

  void reloadStudentList() {
    setState(() {
      isloading = true;
    });
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isloading = false;
      });
    });
  }

  void sortStudentsByName() {
    profiles.sort((a, b) {
      return (a.name ?? '').compareTo(b.name ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        title: const Text(
          'Student List',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        // Sort button
        actions: [
          IconButton(
            icon: const Icon(Icons.sort_by_alpha, color: Colors.white),
            onPressed: () {
              setState(() {
                sortStudentsByName();
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Reload Students list',
            onPressed: () {
              reloadStudentList();
            },
          ),
        ],
      ),
      body: StudentList(
        profiles: profiles,
        isloading: isloading,
        reloadStudentList: reloadStudentList,
        deleteStudent: (index) {
          setState(() {
            profiles.removeAt(index);
          });
        },
        editStudent: (index) {},
        isFavorite: (index) {
          setState(() {
            profiles[index].isFavorite = !profiles[index].isFavorite;
          });
        },
      ),
    );
  }
}
