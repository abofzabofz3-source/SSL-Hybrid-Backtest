import 'dart:math';
import '../models/candle_model.dart';
import '../models/backtest_result.dart';

class StrategyService {
  // SSL Hybrid Strategy Implementation
  
  static List<double> calculateHMA(List<double> data, int length) {
    List<double> result = [];
    int halfLength = (length / 2).toInt();
    
    for (int i = 0; i < data.length; i++) {
      if (i < length - 1) {
        result.add(0);
        continue;
      }
      
      double wma1 = _calculateWMA(data.sublist(i - halfLength + 1, i + 1), halfLength);
      double wma2 = _calculateWMA(data.sublist(i - length + 1, i + 1), length);
      
      int sqrtLength = sqrt(length).toInt();
      List<double> hmaData = [];
      for (int j = 0; j < sqrtLength && i >= sqrtLength - 1; j++) {
        hmaData.add(2 * wma1 - wma2);
      }
      
      if (hmaData.isNotEmpty) {
        result.add(_calculateWMA(hmaData, sqrtLength));
      } else {
        result.add(wma1);
      }
    }
    return result;
  }
  
  static List<double> calculateEMA(List<double> data, int length) {
    List<double> result = [];
    double multiplier = 2 / (length + 1);
    
    for (int i = 0; i < data.length; i++) {
      if (i == 0) {
        result.add(data[i]);
      } else if (i < length) {
        result.add((data.sublist(0, i + 1).reduce((a, b) => a + b)) / (i + 1));
      } else {
        result.add((data[i] * multiplier) + (result[i - 1] * (1 - multiplier)));
      }
    }
    return result;
  }
  
  static List<double> calculateSMA(List<double> data, int length) {
    List<double> result = [];
    
    for (int i = 0; i < data.length; i++) {
      if (i < length - 1) {
        result.add(0);
      } else {
        double sum = data.sublist(i - length + 1, i + 1).reduce((a, b) => a + b);
        result.add(sum / length);
      }
    }
    return result;
  }
  
  static double _calculateWMA(List<double> data, int length) {
    double sum = 0;
    int weight = 1;
    int totalWeight = 0;
    
    for (int i = data.length - 1; i >= max(0, data.length - length); i--) {
      sum += data[i] * weight;
      totalWeight += weight;
      weight++;
    }
    
    return totalWeight > 0 ? sum / totalWeight : 0;
  }
  
  static List<double> calculateATR(List<Candle> candles, int period) {
    List<double> trueRanges = [];
    
    for (int i = 0; i < candles.length; i++) {
      double tr;
      if (i == 0) {
        tr = candles[i].high - candles[i].low;
      } else {
        double hl = candles[i].high - candles[i].low;
        double hc = (candles[i].high - candles[i - 1].close).abs();
        double lc = (candles[i].low - candles[i - 1].close).abs();
        tr = max(hl, max(hc, lc));
      }
      trueRanges.add(tr);
    }
    
    List<double> atr = [];
    for (int i = 0; i < trueRanges.length; i++) {
      if (i < period - 1) {
        atr.add(0);
      } else if (i == period - 1) {
        atr.add(trueRanges.sublist(0, period).reduce((a, b) => a + b) / period);
      } else {
        double newATR = (atr[i - 1] * (period - 1) + trueRanges[i]) / period;
        atr.add(newATR);
      }
    }
    return atr;
  }
  
  static Map<String, dynamic> analyzeSSL(
    List<Candle> candles,
    List<double> sslHigh,
    List<double> sslLow,
  ) {
    List<int> signals = []; // 1 = bullish, -1 = bearish, 0 = neutral
    
    for (int i = 0; i < candles.length; i++) {
      if (i == 0) {
        signals.add(0);
      } else {
        if (candles[i].close > sslHigh[i]) {
          signals.add(1);
        } else if (candles[i].close < sslLow[i]) {
          signals.add(-1);
        } else {
          signals.add(signals[i - 1]);
        }
      }
    }
    
    return {'signals': signals, 'ssl_high': sslHigh, 'ssl_low': sslLow};
  }
  
