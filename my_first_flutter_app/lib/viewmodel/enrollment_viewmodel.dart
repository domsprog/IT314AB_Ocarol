
import 'package:flutter/foundation.dart';

import '../models/enrollment_model.dart';
import '../models/schedule_model.dart';
import '../models/subject_model.dart';

import '../repository/enrollment_repo.dart';
import '../repository/schedule_repo.dart';
import '../repository/subject_repo.dart';

class EnrollmentViewModel extends ChangeNotifier {

  // Repositories
  final EnrollmentRepository _repo;
  final SubjectRepository _subjectRepo;
  final ScheduleRepository _scheduleRepo;

  EnrollmentViewModel(
    this._repo,
    this._subjectRepo,
    this._scheduleRepo,
  );

  List<Subject> subjects = [];
  List<Schedule> schedules = [];
  List<Enrollment> enrollments = [];


  int? selectedStudentId;
  int? selectedSubjectId;
  int? selectedScheduleId;


  bool isLoading = false;
  bool isSaving = false;
  String? errorMessage;

  String cleanError(Object error) {

    if (error is EnrollmentException) {
      return error.message;
    }

    return error.toString().replaceFirst('Exception: ', '');
  }

  Future<void> loadSubjects() async {

    try {

      subjects = await _subjectRepo.getAll();

    } catch (error) {

      errorMessage = 'Could not load subjects: ${cleanError(error)}';

    }

    notifyListeners();
  }

  Future<void> selectStudent(int? id) async {

    selectedStudentId = id;

    enrollments = [];

    notifyListeners();

    await loadEnrollments();
  }


  Future<void> selectSubject(int? id) async {

    selectedSubjectId = id;

    selectedScheduleId = null;

    schedules = [];

    notifyListeners();

    if (id != null) {
      await loadSchedules(id);
    }
  }

  void selectSchedule(int? id) {

    selectedScheduleId = id;

    notifyListeners();
  }

  Future<void> loadSchedules(int subjectId) async {

    try {

      schedules = await _scheduleRepo.getBySubject(subjectId);

    } catch (error) {

      errorMessage = 'Could not load schedules: ${cleanError(error)}';

    }

    notifyListeners();
  }


  Future<void> loadEnrollments() async {

    int? studentId = selectedStudentId;

    if (studentId == null) {
      enrollments = [];
      notifyListeners();
      return;
    }

    isLoading = true;

    notifyListeners();

    try {

  
      enrollments = await _repo.getByStudent(studentId);

    } catch (error) {

      errorMessage = 'Could not load enrollments: ${cleanError(error)}';

    }

    isLoading = false;

    notifyListeners();
  }

  Future<bool> enroll() async {


    if (selectedStudentId == null) {
      return fail('Please select a student.');
    }

    if (selectedSubjectId == null) {
      return fail('Please select a subject.');
    }

    if (selectedScheduleId == null) {
      return fail('Please select a schedule.');
    }

    isSaving = true;
    errorMessage = null;

    notifyListeners();

    try {

      await _repo.enroll(
        studentId: selectedStudentId!,
        subjectId: selectedSubjectId!,
        scheduleId: selectedScheduleId!,
      );

      selectedScheduleId = null;

      isSaving = false;


      await loadSchedules(selectedSubjectId!);

      await loadEnrollments();

      return true;

    } catch (error) {

      errorMessage = cleanError(error);

      isSaving = false;

      await loadSchedules(selectedSubjectId!);

      notifyListeners();

      return false;
    }
  }


  Future<bool> drop(int enrollmentId) async {

    errorMessage = null;

    try {

      await _repo.drop(enrollmentId);

      await loadEnrollments();

      if (selectedSubjectId != null) {
        await loadSchedules(selectedSubjectId!);
      }

      return true;

    } catch (error) {

      errorMessage = cleanError(error);

      notifyListeners();

      return false;
    }
  }

  bool fail(String message) {

    errorMessage = message;

    notifyListeners();

    return false;
  }

}
