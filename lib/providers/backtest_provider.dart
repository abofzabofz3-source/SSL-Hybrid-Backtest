import 'package:flutter/foundation.dart';
import '../models/backtest_result.dart';

class BacktestProvider extends ChangeNotifier {
  BacktestResult? _currentResult;
  List<BacktestResult> _history = [];
  bool _isLoading = false;
  String? _error;
  
  BacktestResult? get currentResult => _currentResult;
  List<BacktestResult> get history => _history;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> runBacktest(String strategyId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // TODO: Implement actual backtest logic
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock result for now
      _currentResult = BacktestResult(
        id: 'mock_result_001',
        strategyId: strategyId,
        backtestDate: DateTime.now(),
        totalTrades: 45,
        winningTrades: 32,
        losingTrades: 13,
        winRate: 71.1,
        profitFactor: 2.5,
        totalProfit: 1250.50,
        maxDrawdown: 8.5,
        sharpeRatio: 1.8,
        returnOnRisk: 3.2,
        averageTradeDuration: 12.5,
        trades: [],
        equityCurve: [],
      );
      
      if (_currentResult != null) {
        _history.add(_currentResult!);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
  
  void clearHistory() {
    _history.clear();
    notifyListeners();
  }
}
