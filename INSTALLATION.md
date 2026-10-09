# SSL Hybrid Backtester - Installation Guide

## Prerequisites

### System Requirements
- **OS**: Windows, macOS, or Linux
- **RAM**: Minimum 4GB (8GB recommended)
- **Storage**: At least 5GB free space
- **Android SDK**: API level 21 or higher

### Required Software
1. **Flutter SDK** (v3.13.0 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Add to PATH: `flutter/bin`

2. **Dart SDK** (included with Flutter)

3. **Android Studio** or **Android SDK Command-line Tools**
   - Download from: https://developer.android.com/studio
   - Set `ANDROID_SDK_ROOT` environment variable

4. **Java Development Kit (JDK)**
   - JDK 11 or higher
   - Download from: https://www.oracle.com/java/technologies/downloads/

## Installation Steps

### 1. Clone Repository
```bash
git clone https://github.com/abofzabofz3-source/SSL-Hybrid-Backtest.git
cd SSL-Hybrid-Backtest
git checkout flutter-android-app
```

### 2. Verify Flutter Setup
```bash
flutter doctor
```
All items should show green checkmarks ✓

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Connect Android Device or Start Emulator

**Option A: Physical Device**
```bash
# Enable USB Debugging on your device
# Then:
adb devices  # Should show your device
```

**Option B: Android Emulator**
```bash
# Using Android Studio Emulator
flutter emulators
flutter emulators --launch emulator_name

# Or using created emulator:
flutter devices
```

### 5. Build and Run

**Debug Mode** (Fastest for development)
```bash
flutter run
```

**Release Mode** (Better performance)
```bash
flutter run --release
```

**Build APK** (For installation on other devices)
```bash
flutter build apk --release
# APK will be at: build/app/outputs/flutter-apk/app-release.apk
```

**Build App Bundle** (For Google Play Store)
```bash
flutter build appbundle --release
# Bundle will be at: build/app/outputs/bundle/release/app-release.aab
```

## Configuration

### 1. Default Strategy Parameters
Edit `lib/config/app_config.dart`:
```dart
static const Map<String, dynamic> defaultStrategyParams = {
  'ssl1_type': 'HMA',        // Change to: SMA, EMA, DEMA, etc.
  'ssl1_length': 60,         // Baseline length
  'ssl2_type': 'JMA',        // Continuation type
  'ssl2_length': 5,          // Continuation length
  'ssl3_type': 'HMA',        // Exit type
  'ssl3_length': 15,         // Exit length
  'atr_period': 14,          // ATR period
  'atr_mult': 1.0,           // ATR multiplier
  // ... other parameters
};
```

### 2. Supported Timeframes
Configure in `lib/config/app_config.dart`:
```dart
static const List<String> timeframes = ['1D', '4H', '1H', '15m', '5m'];
```

### 3. Default Instrument
```dart
static const String defaultInstrument = 'XAUUSD';
```

## Data Format

### CSV File Format
Your historical data CSV should have this format:

```csv
datetime,open,high,low,close,volume
2023-01-01 00:00:00,2050.50,2055.00,2048.00,2052.00,10000
2023-01-02 00:00:00,2052.00,2060.00,2051.00,2058.00,12000
...
```

**Required Columns:**
- `datetime`: YYYY-MM-DD HH:MM:SS or ISO 8601 format
- `open`: Opening price
- `high`: Highest price
- `low`: Lowest price
- `close`: Closing price
- `volume`: Trade volume (optional for some indicators)

## Troubleshooting

### 1. "Flutter command not found"
```bash
# Add Flutter to PATH
# Linux/macOS:
export PATH="$PATH:`pwd`/flutter/bin"

# Windows:
# Add flutter/bin directory to System Environment Variables
```

### 2. "Android SDK not found"
```bash
# Set ANDROID_SDK_ROOT
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk  # macOS
export ANDROID_SDK_ROOT=$HOME/Android/Sdk           # Linux
set ANDROID_SDK_ROOT=%USERPROFILE%\AppData\Local\Android\Sdk  # Windows
```

### 3. Device not recognized
```bash
adb kill-server
adb start-server
adb devices
```

### 4. Gradle sync errors
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
flutter run
```

### 5. "Waiting for another flutter command to release the startup lock"
```bash
kill -9 $(lsof -t ~/.gradle/daemon)  # macOS/Linux
# Then try again
```

## Features Guide

### Data Upload Screen
1. Select instrument (XAUUSD, EURUSD, etc.)
2. Select timeframe (1D, 4H, etc.)
3. Upload CSV file
4. Click "Load Data"

### Strategy Screen
1. Adjust SSL1/SSL2/SSL3 parameters
2. Set ATR period and multiplier
3. Click "Reset to Defaults" to restore original settings

### Results Screen
1. Run backtest on uploaded data
2. View performance metrics (Win Rate, Profit Factor, etc.)
3. View detailed trade list
4. Export results to CSV

## Performance Optimization

### For Large Datasets (>10,000 candles)
- Use Release build mode for faster processing
- Consider downsampling data (every 4th candle)
- Reduce number of indicators calculated

### Memory Management
- Close other apps before running backtest
- Clear cache: `flutter clean && flutter pub get`

## Getting Sample Data

### Option 1: TradingView
1. Go to TradingView.com
2. Select XAUUSD chart
3. Set timeframe to Daily or 4H
4. Use browser developer tools to export data

### Option 2: Online Data Sources
- **Alpha Vantage**: https://www.alphavantage.co/
- **Yahoo Finance**: https://finance.yahoo.com/
- **FXCM**: https://www.fxcm.com/

### Option 3: Generate Sample Data
- App includes sample data generator
- Data → Load Sample Data button

## Support & Documentation

- **Flutter Docs**: https://flutter.dev/docs
- **Dart Docs**: https://dart.dev/guides
- **Issue Tracker**: GitHub Issues
- **Discussions**: GitHub Discussions

## Next Steps

1. **Customize Strategy Parameters**
   - Adjust SSL lengths and types
   - Optimize for your trading style

2. **Load Your Data**
   - Export XAUUSD data from your broker
   - Import into app
   - Run backtest

3. **Analyze Results**
   - Review performance metrics
   - Check trade list for patterns
   - Export for further analysis

4. **Deploy to Device**
   - Build APK for sharing
   - Deploy to Google Play Store

---

**Version**: 1.0.0  
**Last Updated**: 2024  
**License**: MIT
