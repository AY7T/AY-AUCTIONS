@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem AY Auctions Gradle bootstrap wrapper.
rem Uses Gradle 9.8.0 and automatically prefers an installed Java 21.

set "APP_HOME=%~dp0"
set "WRAPPER_DIR=%APP_HOME%gradle\wrapper"
set "PROPS_FILE=%WRAPPER_DIR%\gradle-wrapper.properties"
set "GRADLE_VERSION=9.8.0"
set "DIST_DIR=%APP_HOME%.gradle-wrapper\gradle-%GRADLE_VERSION%"
set "DIST_ZIP=%APP_HOME%.gradle-wrapper\gradle-%GRADLE_VERSION%-bin.zip"
set "DIST_URL=https://services.gradle.org/distributions/gradle-%GRADLE_VERSION%-bin.zip"

rem Prefer an installed Java 21 JDK in the usual Eclipse Adoptium per-user location.
for /d %%D in ("%LOCALAPPDATA%\Programs\Eclipse Adoptium\jdk-21*") do (
  if exist "%%~fD\bin\java.exe" set "JAVA_HOME=%%~fD"
)

if defined JAVA_HOME if not exist "%JAVA_HOME%\bin\java.exe" set "JAVA_HOME="

rem If JAVA_HOME was not usable, inspect PATH for a Java 21 executable.
if not defined JAVA_HOME (
  for /f "delims=" %%J in ('where java 2^>nul') do (
    "%SystemRoot%\System32\cmd.exe" /c ""%%J" -version 2^>^&1 | findstr /r /c:"version \"21\." >nul"
    if not errorlevel 1 (
      for %%P in ("%%~dpJ..") do set "JAVA_HOME=%%~fP"
      goto :java_found
    )
  )
)

:java_found
if not defined JAVA_HOME (
  echo.
  echo ERROR: Java 21 was not found.
  echo Install Temurin/OpenJDK 21 and run this wrapper again.
  exit /b 1
)

set "JAVA_EXE=%JAVA_HOME%\bin\java.exe"

if not exist "%DIST_DIR%\bin\gradle.bat" (
  echo Downloading Gradle %GRADLE_VERSION%...
  if not exist "%APP_HOME%.gradle-wrapper" mkdir "%APP_HOME%.gradle-wrapper"

  powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri '%DIST_URL%' -OutFile '%DIST_ZIP%'"
  if errorlevel 1 (
    echo.
    echo ERROR: Could not download Gradle from:
    echo %DIST_URL%
    exit /b 1
  )

  echo Extracting Gradle %GRADLE_VERSION%...
  powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$ProgressPreference='SilentlyContinue'; Expand-Archive -LiteralPath '%DIST_ZIP%' -DestinationPath '%APP_HOME%.gradle-wrapper' -Force"
  if errorlevel 1 (
    echo.
    echo ERROR: Could not extract Gradle.
    exit /b 1
  )

  if not exist "%DIST_DIR%\bin\gradle.bat" (
    echo.
    echo ERROR: Gradle extraction completed but gradle.bat was not found.
    exit /b 1
  )
)

"%DIST_DIR%\bin\gradle.bat" --no-daemon %*
set "EXIT_CODE=%ERRORLEVEL%"
endlocal & exit /b %EXIT_CODE%
