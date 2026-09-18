import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();

  static final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel channel =
      AndroidNotificationChannel(
    'ot_updates',
    'Actualizaciones de OT',
    description:
        'Notificaciones de cambios de avance en órdenes de trabajo.',
    importance: Importance.max,
  );

  static Future<void> initialize() async {
    // Android 13+
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    const settings = InitializationSettings(
      android: AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      ),
    );

    await _localNotifications.initialize(
      settings,
    );

    final androidPlugin =
        _localNotifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(
      channel,
    );

    // Todos los usuarios del ERP recibirán
    // las notificaciones enviadas a este topic.
    await _messaging.subscribeToTopic(
      'all_users',
    );

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        final notification = message.notification;

        if (notification == null) {
          return;
        }

        await _localNotifications.show(
          notification.hashCode,
          notification.title ?? '2RM ERP',
          notification.body ?? '',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'ot_updates',
              'Actualizaciones de OT',
              channelDescription:
                  'Cambios en órdenes de trabajo.',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      },
    );

    final token = await _messaging.getToken();

    print('=============================');
    print('TOKEN FCM');
    print(token);
    print('=============================');
  }
}