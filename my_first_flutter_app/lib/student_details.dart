import 'package:flutter/material.dart';
import 'main.dart';

class StudentDetails extends StatefulWidget {
  final Profile profile;
  const StudentDetails({super.key, required this.profile});
  @override
  State<StudentDetails> createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  void showEditModal() {
    final profile = widget.profile;
    final nameController = TextEditingController(text: profile.name);
    final emailController = TextEditingController(text: profile.email);
    final courseController = TextEditingController(text: profile.course);
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (modalContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(modalContext).viewInsets.bottom + 16,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Edit Student',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                Text(
                  'Student ID: ${profile.studentId}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),

                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),

                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
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
                  },
                ),
                SizedBox(height: 10),

                TextFormField(
                  controller: courseController,
                  decoration: InputDecoration(
                    labelText: 'Course',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a course';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {

                      setState(() {
                        profile.name = nameController.text.trim();
                        profile.email = emailController.text.trim();
                        profile.course = courseController.text.trim();
                      });

                      // 2. Close the modal
                      Navigator.pop(modalContext);
                    }
                  },
                  child: Text('Save Changes'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;

    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
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
              onPressed: showEditModal,
              icon: const Icon(Icons.edit, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
