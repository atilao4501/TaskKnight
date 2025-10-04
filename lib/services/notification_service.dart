import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import '../models/settings.dart';
import './notification_sound_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      ),
      macOS: DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      ),
      linux: LinuxInitializationSettings(
        defaultActionName: 'Abrir TaskKnight',
      ),
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _requestPermissions();
    await _syncWithSettings();
  }

  static Future<void> _requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);

      await _notifications
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.notification.request();
    }
  }

  static Future<void> scheduleTaskReminder() async {
    try {
      final settings = await AppSettings.getSettings();
      if (!settings.pushNotificationsEnabled) return;

      final now = DateTime.now();
      var scheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        settings.notificationHour,
        settings.notificationMinute,
      );

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);
      final sounds = await NotificationSoundService.prepareSounds();

      if (kDebugMode) {
        print('🎵 Sounds preparados: $sounds');
        print('🍎 Som macOS: ${sounds['macos']}');
      }

      final platformDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Lembretes Diários TaskKnight',
          channelDescription: 'Notificações para lembrar de suas tarefas',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          sound: RawResourceAndroidNotificationSound('notification_sound'),
          enableLights: true,
          color: Color(0xFF4CAF50),
          enableVibration: true,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: sounds['ios'],
          badgeNumber: 1,
        ),
        macOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: sounds['macos'],
          badgeNumber: 1,
        ),
      );

      await _notifications.zonedSchedule(
        0,
        '⚔️ TaskKnight - Your Tasks Await!',
        '🎯 Time to complete your quests and defeat the slimes! 🐉',
        tzScheduledDate,
        platformDetails,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      if (kDebugMode) print('Erro ao agendar notificação: $e');
    }
  }

  static Future<void> _syncWithSettings() async {
    try {
      final settings = await AppSettings.getSettings();
      final pending = await _notifications.pendingNotificationRequests();

      if (!settings.pushNotificationsEnabled && pending.isNotEmpty) {
        await _notifications.cancelAll();
      } else if (settings.pushNotificationsEnabled) {
        await _notifications.cancelAll();
        await scheduleTaskReminder();
      }
    } catch (e) {
      if (kDebugMode) print('Erro ao sincronizar: $e');
    }
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  static void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) print('Notificação tocada: ${response.payload}');
  }

  static Future<void> forceSyncNotifications() async {
    await _syncWithSettings();
  }

  static Future<Map<String, dynamic>> getNotificationStatus() async {
    try {
      final settings = await AppSettings.getSettings();
      final pending = await _notifications.pendingNotificationRequests();
      final dailyNotifications = pending.where((n) => n.id != 99999).toList();

      return {
        'hive_enabled': settings.pushNotificationsEnabled,
        'hive_time': settings.notificationTimeString,
        'system_notifications_count': dailyNotifications.length,
        'is_synced': (settings.pushNotificationsEnabled &&
                dailyNotifications.isNotEmpty) ||
            (!settings.pushNotificationsEnabled && dailyNotifications.isEmpty),
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  static Future<void> sendTestNotification() async {
    const platformDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'test_channel',
        'Test Notifications',
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('notification_sound'),
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'notification_sound.mp3',
      ),
      macOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'Hero', // Som épico para TaskKnight! 🦸‍♂️
      ),
    );

    await _notifications.show(
      99999,
      '🧪 Test - TaskKnight Working!',
      '⚔️ Get ready warrior! Your epic tasks await! 🐉✨',
      platformDetails,
    );
  }
}
