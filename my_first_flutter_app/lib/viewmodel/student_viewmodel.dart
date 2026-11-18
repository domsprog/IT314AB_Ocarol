import 'package:flutter/foundation.dart';
import '../models/student_model.dart';
import '../repository/student_repo.dart';


class StudentViewModel extends ChangeNotifier {
  final StudentRepository _repo;
  StudentViewModel(this._repo);

  List<Student> students = [];
  bool isLoading = false;
  String? errorMessage;

  final Set<int> favoriteIds = {};

  bool isFavorite(int id) => favoriteIds.contains(id);

  void toggleFavorite(int id) {
    favoriteIds.contains(id) ? favoriteIds.remove(id) : favoriteIds.add(id);
    notifyListeners();
  }

  void sortByName() {
    students.sort(
      (a, b) => a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()),
    );
    notifyListeners();
  }

  String _clean(Object e) => e.toString().replaceFirst('Exception: ', '');

  Future<void> loadStudents() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      students = await _repo.getAll();
    } catch (e) {
      errorMessage = 'Could not load students: ${_clean(e)}';
    }
    isLoading = false;
    notifyListeners();
  }

  /// Each action returns true on success so the View can show a message / pop.
  Future<bool> addStudent(Student s) => _run(() => _repo.create(s));
  Future<bool> updateStudent(Student s) => _run(() => _repo.update(s));
  Future<bool> deleteStudent(int id) => _run(() => _repo.delete(id));

  Future<bool> _run(Future<void> Function() action) async {
    errorMessage = null;
    try {
      await action();
      await loadStudents();
      return true;
    } catch (e) {
      errorMessage = _clean(e);
      notifyListeners();
      return false;
    }
  }
}
