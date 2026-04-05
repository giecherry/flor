import 'package:flutter/material.dart';
import '../models/person.dart';
import '../widgets/flower_card.dart';
import '../theme.dart';
import 'friend_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Mock data
  List<Person> get people => [
    Person(
      id: '1',
      name: 'Mum',
      relationship: 'family',
      preferredContact: 'call',
      contactFrequencyDays: 7,
      lastContactDate: DateTime.now().subtract(const Duration(days: 3)),
      interests: ['travel', 'family'],
    ),
    Person(
      id: '2',
      name: 'Smilla',
      relationship: 'friend',
      preferredContact: 'instagram',
      contactFrequencyDays: 14,
      lastContactDate: DateTime.now().subtract(const Duration(days: 10)),
      interests: ['food', 'drinks'],
    ),
    Person(
      id: '3',
      name: 'Dad',
      relationship: 'family',
      preferredContact: 'call',
      contactFrequencyDays: 7,
      lastContactDate: DateTime.now().subtract(const Duration(days: 20)),
      interests: ['cars'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlorTheme.background,
      appBar: AppBar(
        backgroundColor: FlorTheme.background,
        elevation: 0,
        title: const Text('Flor', style: FlorTheme.heading),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: people.length,
          itemBuilder: (context, index) {
            return FlowerCard(
              person: people[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FriendScreen(person: people[index]),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
