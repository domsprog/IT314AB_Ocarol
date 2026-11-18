import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/enrollment_model.dart';
import '../../viewmodel/enrollment_viewmodel.dart';
import '../../viewmodel/student_viewmodel.dart';

class EnrollmentScreen extends StatelessWidget {
  const EnrollmentScreen({super.key});

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
    );
  }

  Widget _dropdown<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<T>(
        value: value,
        isExpanded: true,
        dropdownColor: Colors.grey[900],
        style: const TextStyle(color: Colors.white),
        decoration: _decoration(label),
        items: items,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final students = context.watch<StudentViewModel>().students;

    final vm = context.watch<EnrollmentViewModel>();

    final studentItems = students.map((student) {
      return DropdownMenuItem<int>(
        value: student.studentId!,
        child: Text(
          '${student.fullName} (${student.studentNumber})',
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList();

    final subjectItems = vm.subjects.map((subject) {
      return DropdownMenuItem<int>(
        value: subject.subjectId!,
        child: Text(
          '${subject.subjectCode} - ${subject.subjectName}',
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList();

    final scheduleItems = vm.schedules.map((schedule) {
      bool isFull = schedule.isFull();

      int slotsLeft = schedule.getSlotsLeft();

      String timeRange = schedule.getTimeRange();

      return DropdownMenuItem<int>(
        value: schedule.scheduleId,

        enabled: isFull == false,

        child: Text(
          '${schedule.dayOfWeek} $timeRange - '
          '${schedule.room} - '
          '${isFull ? "FULL" : "$slotsLeft slots left"}',

          overflow: TextOverflow.ellipsis,

          style: TextStyle(color: isFull ? Colors.grey : Colors.white),
        ),
      );
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text(
          'Enrollment',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Enrollment form
          Card(
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(color: Colors.grey, width: 2.0),
            ),

            child: Padding(
              padding: const EdgeInsets.all(12),

              child: Column(
                children: [
                  _dropdown<int>(
                    label: 'Select Student',
                    value: vm.selectedStudentId,
                    items: studentItems,
                    onChanged: vm.selectStudent,
                  ),

                  _dropdown<int>(
                    label: 'Select Subject',
                    value: vm.selectedSubjectId,
                    items: subjectItems,
                    onChanged: vm.selectSubject,
                  ),

                  _dropdown<int>(
                    label: 'Select Schedule',
                    value: vm.selectedScheduleId,
                    items: scheduleItems,
                    onChanged: vm.selectSchedule,
                  ),

                  if (vm.selectedSubjectId != null && vm.schedules.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text(
                        'No schedules for this subject yet.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),

                  ElevatedButton(
                    onPressed: vm.isSaving
                        ? null
                        : () async {
                            final messenger = ScaffoldMessenger.of(context);

                            final ok = await context
                                .read<EnrollmentViewModel>()
                                .enroll();

                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(
                                  ok
                                      ? 'Enrollment successful.'
                                      : vm.errorMessage ?? 'Enrollment failed.',
                                ),
                              ),
                            );
                          },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),

                    child: vm.isSaving
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Enroll Student'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Enrolled Subjects',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          if (vm.selectedStudentId == null)
            const Text(
              'Select a student to see their subjects.',
              style: TextStyle(color: Colors.white70),
            )
          else if (vm.isLoading)
            const Center(child: CircularProgressIndicator(color: Colors.blue))
          else if (vm.enrollments.isEmpty)
            const Text(
              'This student has no enrollments yet.',
              style: TextStyle(color: Colors.white70),
            )
          else
            ...vm.enrollments.map((enrollment) {
              return _EnrollmentCard(enrollment: enrollment);
            }).toList(),
        ],
      ),
    );
  }
}

class _EnrollmentCard extends StatelessWidget {
  final Enrollment enrollment;

  const _EnrollmentCard({required this.enrollment});

  @override
  Widget build(BuildContext context) {
    final e = enrollment;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),

      child: Padding(
        padding: const EdgeInsets.all(12),

        child: Column(
          children: [
            Text(
              '${e.subjectCode} - ${e.subjectName}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              '${e.dayOfWeek} ${e.timeRange}\nRoom: ${e.room}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),

            const SizedBox(height: 8),

            Text(
              'Status: ${e.status}',
              style: TextStyle(
                color: e.isEnrolled ? Colors.green : Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),

            if (e.isEnrolled)
              TextButton.icon(
                onPressed: () => _confirmDrop(context),
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                label: const Text(
                  'Drop Subject',
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDrop(BuildContext context) async {
    final vm = context.read<EnrollmentViewModel>();
    final messenger = ScaffoldMessenger.of(context);

    final ok = await showDialog<bool>(
      context: context,

      builder: (d) => AlertDialog(
        title: const Text('Drop subject?'),

        content: Text('Drop ${enrollment.subjectCode} for this student?'),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d, false),
            child: const Text('Cancel'),
          ),

          TextButton(
            onPressed: () => Navigator.pop(d, true),
            child: const Text('Drop'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    final success = await vm.drop(enrollment.enrollmentId);

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Subject dropped.' : vm.errorMessage ?? 'Drop failed.',
        ),
      ),
    );
  }
}
