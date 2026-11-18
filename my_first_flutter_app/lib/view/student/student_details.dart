import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/student_model.dart';
import '../../viewmodel/student_viewmodel.dart';
import '../grade/grade_list_view.dart';

class StudentDetails extends StatefulWidget {
  final Student student;
  const StudentDetails({super.key, required this.student});
  @override
  State<StudentDetails> createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  void showEditModal(Student student) {
    final firstNameController = TextEditingController(text: student.firstName);
    final lastNameController = TextEditingController(text: student.lastName);
    final emailController = TextEditingController(text: student.email);
    final courseController = TextEditingController(text: student.course);
    final contactController = TextEditingController(
      text: student.contactNumber,
    );
    int yearLevel = student.yearLevel;
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(modalContext).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Edit Student',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Student Number: ${student.studentNumber}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      _modalField(
                        firstNameController,
                        'First Name',
                        (v) => _required(v, 'Please enter a first name'),
                      ),
                      _modalField(
                        lastNameController,
                        'Last Name',
                        (v) => _required(v, 'Please enter a last name'),
                      ),
                      _modalField(emailController, 'Email Address', (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an email';
                        }
                        final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );
                        if (!emailRegex.hasMatch(value.trim())) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      }),
                      _modalField(
                        courseController,
                        'Course',
                        (v) => _required(v, 'Please enter a course'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: DropdownButtonFormField<int>(
                          value: yearLevel,
                          decoration: const InputDecoration(
                            labelText: 'Year Level',
                            border: OutlineInputBorder(),
                          ),
                          items: [1, 2, 3, 4]
                              .map(
                                (y) => DropdownMenuItem(
                                  value: y,
                                  child: Text('Year $y'),
                                ),
                              )
                              .toList(),
                          onChanged: (v) =>
                              setModalState(() => yearLevel = v ?? 1),
                        ),
                      ),
                      _modalField(
                        contactController,
                        'Contact Number (optional)',
                        null,
                      ),
                      const SizedBox(height: 6),
                      ElevatedButton(
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;

                          final vm = context.read<StudentViewModel>();
                          final messenger = ScaffoldMessenger.of(this.context);
                          final navigator = Navigator.of(modalContext);

                          final updated = Student(
                            studentId: student.studentId,
                            studentNumber: student.studentNumber,
                            firstName: firstNameController.text.trim(),
                            lastName: lastNameController.text.trim(),
                            email: emailController.text.trim(),
                            course: courseController.text.trim(),
                            yearLevel: yearLevel,
                            contactNumber: contactController.text.trim().isEmpty
                                ? null
                                : contactController.text.trim(),
                          );

                          final success = await vm.updateStudent(updated);
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? 'Student updated.'
                                    : vm.errorMessage ?? 'Update failed.',
                              ),
                            ),
                          );
                          if (success) navigator.pop();
                        },
                        child: const Text('Save Changes'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String? _required(String? v, String msg) =>
      (v == null || v.trim().isEmpty) ? msg : null;

  Widget _modalField(
    TextEditingController c,
    String label,
    String? Function(String?)? validator,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Look up the latest copy so the screen refreshes after an edit.
    final vm = context.watch<StudentViewModel>();
    final student = vm.students.firstWhere(
      (s) => s.studentId == widget.student.studentId,
      orElse: () => widget.student,
    );

    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
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
              student.fullName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              student.studentNumber,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              student.email,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '${student.course} - Year ${student.yearLevel}',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              student.contactNumber ?? 'No contact number',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            IconButton(
              tooltip: 'Edit',
              onPressed: () => showEditModal(student),
              icon: const Icon(Icons.edit, color: Colors.white),
            ),
            TextButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GradeListScreen(studentId: student.studentId),
                ),
              ),
              icon: const Icon(Icons.grade, color: Colors.white),
              label: const Text(
                'View Grades',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
