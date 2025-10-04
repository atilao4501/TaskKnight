import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_knight_alpha/models/task.dart';
import 'package:task_knight_alpha/models/settings.dart';
import 'package:task_knight_alpha/services/notification_service.dart';
import 'package:task_knight_alpha/wrappers/main_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(SlimeColorAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(AppSettingsAdapter());

  await Hive.openBox<Task>('tasks');

  // 🔧 Tentar abrir box de configurações com migração automática
  try {
    await Hive.openBox<AppSettings>('settings');
  } catch (e) {
    // Se houver erro de compatibilidade, limpar e recriar
    print('⚠️ Erro de compatibilidade detectado: $e');
    print('🔄 Resetando configurações para versão compatível...');

    // Deletar box antiga e recriar
    await Hive.deleteBoxFromDisk('settings');
    await Hive.openBox<AppSettings>('settings');

    print('✅ Configurações resetadas com sucesso!');
  }

  // 🔔 Inicializar serviço de notificações
  await NotificationService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'VCR_OSD_MONO',
          useMaterial3: true,
        ),
        home: MainWrapper());
  }
}
