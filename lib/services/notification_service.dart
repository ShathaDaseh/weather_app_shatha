import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../main.dart';

class NotificationService {
  Future<void> showWeatherAlert(String message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          "weather_channel",
          "Weather Alerts",
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails notifDetails = NotificationDetails(
      android: androidDetails,
    );

    await notificationsPlugin.show(1, "Weather Alert", message, notifDetails);
  }
}
