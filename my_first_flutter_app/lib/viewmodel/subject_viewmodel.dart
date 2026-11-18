import 'package:flutter/foundation.dart';
import '../models/subject_model.dart';
import '../repository/subject_repo.dart';

class SubjectViewModel extends ChangeNotifier {
  final SubjectRepository _repo;
  SubjectViewModel(this._repo);

  List<Subject> subjects = [];
  bool isLoading = false;
  String? errorMessage;

  String _clean(Object e) => e.toString().replaceFirst('Exception: ', '');

  Future<void> loadSubjects() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      subjects = await _repo.getAll();
    } catch (e) {
      errorMessage = 'Could not load subjects: ${_clean(e)}';
    }
    isLoading = false;
    notifyListeners();
  }

  Future<bool> addSubject(Subject s) => _run(() => _repo.create(s));
  Future<bool> updateSubject(Subject s) => _run(() => _repo.update(s));
  Future<bool> deleteSubject(int id) => _run(() => _repo.delete(id));

  Future<bool> _run(Future<void> Function() action) async {
    errorMessage = null;
    try {
      await action();
      await loadSubjects();
      return true;
    } catch (e) {
      errorMessage = _clean(e);
      notifyListeners();
      return false;
    }
  }
}