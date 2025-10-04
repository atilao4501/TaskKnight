#!/bin/bash

# Script para copiar arquivo de som para o bundle do app macOS
# Isso garante que o som personalizado funcione nas notificações

SOUND_SOURCE="${SRCROOT}/../assets/sounds/task_notification.mp3"
SOUND_DEST="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/Resources/"

echo "🎵 Copiando som personalizado..."
echo "📂 De: $SOUND_SOURCE"
echo "📂 Para: $SOUND_DEST"

# Criar diretório se não existir
mkdir -p "$SOUND_DEST"

# Copiar arquivo de som
if [ -f "$SOUND_SOURCE" ]; then
    cp "$SOUND_SOURCE" "$SOUND_DEST"
    echo "✅ Som copiado com sucesso!"
else
    echo "❌ Arquivo de som não encontrado em: $SOUND_SOURCE"
fi