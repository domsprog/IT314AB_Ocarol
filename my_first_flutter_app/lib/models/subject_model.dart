class Subject {
  final int? subjectId;
  final String subjectCode;
  final String subjectName;
  final int units;
  final String? description;

  const Subject({
    this.subjectId,
    required this.subjectCode,
    required this.subjectName,
    required this.units,
    this.description,
  });

  factory Subject.fromMap(Map<String, dynamic> m) => Subject(
    subjectId: m['subject_id'] as int,
    subjectCode: m['subject_code'] as String,
    subjectName: m['subject_name'] as String,
    units: m['units'] as int,
    description: m['description'] as String?,
  );

  Map<String, dynamic> toMap() => {
    'subject_code': subjectCode,
    'subject_name': subjectName,
    'units': units,
    'description': description,
  };
}
