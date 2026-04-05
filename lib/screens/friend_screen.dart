import 'package:flutter/material.dart';
import '../models/person.dart';
import '../theme.dart';

class FriendScreen extends StatelessWidget {
  final Person person;

  const FriendScreen({super.key, required this.person});

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
                  Text(
                    person.flowerEmoji,
                    style: const TextStyle(fontSize: 80),
                  ),
                  const SizedBox(height: 8),
                  Text(person.healthLabel, style: FlorTheme.subheading),
                  const SizedBox(height: 4),
                  Text(
                    person.daysSinceContact == 999
                        ? 'You\'ve never reached out'
                        : 'Last contact ${person.daysSinceContact} days ago',
                    style: FlorTheme.caption,
                  ),
                  if (person.birthday != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '🎂 ${_formatBirthday(person.birthday!)}',
                      style: FlorTheme.caption,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Care actions — one button per contact method
            const Text('Tend to them', style: FlorTheme.subheading),
            const SizedBox(height: 12),
            ...person.contactMethods.map(
              (method) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _ActionButton(
                  label: method.label,
                  emoji: method.emoji,
                  color: FlorTheme.yellow,
                  onTap: () {},
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Interests
            if (person.interests.isNotEmpty) ...[
              const Text('Interests', style: FlorTheme.subheading),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
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
          ],
        ),
      ),
    );
  }

  String _formatBirthday(DateTime birthday) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[birthday.month - 1]} ${birthday.day}';
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
