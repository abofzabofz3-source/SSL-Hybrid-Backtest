import 'dart:math';
import '../models/candle_model.dart';
import '../models/backtest_result.dart';

class BacktestEngine {
  // Main backtest execution
  static Future<BacktestResult> runBacktest(
    List<Candle> candles,
    Map<String, dynamic> parameters,
    String strategyId,
  ) async {
    if (candles.length < 100) {
      throw Exception('Minimum 100 candles required for backtest');
    }

    try {
      // Extract parameters
      final ssl1Type = parameters['ssl1_type'] ?? 'HMA';
      final ssl1Length = parameters['ssl1_length'] ?? 60;
      final ssl2Type = parameters['ssl2_type'] ?? 'JMA';
      final ssl2Length = parameters['ssl2_length'] ?? 5;
      final ssl3Type = parameters['ssl3_type'] ?? 'HMA';
      final ssl3Length = parameters['ssl3_length'] ?? 15;
      final atrPeriod = parameters['atr_period'] ?? 14;
      final atrMult = parameters['atr_mult'] ?? 1.0;

      // Calculate indicators
      final ssl1High = _calculateMA(ssl1Type, _getHighs(candles), ssl1Length);
      final ssl1Low = _calculateMA(ssl1Type, _getLows(candles), ssl1Length);
      final ssl2High = _calculateMA(ssl2Type, _getHighs(candles), ssl2Length);
      final ssl2Low = _calculateMA(ssl2Type, _getLows(candles), ssl2Length);
      final ssl3High = _calculateMA(ssl3Type, _getHighs(candles), ssl3Length);
      final ssl3Low = _calculateMA(ssl3Type, _getLows(candles), ssl3Length);
      final atrValues = _calculateATR(candles, atrPeriod);
      final closes = _getCloses(candles);

      // Generate signals
      List<int> ssl1Signals = [];
      List<int> ssl2Signals = [];
      List<int> exitSignals = [];

      for (int i = 0; i < candles.length; i++) {
        double close = closes[i];
        double h1 = ssl1High[i];
        double l1 = ssl1Low[i];
        double h2 = ssl2High[i];
        double l2 = ssl2Low[i];
        double h3 = ssl3High[i];
        double l3 = ssl3Low[i];

        // SSL1 signals
        if (i == 0) {
          ssl1Signals.add(0);
          ssl2Signals.add(0);
          exitSignals.add(0);
        } else {
          // SSL1: 1 = bullish, -1 = bearish
          if (close > h1) {
            ssl1Signals.add(1);
          } else if (close < l1) {
            ssl1Signals.add(-1);
          } else {
            ssl1Signals.add(ssl1Signals[i - 1]);
          }

          // SSL2: Confirmation
          if (close > h2) {
            ssl2Signals.add(1);
          } else if (close < l2) {
            ssl2Signals.add(-1);
          } else {
            ssl2Signals.add(ssl2Signals[i - 1]);
          }

          // SSL3: Exit
          if (close > h3) {
            exitSignals.add(1);
          } else if (close < l3) {
            exitSignals.add(-1);
          } else {
            exitSignals.add(exitSignals[i - 1]);
          }
        }
      }

      // Generate trades
      final trades = _generateTrades(candles, ssl1Signals, ssl2Signals, exitSignals);

      // Calculate metrics
      return _calculateMetrics(trades, candles, strategyId);
    } catch (e) {
      print('Error in backtest engine: $e');
      rethrow;
    }
  }

  static List<double> _calculateMA(String type, List<double> data, int length) {
    switch (type) {
      case 'SMA':
        return _calculateSMA(data, length);
      case 'EMA':
        return _calculateEMA(data, length);
      case 'HMA':
        return _calculateHMA(data, length);
      case 'DEMA':
        return _calculateDEMA(data, length);
      case 'WMA':
        return _calculateWMA(data, length);
      default:
        return _calculateHMA(data, length);
    }
  }

  static List<double> _calculateSMA(List<double> data, int length) {
    List<double> result = [];
    for (int i = 0; i < data.length; i++) {
      if (i < length - 1) {
        result.add(data[i]);
      } else {
        double sum = data.sublist(i - length + 1, i + 1).reduce((a, b) => a + b);
        result.add(sum / length);
      }
    }
    return result;
  }

