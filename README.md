# AY Auctions

Standalone Fabric mod for Minecraft Java 1.21.11, made by ay7t.

## Build on Windows

Use Java 21. The included `gradlew.bat` will automatically prefer an Eclipse Adoptium Java 21 installation under your user profile.

From this folder in PowerShell:

```powershell
.\gradlew.bat clean build
```

The first run downloads Gradle 9.8.0 automatically. After a successful build, the mod JAR will be in:

```text
build\libs\
```

Copy the regular `ay-auctions-1.0.0.jar` to your Fabric 1.21.11 `mods` folder.

## Default key

`J` opens AY Auctions settings. The key can be changed in Minecraft Controls.

## Features

- Auction HUD with real Minecraft item rendering
- Configurable payment username
- Chat payment/bid detection
- Highest-bid comparison
- Minimum bid and auction duration
- Item picker with search
- HUD visibility toggles
- HUD move and scale controls
- Persistent config
- "Made by ay7t" credit in settings
