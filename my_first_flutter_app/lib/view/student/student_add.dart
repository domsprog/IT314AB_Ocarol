import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/student_model.dart';
import '../../viewmodel/student_viewmodel.dart';

class AddStudent extends StatelessWidget {
  AddStudent({super.key});
  final _formKey = GlobalKey<FormState>();
  final studentNumberController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final courseController = TextEditingController();
  final yearController = TextEditingController();
  final contactController = TextEditingController();

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      );

  Widget _field(
    TextEditingController controller,
    String label, {
    String? Function(String?)? validator,
    TextInputType? keyboard,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        style: const TextStyle(color: Colors.white),
        decoration: _decoration(label),
        validator: validator,
      ),
    );
  }

  String? _required(String? v, String msg) =>
      (v == null || v.trim().isEmpty) ? msg : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Add Student Screen',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Card(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(color: Colors.grey, width: 2.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _field(
                      studentNumberController,
                      'Enter Student Number',
                      validator: (v) => _required(v, 'Please enter a student number'),
                    ),
                    _field(
                      firstNameController,
                      'Enter First Name',
                      validator: (v) => _required(v, 'Please enter a first name'),
                    ),
                    _field(
                      lastNameController,
                      'Enter Last Name',
                      validator: (v) => _required(v, 'Please enter a last name'),
                    ),
                    _field(
                      courseController,
                      'Enter Course',
                      validator: (v) => _required(v, 'Please enter a course'),
                    ),
                    _field(
                      emailController,
                      'Enter Email Address',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );
                        if (!emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    _field(
                      yearController,
                      'Enter Year Level (1-4)',
                      keyboard: TextInputType.number,
                      validator: (value) {
                        final year = int.tryParse(value ?? '');
                        if (year == null || year < 1 || year > 4) {
                          return 'Year level must be 1 to 4';
                        }
                        return null;
                      },
                    ),
                    _field(
                      contactController,
                      'Enter Contact Number (optional)',
                      keyboard: TextInputType.phone,
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;

                        final vm = context.read<StudentViewModel>();
                        final messenger = ScaffoldMessenger.of(context);
                        final navigator = Navigator.of(context);

                        final newStudent = Student(
                          studentNumber: studentNumberController.text.trim(),
                          firstName: firstNameController.text.trim(),
                          lastName: lastNameController.text.trim(),
                          email: emailController.text.trim(),
                          course: courseController.text.trim(),
                          yearLevel: int.parse(yearController.text.trim()),
                          contactNumber: contactController.text.trim().isEmpty
                              ? null
                              : contactController.text.trim(),
                        );

                        final success = await vm.addStudent(newStudent);
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? 'Student added.'
                                  : vm.errorMessage ?? 'Failed to add student.',
                            ),
                          ),
                        );
                        if (success) navigator.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text('Add Student'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}