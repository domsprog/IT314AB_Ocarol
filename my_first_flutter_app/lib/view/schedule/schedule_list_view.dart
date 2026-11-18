import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/schedule_model.dart';
import '../../viewmodel/schedule_viewmodel.dart';
import '../../view/schedule/schedule_from_view.dart';

class ScheduleListScreen extends StatelessWidget {
  const ScheduleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ScheduleViewModel>();

    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        title: const Text(
          'Schedule List',
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
              MaterialPageRoute(builder: (_) => const ScheduleForm()),
            ),
          ),
          IconButton(
            tooltip: 'Reload',
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: vm.loadSchedules,
          ),
        ],
      ),
      body: _body(context, vm),
    );
  }

  Widget _body(BuildContext context, ScheduleViewModel vm) {
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.blue));
    }
    if (vm.errorMessage != null && vm.schedules.isEmpty) {
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
    if (vm.schedules.isEmpty) {
      return const Center(
        child: Text(
          'Schedule list not found.',
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
      itemCount: vm.schedules.length,
      itemBuilder: (context, index) {
        final Schedule s = vm.schedules[index];
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 20),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  '${s.subjectCode} - ${s.subjectName}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Day: ${s.dayOfWeek}\n'
                  'Time: ${s.getTimeRange()}\n'
                  'Room: ${s.room}\n'
                  'Slots: ${s.enrolledCount} / ${s.slotCapacity} taken',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  s.isFull() ? 'FULL' : '${s.getSlotsLeft()} slot(s) left',
                  style: TextStyle(
                    color: s.isFull() ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
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
                          builder: (_) => ScheduleForm(schedule: s),
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

  Future<void> _confirmDelete(BuildContext context, Schedule s) async {
    final vm = context.read<ScheduleViewModel>();
    final messenger = ScaffoldMessenger.of(context);

    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: const Text('Delete schedule?'),
        content: Text(
          'Delete ${s.subjectCode} on ${s.dayOfWeek} ${s.getTimeRange()}?',
        ),
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

    final success = await vm.deleteSchedule(s.scheduleId!);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Schedule deleted.' : vm.errorMessage ?? 'Delete failed.',
        ),
      ),
    );
  }
}
