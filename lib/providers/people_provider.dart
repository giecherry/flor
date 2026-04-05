import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/person.dart';
import '../services/notification_service.dart';

class PeopleNotifier extends AsyncNotifier<List<Person>> {
  static const _storageKey = 'flor_people';

  @override
  Future<List<Person>> build() async {
    return _loadFromStorage();
  }

  Future<List<Person>> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null) return [];
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
    await NotificationService().scheduleReminder(person);
  }

  Future<void> deletePerson(String id) async {
    final current = state.value ?? [];
    await NotificationService().cancelReminder(id);
    final updated = current.where((p) => p.id != id).toList();
    state = AsyncData(updated);
    await _saveToStorage(updated);
  }

  Future<void> logContact(String id, ContactMethod method) async {
    final current = state.value ?? [];
    final updated = current.map((p) {
      if (p.id == id) {
        final updatedDates = Map<String, DateTime>.from(p.lastContactDates);
        updatedDates[method.name] = DateTime.now();
        return Person(
          id: p.id,
          name: p.name,
          relationship: p.relationship,
          contactMethods: p.contactMethods,
          flowerType: p.flowerType,
          contactFrequencyDays: p.contactFrequencyDays,
          lastContactDates: updatedDates,
          birthday: p.birthday,
          interests: p.interests,
        );
      }
      return p;
    }).toList();
    state = AsyncData(updated);
    await _saveToStorage(updated);
  }
}

final peopleProvider = AsyncNotifierProvider<PeopleNotifier, List<Person>>(
  PeopleNotifier.new,
);
