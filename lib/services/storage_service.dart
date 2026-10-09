import 'package:hive_flutter/hive_flutter.dart';
import '../models/strategy_model.dart';
import '../models/backtest_result.dart';

class StorageService {
  static final Box _settingsBox = Hive.box('settings');
  static final Box _backtestsBox = Hive.box('backtests');
  
  // Strategy Settings
  static Future<void> saveStrategySettings(String key, Map<String, dynamic> settings) async {
    await _settingsBox.put(key, settings);
  }
  
  static Map<String, dynamic>? getStrategySettings(String key) {
    return _settingsBox.get(key) as Map<String, dynamic>?;
  }
  
  static Future<void> deleteStrategySettings(String key) async {
    await _settingsBox.delete(key);
  }
  
  static List<String> getAllStrategyKeys() {
    return _settingsBox.keys.cast<String>().toList();
  }
  
  // Backtest Results
  static Future<void> saveBacktestResult(String key, Map<String, dynamic> result) async {
    await _backtestsBox.put(key, result);
  }
  
  static Map<String, dynamic>? getBacktestResult(String key) {
    return _backtestsBox.get(key) as Map<String, dynamic>?;
  }
  
  static List<String> getAllBacktestKeys() {
    return _backtestsBox.keys.cast<String>().toList();
  }
  
  static Future<void> deleteBacktestResult(String key) async {
    await _backtestsBox.delete(key);
  }
  
  static Future<void> clearAllData() async {
    await _settingsBox.clear();
    await _backtestsBox.clear();
  }
}
