import 'package:flutter/foundation.dart';
import '../models/grade_model.dart';
import '../repository/grade_repo.dart';

class GradeViewModel extends ChangeNotifier {
  final GradeRepository _repo;
  GradeViewModel(this._repo);

  int? selectedStudentId;
  List<Grade> grades = [];
  List<GradableEnrollment> gradable = []; // for the Grade Form dropdown
  bool isLoading = false;
  String? errorMessage;

  String _clean(Object e) => e.toString().replaceFirst('Exception: ', '');

  double? getAverage() {
    if (grades.isEmpty) return null;
    final total = grades.fold<double>(0, (sum, g) => sum + g.gradeValue);
    return total / grades.length;
  }

  // View grades per student
  Future<void> selectStudent(int? id) async {
    selectedStudentId = id;
    grades = [];
    notifyListeners();
    await loadGrades();
  }

  Future<void> loadGrades() async {
    final id = selectedStudentId;
    if (id == null) {
      notifyListeners();
      return;
    }
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      grades = await _repo.getByStudent(id);
    } catch (e) {
      errorMessage = 'Could not load grades: ${_clean(e)}';
    }
    isLoading = false;
    notifyListeners();
  }

  /// Fills the enrollment dropdown of the Grade Form.
  Future<void> loadGradable(int? studentId) async {
    gradable = [];
    notifyListeners();
    if (studentId == null) return;
    try {
      gradable = await _repo.getGradableEnrollments(studentId);
    } catch (e) {
      errorMessage = 'Could not load enrollments: ${_clean(e)}';
    }
    notifyListeners();
  }

  /// Each action returns true on success so the View can show a message / pop.
  Future<bool> addGrade(Grade g, int studentId) {
    selectedStudentId = studentId; // show the student's grades afterwards
    return _run(() => _repo.create(g));
  }

  Future<bool> updateGrade(Grade g) => _run(() => _repo.update(g));
  Future<bool> deleteGrade(int id) => _run(() => _repo.delete(id));

  Future<bool> _run(Future<void> Function() action) async {
    errorMessage = null;
    try {
      await action();
      await loadGrades();
      return true;
    } catch (e) {
      errorMessage = _clean(e);
      notifyListeners();
      return false;
    }
  }
}