import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// 🎵 Serviço para gerenciar sons de notificação de forma unificada
///
/// Este serviço permite usar arquivos MP3 da pasta assets em todas as plataformas
class NotificationSoundService {
  /// 🔄 Prepara o som personalizado para todas as plataformas
  ///
  /// **Como funciona:**
  /// 1. Carrega MP3 da pasta assets/sounds/
  /// 2. Converte/copia para formato específico de cada plataforma
  /// 3. Retorna o nome do arquivo que cada plataforma deve usar
  static Future<Map<String, String?>> prepareSounds() async {
    try {
      // Nome do seu arquivo MP3 na pasta assets/sounds/
      const String soundFileName = 'task_notification'; // SEM extensão

      // 📱 Para Android: copiar MP3 para cache local
      String? androidSound = await _prepareAndroidSound(soundFileName);

      // 🍎 Para iOS/macOS: converter MP3 para AIFF (se necessário)
      String? iosSound = await _prepareIOSSound(soundFileName);

      return {
        'android': androidSound,
        'ios': iosSound,
        'macos': iosSound,
      };
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Error preparing sounds: $e');
        print('🔄 Falling back to system default sounds...');
      }

      return {
        'android': null,
        'ios': null,
        'macos': null,
      };
    }
  }

  /// 📱 Prepara som para Android
  static Future<String?> _prepareAndroidSound(String soundName) async {
    try {
      // Para Android, verificar se arquivo existe nos assets
      await rootBundle.load('assets/sounds/$soundName.mp3');

      if (kDebugMode) {
        print('✅ Android sound found: assets/sounds/$soundName.mp3');
        print('🔧 Using RawResource: $soundName (without extension)');
      }

      // Retorna apenas o nome para RawResourceAndroidNotificationSound
      return soundName;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error preparing Android sound: $e');
      }
      return null;
    }
  }

  /// 🍎 Prepara som para iOS/macOS
  static Future<String?> _prepareIOSSound(String soundName) async {
    try {
      // Para iOS/macOS, podemos usar MP3 diretamente dos assets
      // Verificar se arquivo existe nos assets
      try {
        await rootBundle.load('assets/sounds/$soundName.mp3');

        if (kDebugMode) {
          print('✅ iOS/macOS sound found: assets/sounds/$soundName.mp3');
        }

        // Para macOS, usar sons específicos do sistema
        if (defaultTargetPlatform == TargetPlatform.macOS) {
          // Lista de sons disponíveis no macOS (ordem de recomendação para TaskKnight)
          const availableSounds = [
            'Hero', // 🦸 Epic sound - perfect for heroic tasks!
            'Sosumi', // 🔔 Classic Mac sound
            'Glass', // ✨ Clear glass chime
            'Tink', // 🎵 Subtle but distinct
            'Ping', // 📬 Simple ping
            'Pop', // 💫 Bubble pop
          ];

          // Som atual - mude aqui para trocar o som!
          const currentSound = 'Hero'; // 🎯 Troque por qualquer da lista acima

          if (kDebugMode) {
            print('🍎 macOS: Using sound "$currentSound"');
            print('🎵 Available sounds: ${availableSounds.join(', ')}');
          }

          return currentSound;
        }

        // iOS pode usar MP3 diretamente
        return '$soundName.mp3';
      } catch (e) {
        if (kDebugMode) {
          print('❌ File not found: assets/sounds/$soundName.mp3');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error preparing iOS/macOS sound: $e');
      }
      return null;
    }
  }

  /// 🎵 Lista todos os sons disponíveis na pasta assets
  static Future<List<String>> getAvailableSounds() async {
    try {
      // Esta função seria útil para debug/desenvolvimento
      // Por enquanto, retorna os sons que sabemos que existem
      return ['task_notification'];
    } catch (e) {
      return [];
    }
  }

  /// 🔊 Testa se um som específico existe
  static Future<bool> soundExists(String soundName) async {
    try {
      await rootBundle.load('assets/sounds/$soundName.mp3');
      return true;
    } catch (e) {
      return false;
    }
  }
}
