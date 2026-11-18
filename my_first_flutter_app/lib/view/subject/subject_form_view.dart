import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/subject_model.dart';
import '../../viewmodel/subject_viewmodel.dart';

/// Subject Form: Add (subject == null) and Edit Subject (subject != null).
class SubjectForm extends StatefulWidget {
  final Subject? subject;
  const SubjectForm({super.key, this.subject});

  @override
  State<SubjectForm> createState() => _SubjectFormState();
}

class _SubjectFormState extends State<SubjectForm> {
  final _formKey = GlobalKey<FormState>();
  late final _code = TextEditingController(text: widget.subject?.subjectCode);
  late final _name = TextEditingController(text: widget.subject?.subjectName);
  late final _description = TextEditingController(
    text: widget.subject?.description,
  );
  late int _units = widget.subject?.units ?? 3;
  bool _saving = false;

  bool get _isEdit => widget.subject != null;

  @override
  void dispose() {
    _code.dispose();
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        counterText: '',
      );

  String? _required(String? v, String msg) =>
      (v == null || v.trim().isEmpty) ? msg : null;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final vm = context.read<SubjectViewModel>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final subject = Subject(
      subjectId: widget.subject?.subjectId,
      subjectCode: _code.text.trim(),
      subjectName: _name.text.trim(),
      units: _units,
      description:
          _description.text.trim().isEmpty ? null : _description.text.trim(),
    );

    final ok = _isEdit
        ? await vm.updateSubject(subject)
        : await vm.addSubject(subject);

    if (!mounted) return;
    setState(() => _saving = false);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? (_isEdit ? 'Subject updated.' : 'Subject added.')
              : vm.errorMessage ?? 'Something went wrong.',
        ),
      ),
    );
    if (ok) navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          _isEdit ? 'Edit Subject' : 'Add Subject',
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
                      child: TextFormField(
                        controller: _code,
                        maxLength: 20,
                        style: const TextStyle(color: Colors.white),
                        decoration: _decoration('Enter Subject Code'),
                        validator: (v) =>
                            _required(v, 'Please enter a subject code'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TextFormField(
                        controller: _name,
                        maxLength: 100,
                        style: const TextStyle(color: Colors.white),
                        decoration: _decoration('Enter Subject Name'),
                        validator: (v) =>
                            _required(v, 'Please enter a subject name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: DropdownButtonFormField<int>(
                        value: _units,
                        isExpanded: true,
                        dropdownColor: Colors.grey[900],
                        style: const TextStyle(color: Colors.white),
                        decoration: _decoration('Units'),
                        items: [1, 2, 3, 4, 5, 6]
                            .map((u) => DropdownMenuItem(
                                  value: u,
                                  child: Text('$u unit${u == 1 ? '' : 's'}'),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _units = v ?? 3),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TextFormField(
                        controller: _description,
                        maxLines: 3,
                        style: const TextStyle(color: Colors.white),
                        decoration: _decoration('Description (optional)'),
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
                          : Text(_isEdit ? 'Save Changes' : 'Add Subject'),
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