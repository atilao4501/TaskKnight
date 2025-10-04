import 'package:flutter/material.dart';
import '../models/settings.dart';
import '../services/notification_service.dart';
import '../widgets/custom_back_button.dart' as custom;
import '../widgets/accept_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  AppSettings? _settings;
  bool _isLoading = true;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await AppSettings.getSettings();
      setState(() {
        _settings = settings;
        _selectedTime = TimeOfDay(
          hour: settings.notificationHour,
          minute: settings.notificationMinute,
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading settings: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _selectTime() async {
    if (_selectedTime == null) return;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime!,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4CAF50),
              onPrimary: Colors.white,
              surface: Color(0xFFA67B5B),
              onSurface: Colors.white,
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(
                fontFamily: 'VCR_OSD_MONO',
                color: Colors.white,
              ),
              bodyMedium: TextStyle(
                fontFamily: 'VCR_OSD_MONO',
                color: Colors.white,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveSettings() async {
    if (_settings == null || _selectedTime == null) return;

    try {
      _settings!.notificationHour = _selectedTime!.hour;
      _settings!.notificationMinute = _selectedTime!.minute;
      await _settings!.saveSettings();

      // 🔔 Reagendar notificações com as novas configurações
      if (_settings!.pushNotificationsEnabled) {
        await NotificationService.scheduleTaskReminder();
      } else {
        await NotificationService.cancelAllNotifications();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Settings saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving settings: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _toggleNotifications(bool value) {
    if (_settings != null) {
      setState(() {
        _settings!.pushNotificationsEnabled = value;
      });
    }
  }

  /// 🔍 Mostra informações de diagnóstico das notificações
  Future<void> _showDiagnostics() async {
    try {
      // Buscar status das notificações
      final status = await NotificationService.getNotificationStatus();

      // Forçar sincronização
      await NotificationService.forceSyncNotifications();

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFFA67B5B),
            title: const Text(
              '🔍 Notification Diagnostics',
              style: TextStyle(
                fontFamily: 'VCR_OSD_MONO',
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '📱 App Configuration:',
                    style: TextStyle(
                      fontFamily: 'VCR_OSD_MONO',
                      fontSize: 12,
                      color: Colors.yellow.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '• Enabled: ${status['hive_enabled']}',
                    style: const TextStyle(
                      fontFamily: 'VCR_OSD_MONO',
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '• Time: ${status['hive_time']}',
                    style: const TextStyle(
                      fontFamily: 'VCR_OSD_MONO',
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '🔔 Operating System:',
                    style: TextStyle(
                      fontFamily: 'VCR_OSD_MONO',
                      fontSize: 12,
                      color: Colors.yellow.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '• Active notifications: ${status['system_notifications_count']}',
                    style: const TextStyle(
                      fontFamily: 'VCR_OSD_MONO',
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '✅ Status:',
                    style: TextStyle(
                      fontFamily: 'VCR_OSD_MONO',
                      fontSize: 12,
                      color: Colors.yellow.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    status['is_synced']
                        ? '✅ Synchronized'
                        : '⚠️ Desynchronized',
                    style: TextStyle(
                      fontFamily: 'VCR_OSD_MONO',
                      fontSize: 10,
                      color: status['is_synced'] ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (mounted) Navigator.pop(context); // Close dialog FIRST
                  await NotificationService.sendTestNotification();
                  // DON'T call any sync or save functions after test
                },
                child: const Text(
                  '🧪 Test',
                  style: TextStyle(
                    fontFamily: 'VCR_OSD_MONO',
                    color: Colors.orange,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    fontFamily: 'VCR_OSD_MONO',
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Diagnostic error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFC19A6B),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF4CAF50),
          ),
        ),
      );
    }

    if (_settings == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFC19A6B),
        body: Center(
          child: Text(
            'Error loading settings',
            style: TextStyle(
              fontFamily: 'VCR_OSD_MONO',
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFC19A6B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFA67B5B),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Botão de voltar
                      custom.BackButton(
                        onPressed: () => Navigator.pop(context),
                      ),

                      // Título
                      const Positioned(
                        left: 0,
                        right: 0,
                        top: 80,
                        child: Center(
                          child: Text(
                            'Settings',
                            style: TextStyle(
                              fontFamily: 'VCR_OSD_MONO',
                              fontSize: 24,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(2, 2),
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Conteúdo principal
                      Positioned(
                        left: 10,
                        top: 150,
                        child: Container(
                          width: 333,
                          height: 502,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Seção Push Notifications
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Push Notifications',
                                      style: TextStyle(
                                        fontFamily: 'VCR_OSD_MONO',
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Switch(
                                      value:
                                          _settings!.pushNotificationsEnabled,
                                      onChanged: _toggleNotifications,
                                      activeColor: const Color(0xFF4CAF50),
                                      activeTrackColor: const Color(0xFF4CAF50)
                                          .withValues(alpha: 0.5),
                                      inactiveThumbColor: Colors.grey,
                                      inactiveTrackColor:
                                          Colors.grey.withValues(alpha: 0.3),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Seção Time Picker (só aparece se notificações estão ativadas)
                              if (_settings!.pushNotificationsEnabled) ...[
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Notification Time',
                                        style: TextStyle(
                                          fontFamily: 'VCR_OSD_MONO',
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      GestureDetector(
                                        onTap: _selectTime,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF4CAF50),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.25),
                                                offset: const Offset(0, 2),
                                                blurRadius: 2,
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.access_time,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                _selectedTime!.format(context),
                                                style: const TextStyle(
                                                  fontFamily: 'VCR_OSD_MONO',
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              const Spacer(),

                              // Botões de ação
                              Column(
                                children: [
                                  // Botão de diagnóstico (para debug)
                                  if (_settings!.pushNotificationsEnabled)
                                    GestureDetector(
                                      onTap: _showDiagnostics,
                                      child: Container(
                                        width: 200,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.25),
                                              offset: const Offset(0, 2),
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: const Center(
                                          child: Text(
                                            '🔍 Diagnosticar',
                                            style: TextStyle(
                                              fontFamily: 'VCR_OSD_MONO',
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                  const SizedBox(height: 8),

                                  // Botão Salvar
                                  AcceptButton(
                                    onPressed: _saveSettings,
                                    label: 'Salvar',
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
