# 🔊 Guia de Sons de Notificação - macOS

## ✅ Status Atual

- **Problema**: Sons personalizados (MP3) não funcionam no macOS com flutter_local_notifications
- **Solução**: Usar sons nativos do sistema macOS
- **Som escolhido**: "Sosumi" - um som clássico e distintivo do Mac

## 🎵 Sons Disponíveis no macOS

### Sons Recomendados para TaskKnight:

1. **"Sosumi"** ⭐ (Atual) - Som clássico do Mac, reconhecível
2. **"Hero"** - Som épico, perfeito para um app de tarefas
3. **"Glass"** - Som cristalino e agradável
4. **"Tink"** - Som sutil mas distintivo

### Outros Sons Disponíveis:

- "Ping" - Som simples
- "Pop" - Som de bolha
- "Blow" - Som de vento
- "Bottle" - Som de garrafa
- "Frog" - Som de sapo
- "Funk" - Som funky
- "Morse" - Som de código morse
- "Purr" - Som de ronronar

## 🧪 Como Testar

1. Execute o app no macOS
2. Va para Configurações → Notificações
3. Ative as notificações
4. Use o botão "Testar Notificação"
5. Ou aguarde o horário configurado para a notificação diária

## 🔄 Como Trocar o Som

No arquivo `lib/services/notification_sound_service.dart`, linha ~85:

```dart
return 'NomeDoSom'; // Troque por qualquer som da lista acima
```

## 🚀 Próximos Passos

Se quiser usar um som personalizado no futuro:

1. Adicionar o arquivo .aiff ao projeto Xcode
2. Configurar o bundle resources
3. Referenciar corretamente no código

## ⚠️ Importante

- Sempre teste no dispositivo real, não no simulador
- Verifique se o volume do sistema não está mutado
- Certifique-se de que as permissões de notificação estão concedidas
