import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import '../models/strategy_model.dart';

class StrategyProvider extends ChangeNotifier {
  late StrategyModel _currentStrategy;
  List<StrategyModel> _strategies = [];
  
  StrategyProvider() {
    _initializeDefaultStrategy();
  }
  
  void _initializeDefaultStrategy() {
    _currentStrategy = StrategyModel(
      id: 'default_ssl_hybrid',
      name: 'SSL Hybrid Default',
      instrument: AppConfig.defaultInstrument,
      timeframe: AppConfig.defaultTimeframe,
      parameters: AppConfig.defaultStrategyParams,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
  
  StrategyModel get currentStrategy => _currentStrategy;
  List<StrategyModel> get strategies => _strategies;
  
  void updateStrategyParameter(String key, dynamic value) {
    final updatedParams = Map<String, dynamic>.from(_currentStrategy.parameters);
    updatedParams[key] = value;
    
    _currentStrategy = _currentStrategy.copyWith(
      parameters: updatedParams,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }
  
  void updateStrategy(StrategyModel strategy) {
    _currentStrategy = strategy.copyWith(updatedAt: DateTime.now());
    notifyListeners();
  }
  
  void addStrategy(StrategyModel strategy) {
    _strategies.add(strategy);
    notifyListeners();
  }
  
  void removeStrategy(String strategyId) {
    _strategies.removeWhere((s) => s.id == strategyId);
    notifyListeners();
  }
  
  void resetToDefaults() {
    _initializeDefaultStrategy();
    notifyListeners();
  }
}