  static List<double> _calculateEMA(List<double> data, int length) {
    List<double> result = [];
    double multiplier = 2 / (length + 1);

    for (int i = 0; i < data.length; i++) {
      if (i == 0) {
        result.add(data[i]);
      } else if (i < length) {
        double sum = data.sublist(0, i + 1).reduce((a, b) => a + b);
        result.add(sum / (i + 1));
      } else {
        double ema = (data[i] * multiplier) + (result[i - 1] * (1 - multiplier));
        result.add(ema);
      }
    }
    return result;
  }

  static List<double> _calculateWMA(List<double> data, int length) {
    List<double> result = [];
    for (int i = 0; i < data.length; i++) {
      if (i < length - 1) {
        result.add(data[i]);
      } else {
        double sum = 0;
        int weight = 1;
        int totalWeight = 0;
        for (int j = i - length + 1; j <= i; j++) {
          sum += data[j] * weight;
          totalWeight += weight;
          weight++;
        }
        result.add(sum / totalWeight);
      }
    }
    return result;
  }

  static List<double> _calculateHMA(List<double> data, int length) {
    int halfLen = (length / 2).toInt();
    int sqrtLen = sqrt(length).toInt();

    // First WMA
    List<double> wma1 = [];
    for (int i = 0; i < data.length; i++) {
      if (i < halfLen - 1) {
        wma1.add(data[i]);
      } else {
        double sum = 0;
        int weight = 1;
        int totalWeight = 0;
        for (int j = i - halfLen + 1; j <= i; j++) {
          sum += data[j] * weight;
          totalWeight += weight;
          weight++;
        }
        wma1.add(sum / totalWeight);
      }
    }

    // Second WMA
    List<double> wma2 = [];
    for (int i = 0; i < data.length; i++) {
      if (i < length - 1) {
        wma2.add(data[i]);
      } else {
        double sum = 0;
        int weight = 1;
        int totalWeight = 0;
        for (int j = i - length + 1; j <= i; j++) {
          sum += data[j] * weight;
          totalWeight += weight;
          weight++;
        }
        wma2.add(sum / totalWeight);
      }
    }

    // Raw HMA
    List<double> rawHma = [];
    for (int i = 0; i < data.length; i++) {
      rawHma.add((2 * wma1[i]) - wma2[i]);
    }

    // Final WMA of HMA
    List<double> result = [];
    for (int i = 0; i < rawHma.length; i++) {
      if (i < sqrtLen - 1) {
        result.add(rawHma[i]);
      } else {
        double sum = 0;
        int weight = 1;
        int totalWeight = 0;
        for (int j = i - sqrtLen + 1; j <= i; j++) {
          sum += rawHma[j] * weight;
          totalWeight += weight;
          weight++;
        }
        result.add(sum / totalWeight);
      }
    }

    return result;
  }

  static List<double> _calculateDEMA(List<double> data, int length) {
    List<double> ema1 = _calculateEMA(data, length);
    List<double> ema2 = _calculateEMA(ema1, length);

    List<double> result = [];
    for (int i = 0; i < data.length; i++) {
      result.add((2 * ema1[i]) - ema2[i]);
    }
    return result;
  }

