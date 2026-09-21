# NuvioMobileTvMod — integração NuvioTvMod

Esta branch usa o **NuvioMobile oficial como base** e prepara a importação das funcionalidades do **MarechalSp/NuvioTvMod**, evitando substituir o código atual do NuvioMobile.

## Termux

```bash
pkg update -y
pkg install -y git wget unzip openjdk-17 rsync python
git clone https://github.com/66discord/NuvioMobileTvMod.git
cd NuvioMobileTvMod
git checkout tvmod-mobile
chmod +x gradlew scripts/apply-tvmod-mobile.sh
./scripts/apply-tvmod-mobile.sh
./gradlew :androidApp:assembleFullDebug --stacktrace
```

O APK de debug será gerado dentro de `androidApp/build/outputs/apk/`.

## O que a integração prepara

- Canais de TV.
- EPG/XMLTV.
- Grade de programação.
- Fontes EPG e cache local.
- Configurações de canais.
- Interface de lista/cartões.
- Player específico para canais.
- Estrutura para Picture-in-Picture.

A integração é feita sobre a branch `cmp-rewrite` atual do NuvioMobile, que continua sendo o núcleo do projeto.

## Importante

O NuvioTvMod possui modificações próprias também no player e em arquivos compartilhados. Esses pontos precisam ser adaptados ao código atual do NuvioMobile em vez de simplesmente sobrescritos. O script importa primeiro o módulo isolado de TV/EPG para reduzir conflitos.

## Build

O NuvioMobile oficial documenta:

```bash
./gradlew :androidApp:assembleFullDebug
```

