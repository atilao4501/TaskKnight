import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 2)
class AppSettings extends HiveObject {
  @HiveField(0)
  bool pushNotificationsEnabled;

  @HiveField(1)
  int notificationHour;

  @HiveField(2)
  int notificationMinute;

  @HiveField(3)
  bool? isFirstRun;

  AppSettings({
    this.pushNotificationsEnabled = false,
    this.notificationHour = 20,
    this.notificationMinute = 0,
    this.isFirstRun,
  });

  String get notificationTimeString {
    final hour = notificationHour.toString().padLeft(2, '0');
    final minute = notificationMinute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static Future<AppSettings> getSettings() async {
    final box = await Hive.openBox<AppSettings>('settings');
    if (box.isEmpty) {
      final defaultSettings = AppSettings(isFirstRun: true);
      await box.add(defaultSettings);
      return defaultSettings;
    }
    final settings = box.values.first;
    settings._migrateIfNeeded();
    return settings;
  }

  /// 🔍 Detecta se é a primeira execução ou dados foram limpos
  /// Útil para identificar quando pode haver notificações órfãs
  static Future<bool> isFirstRunAfterDataClear() async {
    final box = await Hive.openBox<AppSettings>('settings');
    if (box.isEmpty) return true;

    final settings = box.values.first;
    // Se isFirstRun for null (dados antigos), considerar como primeira execução
    return settings.isFirstRun ?? true;
  }

  /// 📝 Marca que o primeiro run foi completado
  Future<void> markFirstRunComplete() async {
    isFirstRun = false;
    await saveSettings();
  }

  /// 🔧 Migra dados antigos para o novo formato (chama automaticamente)
  void _migrateIfNeeded() {
    // Se isFirstRun for null, significa dados antigos - definir como false
    // pois se há dados salvos, não é primeira execução
    if (isFirstRun == null) {
      isFirstRun = false;
    }
  }

  Future<void> saveSettings() async {
    final box = await Hive.openBox<AppSettings>('settings');
    if (box.isEmpty) {
      await box.add(this);
    } else {
      await box.putAt(0, this);
    }
  }
}
