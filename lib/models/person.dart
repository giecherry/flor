class Person {
  final String id;
  final String name;
  final String relationship;
  final String preferredContact;
  final int contactFrequencyDays;
  final DateTime? lastContactDate;
  final DateTime? birthday;
  final List<String> interests;

  Person({
    required this.id,
    required this.name,
    required this.relationship,
    required this.preferredContact,
    required this.contactFrequencyDays,
    this.lastContactDate,
    this.birthday,
    this.interests = const [],
  });

  int get daysSinceContact {
    if (lastContactDate == null) return 999;
    return DateTime.now().difference(lastContactDate!).inDays;
  }

  double get health {
    if (lastContactDate == null) return 0.0;
    final ratio = daysSinceContact / contactFrequencyDays;
    return (1.0 - ratio).clamp(0.0, 1.0);
  }
}
