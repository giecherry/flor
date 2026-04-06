import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/person.dart';
import '../providers/people_provider.dart';
import '../theme.dart';
import '../utils/frequency_helper.dart';

class FriendScreen extends ConsumerStatefulWidget {
  final Person person;

  const FriendScreen({super.key, required this.person});

  @override
  ConsumerState<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends ConsumerState<FriendScreen> {
  Set<ContactMethod> _doneToday = {};
  DateTime _doneTodayDate = DateTime.now();

  Set<ContactMethod> get doneToday {
    final now = DateTime.now();
    if (now.day != _doneTodayDate.day ||
        now.month != _doneTodayDate.month ||
        now.year != _doneTodayDate.year) {
      _doneToday = {};
      _doneTodayDate = now;
    }
    return _doneToday;
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: FlorTheme.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Remove from garden?', style: FlorTheme.subheading),
        content: Text(
          'This will remove ${widget.person.name} and all their history. This can\'t be undone.',
          style: FlorTheme.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: FlorTheme.textDark),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(peopleProvider.notifier).deletePerson(widget.person.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _handleAction(BuildContext context, ContactMethod method) {
    showModalBottomSheet(
      context: context,
      backgroundColor: FlorTheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: FlorTheme.neutral,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text('${method.emoji} ${method.label}', style: FlorTheme.heading),
            const SizedBox(height: 8),
            Text(
              'Did you reach out to ${widget.person.name}?',
              style: FlorTheme.body,
            ),

            const SizedBox(height: 32),

            // confirm button
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                _logAction(method);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: FlorTheme.textDark,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'Yes, log it 🌸',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // cancel
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: FlorTheme.neutral,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text('Not yet', style: FlorTheme.subheading),
                ),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
          ],
        ),
      ),
    );
  }

  void _logAction(ContactMethod method) {
    ref.read(peopleProvider.notifier).logContact(widget.person.id, method);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logged! ${widget.person.name}\'s flower is happier 🌸'),
        backgroundColor: FlorTheme.textDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatBirthday(DateTime birthday) {
    return '${monthName(birthday.month)} ${birthday.day}';
  }

  @override
  Widget build(BuildContext context) {
    final peopleAsync = ref.watch(peopleProvider);
    final person =
        peopleAsync.value?.firstWhere(
          (p) => p.id == widget.person.id,
          orElse: () => widget.person,
        ) ??
        widget.person;

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
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: FlorTheme.textDark),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    person.flowerImagePath,
                    height: 160,
                    fit: BoxFit.contain,
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

            // Care actions
            const Text('Tend to them', style: FlorTheme.subheading),
            const SizedBox(height: 4),
            Text(
              'Tap an action when you\'ve done it',
              style: FlorTheme.caption,
            ),
            const SizedBox(height: 12),
            ...person.contactMethods.map((method) {
              final done = person.wasContactedTodayVia(method);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: done ? null : () => _handleAction(context, method),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: done ? FlorTheme.green : FlorTheme.yellow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Text(
                          done ? '✅' : method.emoji,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            method.label,
                            style: FlorTheme.subheading,
                          ),
                        ),
                        if (done) Text('done!', style: FlorTheme.caption),
                      ],
                    ),
                  ),
                ),
              );
            }),

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
}
