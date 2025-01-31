import 'package:permission_handler/permission_handler.dart';

class Permissions {
  static Future<void> notifications() async {
    PermissionStatus status = await Permission.notification.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      status = await Permission.notification.request();
    }

    if (!status.isGranted) {
      print('Notification permission not granted.');
    }
  }

  static Future<void> alarm() async {
    PermissionStatus AlarmStatus = await Permission.scheduleExactAlarm.status;

    if (AlarmStatus.isDenied || AlarmStatus.isPermanentlyDenied) {
      AlarmStatus = await Permission.scheduleExactAlarm.request();
    }

    if (!AlarmStatus.isGranted) {
      print('Exact alarm permission is not granted.');
    }
  }
}
