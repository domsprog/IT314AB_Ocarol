import 'package:flutter/material.dart';
import 'main.dart';
import 'student_add.dart';

class StudentList extends StatelessWidget {
  final List<Profile> profiles;
  final bool isloading;
  final void Function() reloadStudentList;
  final void Function(int) deleteStudent;
  final void Function(int) editStudent;
  final void Function(int) isFavorite;

  const StudentList({
    super.key,
    required this.profiles,
    required this.isloading,
    required this.reloadStudentList,
    required this.deleteStudent,
    required this.editStudent,
    required this.isFavorite,
  });

  @override
  Widget build(context) {
    return isloading
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
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/student-details',
                    arguments: profile,
                  );
                },
                child: Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.black,
                              backgroundImage: AssetImage(
                                profile.image ?? 'assets/images/meepo.jpg',
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              profile.name ?? 'Unknown',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
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
                            if (profile.studentstatus == false)
                              Text(
                                'Student Status: Inactive',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            else
                              Text(
                                'Student Status: Active',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
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
                                isFavorite(index);
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
                              tooltip: 'Delete',
                              onPressed: () {
                                deleteStudent(index);
                              },
                              icon: Icon(Icons.delete, color: Colors.red),
                            ),
                            SizedBox(width: 10),
                            IconButton(
                              tooltip: 'Add',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddStudent(),
                                  ),
                                );
                              },
                              icon: Icon(Icons.person, color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
