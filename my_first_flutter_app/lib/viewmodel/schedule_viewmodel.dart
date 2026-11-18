
import 'package:flutter/foundation.dart';
import '../models/schedule_model.dart';
import '../models/subject_model.dart';
import '../repository/schedule_repo.dart';
import '../repository/subject_repo.dart';

class ScheduleViewModel extends ChangeNotifier {
  final ScheduleRepository _repo;
  final SubjectRepository _subjectRepo;

  ScheduleViewModel(this._repo, this._subjectRepo);

  List<Schedule> schedules = [];
  List<Subject> subjects = [];

  bool isLoading = false;
  String? errorMessage;

  // Remove "Exception: " from error messages
  String _clean(Object e) {
    return e.toString().replaceFirst('Exception: ', '');
  }

  // LOAD SCHEDULES AND SUBJECTS
  Future<void> loadSchedules() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      schedules = await _repo.getAll();
      subjects = await _subjectRepo.getAll();
    } catch (e) {
      errorMessage = 'Could not load schedules: ${_clean(e)}';
    }

    isLoading = false;
    notifyListeners();
  }

  // ADD SCHEDULE
  Future<bool> addSchedule(Schedule schedule) async {
    errorMessage = null;

    try {
      await _repo.create(schedule);

      // Refresh the schedule list
      await loadSchedules();

      return true;
    } catch (e) {
      errorMessage = _clean(e);
      notifyListeners();

      return false;
    }
  }

  // UPDATE SCHEDULE
  Future<bool> updateSchedule(Schedule schedule) async {
    errorMessage = null;

    try {
      await _repo.update(schedule);

      // Refresh the schedule list
      await loadSchedules();

      return true;
    } catch (e) {
      errorMessage = _clean(e);
      notifyListeners();

      return false;
    }
  }

  // DELETE SCHEDULE
  Future<bool> deleteSchedule(int id) async {
    errorMessage = null;

    try {
      await _repo.delete(id);

      // Refresh the schedule list
      await loadSchedules();

      return true;
    } catch (e) {
      errorMessage = _clean(e);
      notifyListeners();

      return false;
    }
  }
}
