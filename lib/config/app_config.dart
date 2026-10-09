class AppConfig {
  // App Information
  static const String appName = 'SSL Hybrid Backtester';
  static const String appVersion = '1.0.0';
  static const String appAuthor = 'Mihkel00 & Contributors';
  
  // Supported Timeframes
  static const List<String> timeframes = ['1D', '4H', '1H', '15m', '5m'];
  static const String defaultTimeframe = '1D';
  
  // Default Strategy Parameters
  static const Map<String, dynamic> defaultStrategyParams = {
    'ssl1_type': 'HMA',
    'ssl1_length': 60,
    'ssl2_type': 'JMA',
    'ssl2_length': 5,
    'ssl3_type': 'HMA',
    'ssl3_length': 15,
    'atr_period': 14,
    'atr_mult': 1.0,
    'atr_smoothing': 'WMA',
    'keltner_mult': 0.2,
    'atr_criteria': 0.9,
  };
  
  // Moving Average Types
  static const List<String> maTypes = [
    'SMA', 'EMA', 'DEMA', 'TEMA', 'LSMA', 'WMA', 
    'MF', 'VAMA', 'TMA', 'HMA', 'JMA', 'Kijun v2', 
    'EDSMA', 'McGinley'
  ];
  
  // Supported Instruments
  static const List<String> instruments = [
    'XAUUSD', 'EURUSD', 'GBPUSD', 'USDJPY', 'AUDUSD'
  ];
  static const String defaultInstrument = 'XAUUSD';
  
  // CSV Format
  static const List<String> csvHeaders = ['datetime', 'open', 'high', 'low', 'close', 'volume'];
  
  // API Configuration (for future backend)
  static const String backendUrl = 'http://localhost:8000';
  static const Duration apiTimeout = Duration(seconds: 30);
}
