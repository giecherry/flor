import 'package:flutter/material.dart';
import '../models/person.dart';
import '../theme.dart';

class FlowerCard extends StatelessWidget {
  final Person person;
  final VoidCallback onTap;

  const FlowerCard({super.key, required this.person, required this.onTap});

  Color get cardColor {
    switch (person.relationship) {
      case RelationshipType.family:
        return FlorTheme.blue;
      case RelationshipType.friend:
        return FlorTheme.pink;
      case RelationshipType.partner:
        return FlorTheme.yellow;
      case RelationshipType.colleague:
        return FlorTheme.neutral;
    }
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
            Expanded(
              child: Image.asset(person.flowerImagePath, fit: BoxFit.contain),
            ),
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
