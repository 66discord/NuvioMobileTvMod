#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

TVMOD_URL="https://github.com/MarechalSp/NuvioTvMod.git"
WORK=".tvmod-source"

echo "== NuvioMobileTvMod: integração NuvioTvMod =="
echo "Branch atual: $(git branch --show-current)"

pkg install -y git rsync python >/dev/null 2>&1 || true

rm -rf "$WORK"
git clone --depth=1 "$TVMOD_URL" "$WORK"

echo "[1/4] Copiando módulo de canais de TV + EPG..."
mkdir -p composeApp/src/commonMain/kotlin/com/nuvio/app/features
mkdir -p composeApp/src/androidMain/kotlin/com/nuvio/app/features
mkdir -p composeApp/src/iosMain/kotlin/com/nuvio/app/features
mkdir -p composeApp/src/desktopMain/kotlin/com/nuvio/app/features

rsync -a "$WORK/composeApp/src/commonMain/kotlin/com/nuvio/app/features/tvchannels/"   composeApp/src/commonMain/kotlin/com/nuvio/app/features/tvchannels/
rsync -a "$WORK/composeApp/src/androidMain/kotlin/com/nuvio/app/features/tvchannels/"   composeApp/src/androidMain/kotlin/com/nuvio/app/features/tvchannels/ 2>/dev/null || true
rsync -a "$WORK/composeApp/src/iosMain/kotlin/com/nuvio/app/features/tvchannels/"   composeApp/src/iosMain/kotlin/com/nuvio/app/features/tvchannels/ 2>/dev/null || true
rsync -a "$WORK/composeApp/src/desktopMain/kotlin/com/nuvio/app/features/tvchannels/"   composeApp/src/desktopMain/kotlin/com/nuvio/app/features/tvchannels/ 2>/dev/null || true

echo "[2/4] Copiando recursos específicos de TV/EPG..."
mkdir -p composeApp/src/commonMain/composeResources
for d in "$WORK"/composeApp/src/commonMain/composeResources/values*; do
  [ -d "$d" ] || continue
  rsync -a "$d/" "composeApp/src/commonMain/composeResources/$(basename "$d")/" 2>/dev/null || true
done

echo "[3/4] Instalando patch de integração (sem substituir o núcleo atual do NuvioMobile)..."
mkdir -p scripts
cat > scripts/tvmod-integration-info.txt <<'EOF'
NuvioTvMod integration source:
https://github.com/MarechalSp/NuvioTvMod
Imported feature:
- TV channels
- XMLTV EPG models/repository/parser
- TV channel settings/storage
- TV channel UI components
- TV channel player integration

The current official NuvioMobile branch remains the base.
Review conflicts before enabling player PiP integration.
EOF

echo "[4/4] Limpando fonte temporária..."
rm -rf "$WORK"

echo
echo "Integração base copiada."
echo "Agora execute:"
echo "  ./gradlew :androidApp:assembleFullDebug --stacktrace"
echo
echo "Se houver erro de compilação, NÃO apague o projeto."
echo "Cole aqui as últimas ~80 linhas do erro para eu ajustar o patch."
