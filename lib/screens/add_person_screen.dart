import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/person.dart';
import '../providers/people_provider.dart';
import '../theme.dart';
import '../utils/frequency_helper.dart';
import '../widgets/dropdown_field.dart';

class AddPersonScreen extends ConsumerStatefulWidget {
  const AddPersonScreen({super.key});

  @override
  ConsumerState<AddPersonScreen> createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends ConsumerState<AddPersonScreen> {
  final _nameController = TextEditingController();
  RelationshipType _relationship = RelationshipType.friend;
  FlowerType _flowerType = FlowerType.rose;
  List<ContactMethod> _contactMethods = [];
  List<String> _interests = [];
  int _frequencyDays = 7;
  int? _birthdayDay;
  int? _birthdayMonth;
  int? _birthdayYear;
  final _interestController = TextEditingController();

  bool _submitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _interestController.dispose();
    super.dispose();
  }

  void _addInterest(String tag) {
    final trimmed = tag.trim();
    if (trimmed.isNotEmpty && !_interests.contains(trimmed)) {
      setState(() => _interests.add(trimmed));
    }
    _interestController.clear();
  }

  void _submit() {
    setState(() => _submitted = true);

    if (_nameController.text.trim().isEmpty || _contactMethods.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in the required fields'),
          backgroundColor: const Color.fromARGB(255, 255, 141, 139),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final birthday =
        (_birthdayDay != null &&
            _birthdayMonth != null &&
            _birthdayYear != null)
        ? DateTime(_birthdayYear!, _birthdayMonth!, _birthdayDay!)
        : null;

    final person = Person(
      id: const Uuid().v4(),
      name: _nameController.text.trim(),
      relationship: _relationship,
      contactMethods: _contactMethods,
      flowerType: _flowerType,
      contactFrequencyDays: _frequencyDays,
      birthday: birthday,
      interests: _interests,
    );

    ref.read(peopleProvider.notifier).addPerson(person);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlorTheme.background,
      appBar: AppBar(
        backgroundColor: FlorTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: FlorTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Add someone', style: FlorTheme.heading),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name
            const Text('Name', style: FlorTheme.subheading),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Their name',
                filled: true,
                fillColor: FlorTheme.neutral,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: _submitted && _nameController.text.trim().isEmpty
                        ? Colors.red.shade400
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                errorText: _submitted && _nameController.text.trim().isEmpty
                    ? 'Name is required'
                    : null,
              ),
            ),

            const SizedBox(height: 24),

            // Relationship type
            const Text('Relationship', style: FlorTheme.subheading),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: RelationshipType.values.map((type) {
                final selected = _relationship == type;
                return ChoiceChip(
                  label: Text(type.label),
                  selected: selected,
                  selectedColor: FlorTheme.yellow,
                  backgroundColor: FlorTheme.neutral,
                  onSelected: (_) => setState(() => _relationship = type),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Flower type
            const Text('Their flower', style: FlorTheme.subheading),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: FlowerType.values.map((type) {
                final selected = _flowerType == type;
                return ChoiceChip(
                  label: Text(
                    type.name[0].toUpperCase() + type.name.substring(1),
                  ),
                  avatar: Image.asset(
                    'assets/images/flowers/${type.name}-vg.png',
                    height: 20,
                    width: 20,
                    fit: BoxFit.contain,
                  ),
                  selected: selected,
                  selectedColor: FlorTheme.pink,
                  backgroundColor: FlorTheme.neutral,
                  onSelected: (_) => setState(() => _flowerType = type),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Contact methods
            const Text('Ways to reach them', style: FlorTheme.subheading),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ContactMethod.values.map((method) {
                final selected = _contactMethods.contains(method);
                return FilterChip(
                  label: Text('${method.emoji} ${method.shortLabel}'),
                  selected: selected,
                  selectedColor: FlorTheme.green,
                  backgroundColor: FlorTheme.neutral,
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        _contactMethods.add(method);
                      } else {
                        _contactMethods.remove(method);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            if (_submitted && _contactMethods.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Select at least one way to reach them',
                  style: TextStyle(color: Colors.red.shade400, fontSize: 12),
                ),
              ),

            const SizedBox(height: 24),

            // Frequency
            const Text('How often to reach out?', style: FlorTheme.subheading),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: FlorTheme.neutral,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    frequencyLabel(_frequencyDays),
                    style: FlorTheme.subheading,
                  ),
                  const SizedBox(height: 4),
                  Text('Every $_frequencyDays days', style: FlorTheme.caption),
                  Slider(
                    value: _frequencyDays.toDouble(),
                    min: 1,
                    max: 180,
                    divisions: 179,
                    activeColor: FlorTheme.textDark,
                    inactiveColor: FlorTheme.neutral,
                    onChanged: (val) =>
                        setState(() => _frequencyDays = val.round()),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Birthday
            const Text('Birthday (optional)', style: FlorTheme.subheading),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownField<int>(
                    hint: 'Day',
                    value: _birthdayDay,
                    items: List.generate(31, (i) => i + 1),
                    labelBuilder: (v) => '$v',
                    onChanged: (v) => setState(() => _birthdayDay = v),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: DropdownField<int>(
                    hint: 'Month',
                    value: _birthdayMonth,
                    items: List.generate(12, (i) => i + 1),
                    labelBuilder: (v) => monthName(v),
                    onChanged: (v) => setState(() => _birthdayMonth = v),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: DropdownField<int>(
                    hint: 'Year',
                    value: _birthdayYear,
                    items: List.generate(100, (i) => DateTime.now().year - i),
                    labelBuilder: (v) => '$v',
                    onChanged: (v) => setState(() => _birthdayYear = v),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Interests
            const Text('Interests (optional)', style: FlorTheme.subheading),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _interestController,
                    decoration: InputDecoration(
                      hintText: 'e.g. kpop, hiking...',
                      filled: true,
                      fillColor: FlorTheme.neutral,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: _addInterest,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _addInterest(_interestController.text),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: FlorTheme.yellow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.add, color: FlorTheme.textDark),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _interests
                  .map(
                    (i) => Chip(
                      label: Text(i, style: FlorTheme.caption),
                      backgroundColor: FlorTheme.neutral,
                      deleteIcon: const Icon(Icons.close, size: 14),
                      onDeleted: () => setState(() => _interests.remove(i)),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 40),

            // Submit
            GestureDetector(
              onTap: _submit,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: FlorTheme.textDark,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'Add to garden 🌸',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
