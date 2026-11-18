import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'models/student_model.dart';
import 'repository/enrollment_repo.dart';
import 'repository/grade_repo.dart';
import 'repository/schedule_repo.dart';
import 'repository/student_repo.dart';
import 'repository/subject_repo.dart';
import 'viewmodel/enrollment_viewmodel.dart';
import 'viewmodel/grade_viewmodel.dart';
import 'viewmodel/schedule_viewmodel.dart';
import 'viewmodel/student_viewmodel.dart';
import 'viewmodel/subject_viewmodel.dart';
import 'view/enrollment/enrollment_screen.dart';
import 'view/grade/grade_list_view.dart';
import 'view/schedule/schedule_list_view.dart';
import 'view/student/student_add.dart';
import 'view/student/student_details.dart';
import 'view/student/student_list_view.dart';
import 'view/subject/subject_list_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => StudentViewModel(StudentRepository())..loadStudents(),
        ),
        ChangeNotifierProvider(
          create: (_) => SubjectViewModel(SubjectRepository())..loadSubjects(),
        ),
        ChangeNotifierProvider(
          create: (_) => ScheduleViewModel(
            ScheduleRepository(),
            SubjectRepository(),
          )..loadSchedules(),
        ),
        ChangeNotifierProvider(
          create: (_) => EnrollmentViewModel(
            EnrollmentRepository(),
            SubjectRepository(),
            ScheduleRepository(),
          )..loadSubjects(),
        ),
        ChangeNotifierProvider(
          create: (_) => GradeViewModel(GradeRepository()),
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
        '/subject-list': (context) => const SubjectListScreen(),
        '/schedule-list': (context) => const ScheduleListScreen(),
        '/enrollment': (context) => const EnrollmentScreen(),
        '/grade-list': (context) => const GradeListScreen(),
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