import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/grade_model.dart';
import '../../viewmodel/grade_viewmodel.dart';
import '../../viewmodel/student_viewmodel.dart';
import '../grade/grade_from_view.dart';

class GradeListScreen extends StatefulWidget {
  final int? studentId;
  const GradeListScreen({super.key, this.studentId});

  @override
  State<GradeListScreen> createState() => _GradeListScreenState();
}

class _GradeListScreenState extends State<GradeListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<GradeViewModel>();
      if (widget.studentId != null) {
        vm.selectStudent(widget.studentId);
      } else if (vm.selectedStudentId != null) {
        vm.loadGrades();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GradeViewModel>();
    final students = context.watch<StudentViewModel>().students;
    final selected = students.any((s) => s.studentId == vm.selectedStudentId)
        ? vm.selectedStudentId
        : null;

    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        title: const Text(
          'Grade List',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            tooltip: 'Add Grade',
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => GradeForm(studentId: selected)),
            ),
          ),
          IconButton(
            tooltip: 'Reload',
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: vm.loadGrades,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField<int>(
              value: selected,
              isExpanded: true,
              dropdownColor: Colors.grey[900],
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Select Student',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              items: students
                  .map(
                    (s) => DropdownMenuItem(
                      value: s.studentId!,
                      child: Text(
                        '${s.fullName} (${s.studentNumber})',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: vm.selectStudent,
            ),
          ),
          Expanded(child: _body(context, vm, selected)),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, GradeViewModel vm, int? selected) {
    if (selected == null) {
      return const Center(
        child: Text(
          'Select a student to view grades.',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.blue));
    }
    if (vm.errorMessage != null && vm.grades.isEmpty) {
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
    if (vm.grades.isEmpty) {
      return const Center(
        child: Text(
          'No grades recorded for this student.',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    final average = vm.getAverage()!;
    return ListView(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'Average: ${average.toStringAsFixed(2)}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...vm.grades.map((g) => _GradeCard(grade: g)),
      ],
    );
  }
}

class _GradeCard extends StatelessWidget {
  final Grade grade;
  const _GradeCard({required this.grade});

  @override
  Widget build(BuildContext context) {
    final g = grade;
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              '${g.subjectCode} - ${g.subjectName}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Grade: ${g.gradeValue.toStringAsFixed(2)}',
              style: TextStyle(
                color: g.isPassing() ? Colors.green : Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Remarks: ${(g.remarks == null || g.remarks!.isEmpty) ? 'None' : g.remarks}\n'
              'Recorded: ${g.dateRecorded?.toString().split(' ').first ?? '-'}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  tooltip: 'Edit',
                  icon: const Icon(Icons.edit),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => GradeForm(grade: g)),
                  ),
                ),
                IconButton(
                  tooltip: 'Delete',
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final vm = context.read<GradeViewModel>();
    final messenger = ScaffoldMessenger.of(context);

    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: const Text('Delete grade?'),
        content: Text('Delete the grade for ${grade.subjectCode}?'),
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

    final success = await vm.deleteGrade(grade.gradeId!);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Grade deleted.' : vm.errorMessage ?? 'Delete failed.',
        ),
      ),
    );
  }
}
