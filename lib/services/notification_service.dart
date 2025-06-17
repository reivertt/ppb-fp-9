import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();

  Future<void> init() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'plant_care_channel_group',
          channelKey: 'plant_care_channel',
          channelName: 'Plant Care Reminders',
          channelDescription: 'Notifications for watering, fertilizing, etc.',
          defaultColor: const Color(0xFF046526),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'plant_care_channel_group',
          channelGroupName: 'Plant Reminders',
        )
      ],
      debug: true, // Set to false in production
    );

    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'plant_care_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
        // You can add a payload to pass data to the app when the notification is tapped
        // payload: {'plantId': '123'},
      ),
      schedule: NotificationCalendar.fromDate(date: scheduledTime, allowWhileIdle: true),
    );
  }

  Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }
}
