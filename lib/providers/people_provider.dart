import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/person.dart';

class PeopleNotifier extends AsyncNotifier<List<Person>> {
  static const _storageKey = 'flor_people';

  @override
  Future<List<Person>> build() async {
    return _loadFromStorage();
  }

  Future<List<Person>> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null) return _defaultPeople();
    final List decoded = jsonDecode(jsonString);
    return decoded.map((e) => Person.fromJson(e)).toList();
  }

  Future<void> _saveToStorage(List<Person> people) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(people.map((p) => p.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  Future<void> addPerson(Person person) async {
    final current = state.value ?? [];
    final updated = [...current, person];
    state = AsyncData(updated);
    await _saveToStorage(updated);
  }

  Future<void> updateLastContact(String id) async {
    final current = state.value ?? [];
    final updated = current.map((p) {
      if (p.id == id) {
        return Person(
          id: p.id,
          name: p.name,
          relationship: p.relationship,
          contactMethods: p.contactMethods,
          flowerType: p.flowerType,
          contactFrequencyDays: p.contactFrequencyDays,
          lastContactDate: DateTime.now(),
          birthday: p.birthday,
          interests: p.interests,
        );
      }
      return p;
    }).toList();
    state = AsyncData(updated);
    await _saveToStorage(updated);
  }

  List<Person> _defaultPeople() {
    return [
      Person(
        id: '1',
        name: 'Mom',
        relationship: RelationshipType.family,
        contactMethods: [ContactMethod.call, ContactMethod.videoCall],
        flowerType: FlowerType.rose,
        contactFrequencyDays: 7,
        lastContactDate: DateTime.now().subtract(const Duration(days: 3)),
        birthday: DateTime(1974, 11, 03),
        interests: ['travel', 'family'],
      ),
      Person(
        id: '2',
        name: 'Smilla',
        relationship: RelationshipType.friend,
        contactMethods: [ContactMethod.instagram, ContactMethod.meetInPerson],
        flowerType: FlowerType.daisy,
        contactFrequencyDays: 14,
        lastContactDate: DateTime.now().subtract(const Duration(days: 10)),
        birthday: DateTime(1999, 04, 18),
        interests: ['food', 'drinks'],
      ),
    ];
  }
}

final peopleProvider = AsyncNotifierProvider<PeopleNotifier, List<Person>>(
  PeopleNotifier.new,
);
