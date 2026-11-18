import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/grade_model.dart';
import '../../viewmodel/grade_viewmodel.dart';
import '../../viewmodel/student_viewmodel.dart';

/// Grade Form: Add (grade == null) and Edit Grade (grade != null).
class GradeForm extends StatefulWidget {
  final Grade? grade;
  final int? studentId; // optional preselected student when adding
  const GradeForm({super.key, this.grade, this.studentId});

  @override
  State<GradeForm> createState() => _GradeFormState();
}

class _GradeFormState extends State<GradeForm> {
  final _formKey = GlobalKey<FormState>();
  late final _value = TextEditingController(
    text: widget.grade?.gradeValue.toStringAsFixed(2),
  );
  late final _remarks = TextEditingController(text: widget.grade?.remarks);
  late int? _studentId = widget.studentId;
  int? _enrollmentId;
  bool _saving = false;

  bool get _isEdit => widget.grade != null;

  @override
  void initState() {
    super.initState();
    if (!_isEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<GradeViewModel>().loadGradable(_studentId);
      });
    }
  }

  @override
  void dispose() {
    _value.dispose();
    _remarks.dispose();
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
        counterText: '',
      );

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final vm = context.read<GradeViewModel>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final value = double.parse(_value.text.trim());
    final remarks = _remarks.text.trim().isEmpty
        ? Grade.autoRemarks(value)
        : _remarks.text.trim();

    final bool ok;
    if (_isEdit) {
      ok = await vm.updateGrade(
        Grade(
          gradeId: widget.grade!.gradeId,
          enrollmentId: widget.grade!.enrollmentId,
          gradeValue: value,
          remarks: remarks,
        ),
      );
    } else {
      ok = await vm.addGrade(
        Grade(
          enrollmentId: _enrollmentId!,
          gradeValue: value,
          remarks: remarks,
        ),
        _studentId!,
      );
    }

    if (!mounted) return;
    setState(() => _saving = false);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? (_isEdit ? 'Grade updated.' : 'Grade added.')
              : vm.errorMessage ?? 'Something went wrong.',
        ),
      ),
    );
    if (ok) navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final students = context.watch<StudentViewModel>().students;
    final vm = context.watch<GradeViewModel>();
    final enrollmentValue =
        vm.gradable.any((e) => e.enrollmentId == _enrollmentId)
            ? _enrollmentId
            : null;
    final studentValue =
        students.any((s) => s.studentId == _studentId) ? _studentId : null;

    // Edit mode shows the student and subject as read-only text.
    String studentName = '';
    if (_isEdit) {
      final match = students.where((s) => s.studentId == widget.grade!.studentId);
      studentName = match.isEmpty ? '' : match.first.fullName;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          _isEdit ? 'Edit Grade' : 'Add Grade',
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
                    if (_isEdit) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TextFormField(
                          initialValue: studentName,
                          enabled: false,
                          style: const TextStyle(color: Colors.white70),
                          decoration: _decoration('Student'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TextFormField(
                          initialValue:
                              '${widget.grade!.subjectCode} - ${widget.grade!.subjectName}',
                          enabled: false,
                          style: const TextStyle(color: Colors.white70),
                          decoration: _decoration('Subject'),
                        ),
                      ),
                    ] else ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: DropdownButtonFormField<int>(
                          value: studentValue,
                          isExpanded: true,
                          dropdownColor: Colors.grey[900],
                          style: const TextStyle(color: Colors.white),
                          decoration: _decoration('Select Student'),
                          items: students
                              .map((s) => DropdownMenuItem(
                                    value: s.studentId!,
                                    child: Text(
                                      '${s.fullName} (${s.studentNumber})',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          onChanged: (v) {
                            setState(() {
                              _studentId = v;
                              _enrollmentId = null;
                            });
                            context.read<GradeViewModel>().loadGradable(v);
                          },
                          validator: (v) =>
                              v == null ? 'Please select a student' : null,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: DropdownButtonFormField<int>(
                          value: enrollmentValue,
                          isExpanded: true,
                          dropdownColor: Colors.grey[900],
                          style: const TextStyle(color: Colors.white),
                          decoration: _decoration('Select Enrolled Subject'),
                          items: vm.gradable
                              .map((e) => DropdownMenuItem(
                                    value: e.enrollmentId,
                                    child: Text(
                                      e.getLabel(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          onChanged: (v) => setState(() => _enrollmentId = v),
                          validator: (v) =>
                              v == null ? 'Please select a subject' : null,
                        ),
                      ),
                      if (_studentId != null && vm.gradable.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Text(
                            'This student has no enrolled subjects waiting for a grade.',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                    ],
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TextFormField(
                        controller: _value,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        style: const TextStyle(color: Colors.white),
                        decoration: _decoration('Grade (0 - 100)'),
                        validator: (v) {
                          final n = double.tryParse((v ?? '').trim());
                          if (n == null || n < 0 || n > 100) {
                            return 'Grade must be between 0 and 100';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TextFormField(
                        controller: _remarks,
                        maxLength: 50,
                        style: const TextStyle(color: Colors.white),
                        decoration: _decoration(
                          'Remarks (blank = Passed / Failed)',
                        ),
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
                          : Text(_isEdit ? 'Save Changes' : 'Add Grade'),
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