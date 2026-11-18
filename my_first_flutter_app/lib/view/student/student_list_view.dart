import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/student_model.dart';
import '../../viewmodel/student_viewmodel.dart';

class StudentListScreen extends StatelessWidget {
  const StudentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StudentViewModel>();

    return Scaffold(
      backgroundColor: Colors.black26,

      appBar: AppBar(
        title: const Text(
          'Student List',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,

        actions: [
          // Sort button
          IconButton(
            icon: const Icon(Icons.sort_by_alpha, color: Colors.white),
            onPressed: vm.sortByName,
          ),

          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Reload Students list',
            onPressed: vm.loadStudents,
          ),

          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Colors.white),
            color: Colors.black87,

            onSelected: (value) {
              switch (value) {
                case 'add':
                  Navigator.pushNamed(context, '/add-student');
                  break;

                case 'subjects':
                  Navigator.pushNamed(context, '/subject-list');
                  break;

                case 'schedule':
                  Navigator.pushNamed(context, '/schedule-list');
                  break;

                case 'enrollment':
                  Navigator.pushNamed(context, '/enrollment');
                  break;
                case 'grades':
                  Navigator.pushNamed(context, '/grade-list');
                  break;
              }
            },

            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'add',
                child: Row(
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Add Student', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),

              const PopupMenuItem(
                value: 'subjects',
                child: Row(
                  children: [
                    Icon(Icons.menu_book, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Subjects', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),

              const PopupMenuItem(
                value: 'schedule',
                child: Row(
                  children: [
                    Icon(Icons.schedule, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Schedules', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),

              const PopupMenuItem(
                value: 'enrollment',
                child: Row(
                  children: [
                    Icon(Icons.how_to_reg, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Enrollment', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'grades',
                child: Row(
                  children: [
                    Icon(Icons.grade, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Grades', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      body: const StudentList(),
    );
  }
}

class StudentList extends StatelessWidget {
  const StudentList({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StudentViewModel>();

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.blue));
    }

    if (vm.errorMessage != null && vm.students.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            vm.errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }

    if (vm.students.isEmpty) {
      return const Center(
        child: Text(
          'Student list not found.',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: vm.students.length,
      itemBuilder: (context, index) {
        final Student student = vm.students[index];
        final id = student.studentId!;
        return InkWell(
          onTap: () => Navigator.pushNamed(
            context,
            '/student-details',
            arguments: student,
          ),
          child: Card(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 20),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.black,
                    backgroundImage: AssetImage('assets/images/batman.jpg'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    student.fullName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Student Number: ${student.studentNumber}\n'
                    'Email: ${student.email}\n'
                    'Course: ${student.course}\n'
                    'Year Level: ${student.yearLevel}\n'
                    'Contact Number: ${student.contactNumber ?? 'Unknown'}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        tooltip: vm.isFavorite(id)
                            ? 'Remove from favorites'
                            : 'Add to favorites',
                        onPressed: () => vm.toggleFavorite(id),
                        icon: Icon(
                          color: Colors.amber,
                          vm.isFavorite(id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        tooltip: 'Delete',
                        onPressed: () => _confirmDelete(context, student),
                        icon: const Icon(Icons.delete, color: Colors.red),
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

  Future<void> _confirmDelete(BuildContext context, Student student) async {
    final vm = context.read<StudentViewModel>();
    final messenger = ScaffoldMessenger.of(context);

    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: const Text('Delete student?'),
        content: Text('Delete ${student.fullName}? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(d, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    final success = await vm.deleteStudent(student.studentId!);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Student deleted.' : vm.errorMessage ?? 'Delete failed.',
        ),
      ),
    );
  }
}
