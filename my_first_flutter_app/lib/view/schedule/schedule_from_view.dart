import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/schedule_model.dart';
import '../../viewmodel/schedule_viewmodel.dart';

class ScheduleForm extends StatefulWidget {
  final Schedule? schedule;
  const ScheduleForm({super.key, this.schedule});

  @override
  State<ScheduleForm> createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<ScheduleForm> {
  static const _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  final _formKey = GlobalKey<FormState>();
  late final _start = TextEditingController(text: _hm(widget.schedule?.startTime));
  late final _end = TextEditingController(text: _hm(widget.schedule?.endTime));
  late final _room = TextEditingController(text: widget.schedule?.room);
  late final _capacity = TextEditingController(
    text: widget.schedule?.slotCapacity.toString(),
  );
  late int? _subjectId = widget.schedule?.subjectId;
  late String _day = widget.schedule?.dayOfWeek ?? _days.first;
  bool _saving = false;

  bool get _isEdit => widget.schedule != null;

  static String _hm(String? t) => (t == null || t.length < 5) ? '' : t.substring(0, 5);

  @override
  void dispose() {
    _start.dispose();
    _end.dispose();
    _room.dispose();
    _capacity.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      );

  Future<void> _pickTime(TextEditingController c) async {
    final parts = c.text.split(':');
    final initial = parts.length == 2
        ? TimeOfDay(
            hour: int.tryParse(parts[0]) ?? 8,
            minute: int.tryParse(parts[1]) ?? 0,
          )
        : const TimeOfDay(hour: 8, minute: 0);
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      c.text =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    }
  }

  Widget _timeField(TextEditingController c, String label) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextFormField(
          controller: c,
          readOnly: true,
          onTap: () => _pickTime(c),
          style: const TextStyle(color: Colors.white),
          decoration: _decoration(label).copyWith(
            suffixIcon: const Icon(Icons.access_time, color: Colors.white),
          ),
          validator: (v) => (v == null || v.isEmpty) ? 'Please pick a time' : null,
        ),
      );

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_start.text.compareTo(_end.text) >= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End time must be after start time.')),
      );
      return;
    }

    setState(() => _saving = true);
    final vm = context.read<ScheduleViewModel>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final schedule = Schedule(
      scheduleId: widget.schedule?.scheduleId,
      subjectId: _subjectId!,
      dayOfWeek: _day,
      startTime: _start.text,
      endTime: _end.text,
      room: _room.text.trim(),
      slotCapacity: int.parse(_capacity.text.trim()),
    );

    final ok = _isEdit
        ? await vm.updateSchedule(schedule)
        : await vm.addSchedule(schedule);

    if (!mounted) return;
    setState(() => _saving = false);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? (_isEdit ? 'Schedule updated.' : 'Schedule added.')
              : vm.errorMessage ?? 'Something went wrong.',
        ),
      ),
    );
    if (ok) navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final subjects = context.watch<ScheduleViewModel>().subjects;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          _isEdit ? 'Edit Schedule' : 'Add Schedule',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: DropdownButtonFormField<int>(
                        value: _subjectId,
                        isExpanded: true,
                        dropdownColor: Colors.grey[900],
                        style: const TextStyle(color: Colors.white),
                        decoration: _decoration(
                          _isEdit ? 'Subject (cannot be changed)' : 'Select Subject',
                        ),
                        items: subjects
                            .map((s) => DropdownMenuItem(
                                  value: s.subjectId!,
                                  child: Text(
                                    '${s.subjectCode} - ${s.subjectName}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        onChanged: _isEdit
                            ? null
                            : (v) => setState(() => _subjectId = v),
                        validator: (v) => v == null ? 'Please select a subject' : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: DropdownButtonFormField<String>(
                        value: _day,
                        isExpanded: true,
                        dropdownColor: Colors.grey[900],
                        style: const TextStyle(color: Colors.white),
                        decoration: _decoration('Day of Week'),
                        items: _days
                            .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                            .toList(),
                        onChanged: (v) => setState(() => _day = v ?? _days.first),
                      ),
                    ),
                    _timeField(_start, 'Start Time'),
                    _timeField(_end, 'End Time'),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TextFormField(
                        controller: _room,
                        maxLength: 20,
                        style: const TextStyle(color: Colors.white),
                        decoration: _decoration('Room').copyWith(counterText: ''),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Please enter a room'
                            : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TextFormField(
                        controller: _capacity,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: _decoration('Slot Capacity'),
                        validator: (v) {
                          final n = int.tryParse(v ?? '');
                          return (n == null || n < 1)
                              ? 'Capacity must be 1 or more'
                              : null;
                        },
                      ),
                    ),
                    if (subjects.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Text(
                          'No subjects found. Add a subject first.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ElevatedButton(
                      onPressed: _saving ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: _saving
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_isEdit ? 'Save Changes' : 'Add Schedule'),
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