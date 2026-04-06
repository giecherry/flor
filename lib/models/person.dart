enum RelationshipType { friend, family, partner, colleague }

enum ContactMethod {
  call,
  videoCall,
  text,
  whatsapp,
  instagram,
  snapchat,
  email,
  meetInPerson,
}

enum FlowerType { rose, tulip, sunflower, bluebell }

extension ContactMethodInfo on ContactMethod {
  String get shortLabel {
    switch (this) {
      case ContactMethod.call:
        return 'Call';
      case ContactMethod.videoCall:
        return 'Video call';
      case ContactMethod.text:
        return 'Text';
      case ContactMethod.whatsapp:
        return 'WhatsApp';
      case ContactMethod.instagram:
        return 'Instagram';
      case ContactMethod.snapchat:
        return 'Snapchat';
      case ContactMethod.email:
        return 'Email';
      case ContactMethod.meetInPerson:
        return 'Meet up';
    }
  }

  String get emoji {
    switch (this) {
      case ContactMethod.call:
        return '📞';
      case ContactMethod.videoCall:
        return '🎥';
      case ContactMethod.text:
        return '💬';
      case ContactMethod.whatsapp:
        return '💚';
      case ContactMethod.instagram:
        return '📸';
      case ContactMethod.snapchat:
        return '👻';
      case ContactMethod.email:
        return '📧';
      case ContactMethod.meetInPerson:
        return '🤝';
    }
  }

  String get label {
    switch (this) {
      case ContactMethod.call:
        return 'Give them a call';
      case ContactMethod.videoCall:
        return 'Video call';
      case ContactMethod.text:
        return 'Send a text';
      case ContactMethod.whatsapp:
        return 'Message on WhatsApp';
      case ContactMethod.instagram:
        return 'Open Instagram';
      case ContactMethod.snapchat:
        return 'Open Snapchat';
      case ContactMethod.email:
        return 'Send an email';
      case ContactMethod.meetInPerson:
        return 'Meet in person';
    }
  }
}

extension RelationshipTypeInfo on RelationshipType {
  String get label {
    switch (this) {
      case RelationshipType.friend:
        return 'Friend';
      case RelationshipType.family:
        return 'Family';
      case RelationshipType.partner:
        return 'Partner';
      case RelationshipType.colleague:
        return 'Colleague';
    }
  }
}

class Person {
  final String id;
  final String name;
  final RelationshipType relationship;
  final List<ContactMethod> contactMethods;
  final FlowerType flowerType;
  final int contactFrequencyDays;
  final Map<String, DateTime> lastContactDates;
  final DateTime? birthday;
  final List<String> interests;

  Person({
    required this.id,
    required this.name,
    required this.relationship,
    required this.contactMethods,
    required this.flowerType,
    required this.contactFrequencyDays,
    this.lastContactDates = const {},
    this.birthday,
    this.interests = const [],
  });

  DateTime? get lastContactDate {
    if (lastContactDates.isEmpty) return null;
    return lastContactDates.values.reduce((a, b) => a.isAfter(b) ? a : b);
  }

  int get daysSinceContact {
    if (lastContactDate == null) return 999;
    return DateTime.now().difference(lastContactDate!).inDays;
  }

  double get health {
    if (lastContactDate == null) return 0.0;
    final ratio = daysSinceContact / contactFrequencyDays;
    return (1.0 - ratio).clamp(0.0, 1.0);
  }

  bool wasContactedTodayVia(ContactMethod method) {
    final date = lastContactDates[method.name];
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String get flowerImagePath {
    final name = flowerType.name;
    if (health >= 0.6) return 'assets/images/flowers/$name-vg.png';
    if (health >= 0.3) return 'assets/images/flowers/$name-g.png';
    return 'assets/images/flowers/$name-b.png';
  }

  String get healthLabel {
    if (health >= 0.6) return 'Thriving';
    if (health >= 0.3) return 'Doing okay';
    return 'Needs attention';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'relationship': relationship.name,
      'contactMethods': contactMethods.map((c) => c.name).toList(),
      'flowerType': flowerType.name,
      'contactFrequencyDays': contactFrequencyDays,
      'lastContactDates': lastContactDates.map(
        (k, v) => MapEntry(k, v.toIso8601String()),
      ),
      'birthday': birthday?.toIso8601String(),
      'interests': interests,
    };
  }

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      name: json['name'],
      relationship: RelationshipType.values.byName(json['relationship']),
      contactMethods: (json['contactMethods'] as List)
          .map((e) => ContactMethod.values.byName(e))
          .toList(),
      flowerType: FlowerType.values.byName(json['flowerType']),
      contactFrequencyDays: json['contactFrequencyDays'],
      lastContactDates:
          (json['lastContactDates'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, DateTime.parse(v)),
          ) ??
          {},
      birthday: json['birthday'] != null
          ? DateTime.parse(json['birthday'])
          : null,
      interests: List<String>.from(json['interests'] ?? []),
    );
  }
}