  static List<double> _calculateATR(List<Candle> candles, int period) {
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
        atr.add(trueRanges[i]);
      } else if (i == period - 1) {
        double sum = trueRanges.sublist(0, period).reduce((a, b) => a + b);
        atr.add(sum / period);
      } else {
        double newATR = (atr[i - 1] * (period - 1) + trueRanges[i]) / period;
        atr.add(newATR);
      }
    }
    return atr;
  }

  static List<Trade> _generateTrades(
    List<Candle> candles,
    List<int> ssl1Signals,
    List<int> ssl2Signals,
    List<int> exitSignals,
  ) {
    List<Trade> trades = [];
    int? entryIndex;
    bool? isLong;
    String? entrySignal;

    for (int i = 1; i < candles.length; i++) {
      // Entry Logic
      if (entryIndex == null) {
        bool bullishSignal = ssl1Signals[i] == 1 &&
            ssl1Signals[i - 1] != 1 &&
            ssl2Signals[i] == 1;
        bool bearishSignal = ssl1Signals[i] == -1 &&
            ssl1Signals[i - 1] != -1 &&
            ssl2Signals[i] == -1;

        if (bullishSignal) {
          entryIndex = i;
          isLong = true;
          entrySignal = 'Buy - SSL1/SSL2 Cross';
        } else if (bearishSignal) {
          entryIndex = i;
          isLong = false;
          entrySignal = 'Sell - SSL1/SSL2 Cross';
        }
      } else {
        // Exit Logic
        bool shouldExit = (isLong! && exitSignals[i] == -1) ||
            (!isLong! && exitSignals[i] == 1);

        if (shouldExit) {
          double entryPrice = candles[entryIndex!].close;
          double exitPrice = candles[i].close;
          double pl = isLong! ? (exitPrice - entryPrice) : (entryPrice - exitPrice);
          double plPercent = (pl / entryPrice) * 100;

          trades.add(Trade(
            index: trades.length + 1,
            entryTime: candles[entryIndex!].timestamp,
            entryPrice: entryPrice,
            entrySignal: entrySignal ?? '',
            exitTime: candles[i].timestamp,
            exitPrice: exitPrice,
            exitSignal: isLong! ? 'Sell - SSL3 Exit' : 'Buy - SSL3 Exit',
            profitLoss: pl,
            profitLossPercent: plPercent,
            isWinning: pl > 0,
          ));

          entryIndex = null;
          isLong = null;
          entrySignal = null;
        }
      }
    }

    return trades;
  }

  static BacktestResult _calculateMetrics(
    List<Trade> trades,
    List<Candle> candles,
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

    double profitFactor = totalLosses > 0 ? totalWins / totalLosses : double.infinity;
    double totalProfit = trades.fold(0.0, (sum, t) => sum + (t.profitLoss ?? 0));

    // Equity curve and max drawdown
    List<EquityPoint> equityCurve = [];
    double equity = 10000; // Starting equity
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
        cumProfit: equity - 10000,
      ));
    }

    // Average trade duration
    double avgDuration = trades.fold(0.0, (sum, t) {
      if (t.exitTime != null) {
        return sum + t.exitTime!.difference(t.entryTime).inHours.toDouble();
      }
      return sum;
    }) / max(trades.length, 1);

    // Sharpe Ratio (simplified)
    double sharpeRatio = 0;
    if (equityCurve.isNotEmpty && totalLosses > 0) {
      List<double> returns = [];
      for (int i = 1; i < equityCurve.length; i++) {
        returns.add((equityCurve[i].equity - equityCurve[i - 1].equity) /
            equityCurve[i - 1].equity);
      }
      if (returns.isNotEmpty) {
        double avgReturn =
            returns.reduce((a, b) => a + b) / returns.length;
        double variance = returns.fold(0.0, (sum, r) => sum + pow(r - avgReturn, 2)) /
            returns.length;
        double stdDev = sqrt(variance);
        sharpeRatio = stdDev > 0 ? avgReturn / stdDev : 0;
      }
    }

    return BacktestResult(
      id: '${strategyId}_${DateTime.now().millisecondsSinceEpoch}',
      strategyId: strategyId,
      backtestDate: DateTime.now(),
      totalTrades: trades.length,
      winningTrades: winCount,
      losingTrades: lossCount,
      winRate: winRate,
      profitFactor: profitFactor.isInfinite ? 999.99 : profitFactor,
      totalProfit: totalProfit,
      maxDrawdown: maxDrawdown,
      sharpeRatio: sharpeRatio,
      returnOnRisk:
          totalLosses > 0 ? (totalProfit / totalLosses) : double.infinity,
      averageTradeDuration: avgDuration,
      trades: trades,
      equityCurve: equityCurve,
    );
  }

  static List<double> _getHighs(List<Candle> candles) =>
      candles.map((c) => c.high).toList();

  static List<double> _getLows(List<Candle> candles) =>
      candles.map((c) => c.low).toList();

  static List<double> _getCloses(List<Candle> candles) =>
      candles.map((c) => c.close).toList();
}
