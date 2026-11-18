import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/subject_model.dart';
import '../../viewmodel/subject_viewmodel.dart';
import '../subject/subject_form_view.dart';

class SubjectListScreen extends StatelessWidget {
  const SubjectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SubjectViewModel>();

    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        title: const Text(
          'Subject List',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            tooltip: 'Add',
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SubjectForm()),
            ),
          ),
          IconButton(
            tooltip: 'Reload',
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: vm.loadSubjects,
          ),
        ],
      ),
      body: _body(context, vm),
    );
  }

  Widget _body(BuildContext context, SubjectViewModel vm) {
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.blue));
    }
    if (vm.errorMessage != null && vm.subjects.isEmpty) {
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
    if (vm.subjects.isEmpty) {
      return const Center(
        child: Text(
          'Subject list not found.',
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
      itemCount: vm.subjects.length,
      itemBuilder: (context, index) {
        final Subject s = vm.subjects[index];
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 20),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  s.subjectCode,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  s.subjectName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Units: ${s.units}\n'
                  'Description: ${(s.description == null || s.description!.isEmpty) ? 'No description' : s.description}',
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
                        MaterialPageRoute(
                          builder: (_) => SubjectForm(subject: s),
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Delete',
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(context, s),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, Subject s) async {
    final vm = context.read<SubjectViewModel>();
    final messenger = ScaffoldMessenger.of(context);

    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: const Text('Delete subject?'),
        content: Text('Delete ${s.subjectCode} - ${s.subjectName}?'),
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

    final success = await vm.deleteSubject(s.subjectId!);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Subject deleted.' : vm.errorMessage ?? 'Delete failed.',
        ),
      ),
    );
  }
}