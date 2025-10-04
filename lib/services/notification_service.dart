import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import '../models/settings.dart';
import './notification_sound_service.dart';

/// 🔔 Serviço responsável por gerenciar notificações locais
///
/// Este serviço funciona da seguinte forma:
///
/// 1. **Inicialização**: Configura as notificações para cada plataforma
/// 2. **Permissões**: Solicita permissões do sistema operacional
/// 3. **Agendamento**: Programa notificações para horários específicos
/// 4. **Cancelamento**: Remove notificações quando desabilitadas
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// 🚀 Inicializa o serviço de notificações
  ///
  /// **Por que cada plataforma é diferente?**
  /// - **Android**: Usa ícones, canais de notificação
  /// - **iOS**: Requer permissões especiais, sons diferentes
  /// - **macOS**: Tem seu próprio sistema de notificações
  /// - **Windows/Linux**: Sistemas de notificação nativos diferentes
  static Future<void> initialize() async {
    // Inicializar timezone (necessário para agendar notificações)
    tz.initializeTimeZones();

    // ⚙️ Configurações para Android
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // ⚙️ Configurações para iOS
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    // ⚙️ Configurações para macOS
    const DarwinInitializationSettings macOSSettings =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    // ⚙️ Configurações para Linux
    const LinuxInitializationSettings linuxSettings =
        LinuxInitializationSettings(
      defaultActionName: 'Abrir TaskKnight',
    );

    // ⚙️ Configuração geral para todas as plataformas
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: macOSSettings,
      linux: linuxSettings,
    );

    // 🔄 Inicializar o plugin
    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // 📱 Solicitar permissões (principalmente para iOS/macOS)
    await _requestPermissions();

    // 🧹 CRÍTICO: Sincronizar estado com Hive para resolver notificações órfãs
    await _syncNotificationStateWithHive();
  }

  /// 🔐 Solicita permissões do sistema
  ///
  /// **Por que precisamos de permissões?**
  /// - iOS/macOS são muito restritivos com notificações
  /// - Android 13+ também requer permissões explícitas
  /// - O usuário precisa aprovar que o app pode enviar notificações
  static Future<void> _requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

      await _notifications
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }

    // Android 13+ requer permissão para notificações
    if (defaultTargetPlatform == TargetPlatform.android) {
      final status = await Permission.notification.request();
      if (status.isDenied) {
        if (kDebugMode) {
          print('❌ Permissão de notificação negada no Android');
        }
      }
    }
  }

  /// 📅 Agenda notificações diárias baseadas nas configurações do usuário
  ///
  /// **Como funciona o agendamento?**
  /// 1. Lê as configurações salvas no Hive
  /// 2. Calcula o próximo horário de notificação
  /// 3. Agenda a notificação usando timezone
  /// 4. Configura para repetir diariamente
  static Future<void> scheduleTaskReminder() async {
    try {
      // 📖 Buscar configurações salvas no Hive
      final settings = await AppSettings.getSettings();

      // ❌ Se notificações estão desabilitadas, não fazer nada
      if (!settings.pushNotificationsEnabled) {
        if (kDebugMode) {
          print('🔕 Notificações desabilitadas pelo usuário');
        }
        return;
      }

      // 🕐 Calcular próximo horário de notificação
      final now = DateTime.now();
      var scheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        settings.notificationHour,
        settings.notificationMinute,
      );

      // Se o horário já passou hoje, agendar para amanhã
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      // 🌍 Converter para timezone (necessário para notificações agendadas)
      final tz.TZDateTime tzScheduledDate = tz.TZDateTime.from(
        scheduledDate,
        tz.local,
      );

      // 🎵 Preparar sons personalizados de forma unificada
      final sounds = await NotificationSoundService.prepareSounds();

      // 🔔 Detalhes da notificação para Android
      AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'daily_reminder',
        'Lembretes Diários TaskKnight',
        channelDescription:
            'Notificações épicas para lembrar de suas aventuras!',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        // 🔊 SOM PERSONALIZADO: Arquivo na pasta android/app/src/main/res/raw/
        sound: RawResourceAndroidNotificationSound('notification_sound'),
        // 💫 EFEITOS VISUAIS
        enableLights: true,
        color: Color(0xFF4CAF50), // Cor verde do TaskKnight
        enableVibration: true,
        playSound: true, // Garante som padrão se custom falhar
      );

      // 🔔 Detalhes da notificação para iOS
      DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        // 🔊 SOM UNIFICADO: Usa seu MP3 convertido dos assets
        sound: sounds['ios'], // Se null, usa som padrão
        badgeNumber: 1,
      );

      // 🔔 Detalhes da notificação para macOS
      DarwinNotificationDetails macOSDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        // 🔊 SOM DEBUG: Testar diferentes opções para macOS
        sound: null, // TEMP: Use system default to test if custom sounds work
        badgeNumber: 1,
      );

      final NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
        macOS: macOSDetails,
      );

      // 📨 Agendar a notificação
      await _notifications.zonedSchedule(
        0, // ID da notificação
        '⚔️ TaskKnight - Suas Tarefas Te Esperam!', // 📝 TÍTULO (aparece em destaque)
        '🎯 Hora de completar suas missões e derrotar os slimes! 🐉', // 📝 TEXTO (corpo da notificação)
        tzScheduledDate, // Quando disparar
        platformDetails, // Configurações da plataforma
        matchDateTimeComponents:
            DateTimeComponents.time, // Repetir diariamente no mesmo horário
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      if (kDebugMode) {
        print('✅ Notificação agendada para: $scheduledDate');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro ao agendar notificação: $e');
      }
    }
  }

  /// � Sincroniza o estado das notificações com as configurações do Hive
  ///
  /// **RESOLVE O PROBLEMA DAS NOTIFICAÇÕES ÓRFÃS:**
  ///
  /// Cenário problemático:
  /// 1. Usuário ativa notificação → Sistema agenda
  /// 2. Usuário limpa dados do app → Hive reseta para padrão
  /// 3. Hive mostra desativado, mas notificação ainda dispara!
  ///
  /// Esta função:
  /// - ✅ Verifica se há notificações ativas no sistema
  /// - ✅ Compara com as configurações do Hive
  /// - ✅ Remove notificações órfãs automaticamente
  /// - ✅ Reagenda se necessário baseado no Hive
  static Future<void> _syncNotificationStateWithHive() async {
    try {
      // 📖 Buscar configurações atuais do Hive
      final settings = await AppSettings.getSettings();

      // 🔍 Verificar notificações ativas no sistema
      final List<PendingNotificationRequest> pendingNotifications =
          await _notifications.pendingNotificationRequests();

      if (kDebugMode) {
        print(
            '🔍 Notificações pendentes no sistema: ${pendingNotifications.length}');
        for (var notification in pendingNotifications) {
          print('   📋 ID: ${notification.id}, Título: ${notification.title}');
        }
      }

      // 🧹 Cenário 1: Hive diz que está desabilitado, mas há notificações ativas
      if (!settings.pushNotificationsEnabled &&
          pendingNotifications.isNotEmpty) {
        if (kDebugMode) {
          print('⚠️ NOTIFICAÇÕES ÓRFÃS DETECTADAS!');
          print('   Hive: pushNotificationsEnabled = false');
          print(
              '   Sistema: ${pendingNotifications.length} notificações ativas');
          print('🧹 Limpando notificações órfãs...');
        }

        // Cancelar todas as notificações órfãs
        await _notifications.cancelAll();

        if (kDebugMode) {
          print('✅ Notificações órfãs removidas com sucesso!');
        }
      }

      // 🔄 Cenário 2: Hive diz que está habilitado, reagendar para garantir
      else if (settings.pushNotificationsEnabled) {
        if (kDebugMode) {
          print('🔔 Notificações habilitadas no Hive, reagendando...');
        }

        // Cancelar notificações existentes e reagendar com configurações atuais
        await _notifications.cancelAll();
        await scheduleTaskReminder();
      }

      // ✅ Cenário 3: Tudo sincronizado (Hive desabilitado + nenhuma notificação ativa)
      else {
        if (kDebugMode) {
          print('✅ Estado sincronizado: Notificações desabilitadas em ambos');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro ao sincronizar notificações: $e');
      }
    }
  }

  /// �🚫 Cancela todas as notificações agendadas
  ///
  /// **Quando usar?**
  /// - Quando o usuário desabilita as notificações
  /// - Quando o usuário muda o horário (cancela a antiga, agenda nova)
  /// - Quando o app é desinstalado
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    if (kDebugMode) {
      print('🔕 Todas as notificações foram canceladas');
    }
  }

  /// 📱 Manipula quando o usuário toca na notificação
  ///
  /// **O que acontece aqui?**
  /// - O app é aberto (se estava fechado)
  /// - Pode navegar para uma tela específica
  /// - Pode mostrar informações relevantes
  static void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print('🔔 Notificação tocada: ${response.payload}');
    }

    // Aqui você pode adicionar lógica para:
    // - Navegar para uma tela específica
    // - Mostrar as tarefas pendentes
    // - Abrir a tela de adicionar tarefa
  }

  /// 🔄 Força uma sincronização manual entre Hive e notificações do sistema
  ///
  /// **Use esta função quando:**
  /// - Usuário relatar notificações fantasma
  /// - Após restaurar backup do app
  /// - Em telas de configuração para "limpar" o estado
  static Future<void> forceSyncNotifications() async {
    await _syncNotificationStateWithHive();
  }

  /// 📋 Retorna informações sobre notificações ativas (para debug/diagnóstico)
  static Future<Map<String, dynamic>> getNotificationStatus() async {
    try {
      final settings = await AppSettings.getSettings();
      final allPendingNotifications =
          await _notifications.pendingNotificationRequests();

      // 🚫 FILTER OUT test notifications - only count daily reminders
      final dailyNotifications = allPendingNotifications
          .where((n) => n.id != 99999) // Exclude test notification ID
          .toList();

      if (kDebugMode) {
        print('🔍 Total pending: ${allPendingNotifications.length}');
        print('🔍 Daily only: ${dailyNotifications.length}');
        print(
            '🔍 Test notifications filtered out: ${allPendingNotifications.length - dailyNotifications.length}');
      }

      return {
        'hive_enabled': settings.pushNotificationsEnabled,
        'hive_time': settings.notificationTimeString,
        'system_notifications_count':
            dailyNotifications.length, // Only count daily notifications
        'system_notifications': dailyNotifications
            .map((n) => {
                  'id': n.id,
                  'title': n.title,
                  'body': n.body,
                })
            .toList(),
        'is_synced': (settings.pushNotificationsEnabled &&
                dailyNotifications.isNotEmpty) ||
            (!settings.pushNotificationsEnabled && dailyNotifications.isEmpty),
      };
    } catch (e) {
      return {
        'error': e.toString(),
      };
    }
  }

  /// 🧪 Sends a one-time test notification (development only)
  /// ⚠️ This is a TEMPORARY test - does NOT schedule recurring notifications
  static Future<void> sendTestNotification() async {
    if (kDebugMode) {
      print('🧪 SINGLE TEST - NOT scheduling recurring notifications');
      print(
          '🔊 Testing notification_sound.mp3 from android/app/src/main/res/raw/');
    }

    // 🔊 ANDROID: Use raw resource directly (working!)
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'test_only_channel', // ⚠️ DIFFERENT channel - won't interfere with daily notifications
      'Test Notification',
      channelDescription: 'One-time test notification with custom sound',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      sound: RawResourceAndroidNotificationSound('notification_sound'),
      enableLights: true,
      color: Color(0xFF4CAF50),
      enableVibration: true,
      playSound: true,
    );

    // 🔊 iOS: Test with custom sound
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'notification_sound.mp3', // Try direct filename for iOS
      badgeNumber: 1,
    );

    // 🔊 macOS: Test with custom sound - try AIFF format
    const DarwinNotificationDetails macOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'notification_sound.aiff', // Try AIFF format for macOS
      badgeNumber: 1,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: macOSDetails,
    );

    // 🎯 SINGLE notification with unique ID - NO recurring schedule
    await _notifications.show(
      99999, // Unique test ID - different from daily notifications
      '🧪 Test - TaskKnight Working!',
      '⚔️ Get ready warrior! Your epic tasks await! 🐉✨',
      platformDetails,
    );

    if (kDebugMode) {
      print('✅ Single test notification sent - no recurring schedule created');
    }
  }
}
