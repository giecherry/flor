import 'package:flutter/material.dart';
import '../models/person.dart';
import '../theme.dart';

class FriendScreen extends StatelessWidget {
  final Person person;

  const FriendScreen({super.key, required this.person});

  String get flowerEmoji {
    if (person.health >= 0.8) return '🌸';
    if (person.health >= 0.5) return '🌼';
    if (person.health >= 0.2) return '🥀';
    return '🪴';
  }

  String get healthLabel {
    if (person.health >= 0.8) return 'Blooming';
    if (person.health >= 0.5) return 'Doing okay';
    if (person.health >= 0.2) return 'Needs attention';
    return 'Wilting';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlorTheme.background,
      appBar: AppBar(
        backgroundColor: FlorTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: FlorTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(person.name, style: FlorTheme.heading),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(flowerEmoji, style: const TextStyle(fontSize: 80)),
                  const SizedBox(height: 8),
                  Text(healthLabel, style: FlorTheme.subheading),
                  const SizedBox(height: 4),
                  Text(
                    person.daysSinceContact == 999
                        ? 'You\'ve never reached out'
                        : 'Last contact ${person.daysSinceContact} days ago',
                    style: FlorTheme.caption,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Actions
            const Text('Tend to them', style: FlorTheme.subheading),
            const SizedBox(height: 12),
            _ActionButton(
              label: 'Send a text',
              emoji: '💬',
              color: FlorTheme.yellow,
              onTap: () {},
            ),
            const SizedBox(height: 8),
            _ActionButton(
              label: 'Send a meme',
              emoji: '😂',
              color: FlorTheme.pink,
              onTap: () {},
            ),
            const SizedBox(height: 8),
            _ActionButton(
              label: person.preferredContact == 'call'
                  ? 'Give them a call'
                  : 'Open Instagram',
              emoji: person.preferredContact == 'call' ? '📞' : '📱',
              color: FlorTheme.green,
              onTap: () {},
            ),

            const SizedBox(height: 40),

            // Interests
            const Text('Interests', style: FlorTheme.subheading),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: person.interests
                  .map(
                    (i) => Chip(
                      label: Text(i, style: FlorTheme.caption),
                      backgroundColor: FlorTheme.neutral,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final String emoji;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.emoji,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Text(label, style: FlorTheme.subheading),
          ],
        ),
      ),
    );
  }
}
