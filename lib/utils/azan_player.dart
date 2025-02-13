import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class AzanNotifications {
  static final AzanNotifications _instance = AzanNotifications._internal();

  factory AzanNotifications() {
    return _instance;
  }

  AzanNotifications._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize notifications
  Future<void> init() async {
    // Step 1: Initialize the timezone database
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher'); // Replace with your app icon

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    final AndroidFlutterLocalNotificationsPlugin androidPlugin =
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!;
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'azan_channel', // Channel ID
      'Azan Notifications', // Channel name
      description: 'Notifications for Azan times',
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound('azan8'),
    );

    await androidPlugin.createNotificationChannel(channel);
  }

  int testHour = 16;
  int testMin = 20;

  void scheduleAzanNotifications(Map<String, String?> timings) async {
    await init(); // Initialize notifications
    String currentTimeZone = await FlutterTimezone.getLocalTimezone();

    // Step 2: Ensure timezone is initialized before using
    final localZone = tz.getLocation(currentTimeZone);
    final tz.TZDateTime now = tz.TZDateTime.now(localZone);

    timings.forEach((azanName, azanTime) async {
      if (azanTime != null) {
        final azanParts = azanTime.split(':');
        final hour = int.parse(azanParts[0]);
        final minute = int.parse(azanParts[1]);

        final tz.TZDateTime azanDateTime = tz.TZDateTime(
          localZone,
          now.year,
          now.month,
          now.day,
          hour,
          minute+10,
        );

        if (azanDateTime.isAfter(now)) {
          await flutterLocalNotificationsPlugin.zonedSchedule(
            azanName.hashCode, // Unique ID for each notification
            "الصلاة",
            "حان وقت $azanName",
            azanDateTime,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'azan_channel', // Channel ID
                'Azan Notifications', // Channel name
                importance: Importance.high,
                sound: RawResourceAndroidNotificationSound('azan8'),
              ),
            ),
            uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
            androidScheduleMode: AndroidScheduleMode.alarmClock,
          );
        }
      }
    });
  }
}
