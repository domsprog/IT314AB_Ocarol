import 'package:flutter/material.dart';
import 'main.dart';

class StudentDetails extends StatelessWidget {
  final Profile profile;
  const StudentDetails({super.key, required this.profile});
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Student Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              profile.name ?? 'Not Found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            Text(
              profile.studentId ?? 'Not Found',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 10),

            Text(
              profile.email ?? 'Not Found',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 10),

            Text(
              profile.course ?? 'Not Found',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            IconButton(
              tooltip: 'Edit',
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          profile.name ?? 'Not Found',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),

                        Text(
                          profile.studentId ?? 'Not Found',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        SizedBox(height: 10),

                        Text(
                          profile.email ?? 'Not Found',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        SizedBox(height: 10),

                        Text(
                          profile.course ?? 'Not Found',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.edit, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
