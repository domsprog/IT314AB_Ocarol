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
        ],
      ),

      body: isloading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator(color: Colors.blue)],
              ),
            )
          : profiles.isEmpty
          ? Center(
              child: Text(
                'Student list not found.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: profiles.length,
              itemBuilder: (context, index) {
                Profile profile = profiles[index];
                return InkWell(
                  child: Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.black,
                                backgroundImage: AssetImage(
                                  profile.image ?? 'assets/images/meepo.jpg',
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      profile.name ?? 'Unknown',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Student ID: '
                                      '${profile.studentId ?? 'Unknown'}\n'
                                      'Email: '
                                      '${profile.email ?? 'Unknown'}\n'
                                      'Course: '
                                      '${profile.course ?? 'Unknown'}\n'
                                      'Age: '
                                      '${profile.age ?? 'Unknown'}\n'
                                      'Height: '
                                      '${profile.height ?? 'Unknown'}\n'
                                      'Hobby: '
                                      '${profile.hobby ?? 'Unknown'}\n'
                                      'Favorite Subject: '
                                      '${profile.favoriteSubject ?? 'Unknown'}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                    if (profile.studentstatus)
                                      Text(
                                        'Active Student',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      )
                                    else
                                      Text(
                                        'Inactive Student',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                tooltip: profile.isFavorite
                                    ? 'Remove from favorites'
                                    : 'Add to favorites',
                                onPressed: () {
                                  setState(() {
                                    profile.isFavorite = !profile.isFavorite;
                                  });
                                },
                                icon: Icon(
                                  color: Colors.amber,
                                  profile.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                ),
                              ),
                              SizedBox(width: 10),
                              IconButton(
                                tooltip: 'Edit',
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Edit Student'),
                                        content: Text(
                                          'Editing ${profile.name}',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              SizedBox(width: 10),
                              IconButton(
                                tooltip: 'Delete',
                                onPressed: () {
                                  setState(() {
                                    profiles.removeAt(index);
                                  });
                                },
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                              SizedBox(width: 10),
                              IconButton(
                                icon: Icon(Icons.refresh, color: Colors.blue),
                                tooltip: 'Reload Students list',
                                onPressed: () {
                                  reloadStudentList();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
