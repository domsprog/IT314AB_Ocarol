import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/student_model.dart';
import 'repository/student_repo.dart';
import 'viewmodel/student_viewmodel.dart';

import 'view/student/student_list_view.dart';
import 'view/student/student_details.dart';
import 'view/student/student_add.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => StudentViewModel(StudentRepository())..loadStudents(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/student-list',
      routes: {
        '/student-list': (context) => const StudentListScreen(),
        '/add-student': (context) => AddStudent(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/student-details') {
          final student = settings.arguments as Student;

          return MaterialPageRoute(
            builder: (context) => StudentDetails(student: student),
          );
        }

        return null;
      },
    );
  }
}
