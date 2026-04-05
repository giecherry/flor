import 'package:flutter/material.dart';
import '../models/person.dart';
import '../theme.dart';

class FlowerCard extends StatelessWidget {
  final Person person;
  final VoidCallback onTap;

  const FlowerCard({super.key, required this.person, required this.onTap});

  // Color based on relationship type
  Color get cardColor {
    switch (person.relationship) {
      case 'family':
        return FlorTheme.blue;
      case 'friend':
        return FlorTheme.pink;
      default:
        return FlorTheme.yellow;
    }
  }

  // Emoji based on flower health - todo update to ilustrations
  String get flowerEmoji {
    if (person.health >= 0.8) return '🌸';
    if (person.health >= 0.5) return '🌼';
    if (person.health >= 0.2) return '🥀';
    return '🪴';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(flowerEmoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 8),
            Text(person.name, style: FlorTheme.subheading),
            const SizedBox(height: 4),
            Text(
              person.daysSinceContact == 999
                  ? 'never reached out'
                  : '${person.daysSinceContact}d ago',
              style: FlorTheme.caption,
            ),
          ],
        ),
      ),
    );
  }
}