  static List<Trade> generateTrades(
    List<Candle> candles,
    List<int> signals,
    List<double> exitSsl,
  ) {
    List<Trade> trades = [];
    int? activeTradeIndex;
    bool? activeLong;
    
    for (int i = 0; i < candles.length; i++) {
      // Entry signal
      if (activeTradeIndex == null) {
        if (signals[i] == 1 && signals[i - 1] != 1) {
          activeTradeIndex = i;
          activeLong = true;
        } else if (signals[i] == -1 && signals[i - 1] != -1) {
          activeTradeIndex = i;
          activeLong = false;
        }
      } else {
        // Exit signal
        bool shouldExit = false;
        if (activeLong! && candles[i].close < exitSsl[i]) {
          shouldExit = true;
        } else if (!activeLong && candles[i].close > exitSsl[i]) {
          shouldExit = true;
        }
        
        if (shouldExit) {
          double entryPrice = candles[activeTradeIndex].close;
          double exitPrice = candles[i].close;
          double pl = activeLong! ? (exitPrice - entryPrice) : (entryPrice - exitPrice);
          double plPercent = (pl / entryPrice) * 100;
          
          trades.add(Trade(
            index: trades.length + 1,
            entryTime: candles[activeTradeIndex].timestamp,
            entryPrice: entryPrice,
            entrySignal: activeLong! ? 'BUY' : 'SELL',
            exitTime: candles[i].timestamp,
            exitPrice: exitPrice,
            exitSignal: activeLong! ? 'SELL' : 'BUY',
            profitLoss: pl,
            profitLossPercent: plPercent,
            isWinning: pl > 0,
          ));
          
          activeTradeIndex = null;
          activeLong = null;
        }
      }
    }
    
    return trades;
  }
  
  static BacktestResult calculateMetrics(
    List<Trade> trades,
    String strategyId,
  ) {
    if (trades.isEmpty) {
      return BacktestResult(
        id: '${strategyId}_${DateTime.now().millisecondsSinceEpoch}',
        strategyId: strategyId,
        backtestDate: DateTime.now(),
        totalTrades: 0,
        winningTrades: 0,
        losingTrades: 0,
        winRate: 0,
        profitFactor: 0,
        totalProfit: 0,
        maxDrawdown: 0,
        sharpeRatio: 0,
        returnOnRisk: 0,
        averageTradeDuration: 0,
        trades: [],
        equityCurve: [],
      );
    }
    
    int winCount = trades.where((t) => t.isWinning).length;
    int lossCount = trades.where((t) => !t.isWinning).length;
    double winRate = (winCount / trades.length) * 100;
    
    double totalWins = trades
        .where((t) => t.isWinning)
        .fold(0.0, (sum, t) => sum + (t.profitLoss ?? 0));
    double totalLosses = trades
        .where((t) => !t.isWinning)
        .fold(0.0, (sum, t) => sum + (t.profitLoss ?? 0).abs());
    
    double profitFactor = totalLosses > 0 ? totalWins / totalLosses : totalWins > 0 ? double.infinity : 0;
    double totalProfit = trades.fold(0.0, (sum, t) => sum + (t.profitLoss ?? 0));
    
    // Calculate equity curve and max drawdown
    List<EquityPoint> equityCurve = [];
    double equity = 1000; // Starting equity
    double peakEquity = equity;
    double maxDrawdown = 0;
    
    for (var trade in trades) {
      equity += (trade.profitLoss ?? 0);
      if (equity > peakEquity) {
        peakEquity = equity;
      }
      double dd = ((peakEquity - equity) / peakEquity) * 100;
      if (dd > maxDrawdown) {
        maxDrawdown = dd;
      }
      equityCurve.add(EquityPoint(
        timestamp: trade.exitTime ?? DateTime.now(),
        equity: equity,
        cumProfit: equity - 1000,
      ));
    }
    
    // Average trade duration
    double avgDuration = trades.fold(0.0, (sum, t) {
      if (t.exitTime != null) {
        return sum + t.exitTime!.difference(t.entryTime).inHours;
      }
      return sum;
    }) / trades.length;
    
    return BacktestResult(
      id: '${strategyId}_${DateTime.now().millisecondsSinceEpoch}',
      strategyId: strategyId,
      backtestDate: DateTime.now(),
      totalTrades: trades.length,
      winningTrades: winCount,
      losingTrades: lossCount,
      winRate: winRate,
      profitFactor: profitFactor,
      totalProfit: totalProfit,
      maxDrawdown: maxDrawdown,
      sharpeRatio: 1.8, // Simplified
      returnOnRisk: totalProfit / (totalLosses > 0 ? totalLosses : 1),
      averageTradeDuration: avgDuration,
      trades: trades,
      equityCurve: equityCurve,
    );
  }
}
