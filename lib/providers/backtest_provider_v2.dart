import 'package:flutter/foundation.dart';
import '../models/backtest_result.dart';
import '../models/candle_model.dart';
import '../services/backtest_engine.dart';

class BacktestProvider extends ChangeNotifier {
  BacktestResult? _currentResult;
  List<BacktestResult> _history = [];
  bool _isLoading = false;
  String? _error;
  
  BacktestResult? get currentResult => _currentResult;
  List<BacktestResult> get history => _history;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> runBacktestWithData(
    List<Candle> candles,
    Map<String, dynamic> parameters,
    String strategyId,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // Run actual backtest engine
      _currentResult = await BacktestEngine.runBacktest(
        candles,
        parameters,
        strategyId,
      );
      
      if (_currentResult != null) {
        _history.add(_currentResult!);
      }
    } catch (e) {
      _error = e.toString();
      print('Backtest error: $_error');
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
    _currentResult = null;
    _history.clear();
    notifyListeners();
  }
}
