import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/person.dart' as model;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(initSettings);

    // request permission on Android 13+
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.requestNotificationsPermission();
  }

  Future<void> scheduleReminder(model.Person person) async {
    await _plugin.periodicallyShowWithDuration(
      person.id.hashCode.abs(),
      'Time to tend to ${person.name} 🌸',
      _reminderBody(person),
      Duration(days: person.contactFrequencyDays),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'flor_reminders',
          'Flor Reminders',
          channelDescription: 'Reminders to reach out to your people',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> cancelReminder(String personId) async {
    await _plugin.cancel(personId.hashCode.abs());
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  String _reminderBody(model.Person person) {
    if (person.contactMethods.isEmpty) return 'Reach out today!';
    final method = person.contactMethods.first;
    return '${method.emoji} ${method.label} — their flower misses you';
  }
}
