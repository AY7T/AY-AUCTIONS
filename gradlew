#!/usr/bin/env sh
set -eu

APP_HOME=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
GRADLE_VERSION=9.8.0
DIST_DIR="$APP_HOME/.gradle-wrapper/gradle-$GRADLE_VERSION"
DIST_ZIP="$APP_HOME/.gradle-wrapper/gradle-$GRADLE_VERSION-bin.zip"
DIST_URL="https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip"

if [ -z "${JAVA_HOME:-}" ]; then
  for candidate in "$HOME/.sdkman/candidates/java"/21* "$HOME/.local/share/jdks"/temurin-21*; do
    if [ -x "$candidate/bin/java" ]; then
      JAVA_HOME="$candidate"
      export JAVA_HOME
      break
    fi
  done
fi

if [ ! -x "${JAVA_HOME:-}/bin/java" ]; then
  echo "ERROR: Java 21 was not found. Install Java 21 and retry." >&2
  exit 1
fi

if [ ! -x "$DIST_DIR/bin/gradle" ]; then
  mkdir -p "$APP_HOME/.gradle-wrapper"
  echo "Downloading Gradle $GRADLE_VERSION..."
  if command -v curl >/dev/null 2>&1; then
    curl -fL "$DIST_URL" -o "$DIST_ZIP"
  elif command -v wget >/dev/null 2>&1; then
    wget -O "$DIST_ZIP" "$DIST_URL"
  else
    echo "ERROR: curl or wget is required to download Gradle." >&2
    exit 1
  fi
  echo "Extracting Gradle $GRADLE_VERSION..."
  unzip -q -o "$DIST_ZIP" -d "$APP_HOME/.gradle-wrapper"
fi

exec "$DIST_DIR/bin/gradle" --no-daemon "$@"
