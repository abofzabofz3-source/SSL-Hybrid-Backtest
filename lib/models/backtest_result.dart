class BacktestResult {
  final String id;
  final String strategyId;
  final DateTime backtestDate;
  final int totalTrades;
  final int winningTrades;
  final int losingTrades;
  final double winRate;
  final double profitFactor;
  final double totalProfit;
  final double maxDrawdown;
  final double sharpeRatio;
  final double returnOnRisk;
  final double averageTradeDuration;
  final List<Trade> trades;
  final List<EquityPoint> equityCurve;
  
  BacktestResult({
    required this.id,
    required this.strategyId,
    required this.backtestDate,
    required this.totalTrades,
    required this.winningTrades,
    required this.losingTrades,
    required this.winRate,
    required this.profitFactor,
    required this.totalProfit,
    required this.maxDrawdown,
    required this.sharpeRatio,
    required this.returnOnRisk,
    required this.averageTradeDuration,
    required this.trades,
    required this.equityCurve,
  });
}

class Trade {
  final int index;
  final DateTime entryTime;
  final double entryPrice;
  final String entrySignal;
  final DateTime? exitTime;
  final double? exitPrice;
  final String? exitSignal;
  final double? profitLoss;
  final double? profitLossPercent;
  final bool isWinning;
  
  Trade({
    required this.index,
    required this.entryTime,
    required this.entryPrice,
    required this.entrySignal,
    this.exitTime,
    this.exitPrice,
    this.exitSignal,
    this.profitLoss,
    this.profitLossPercent,
    required this.isWinning,
  });
}

class EquityPoint {
  final DateTime timestamp;
  final double equity;
  final double cumProfit;
  
  EquityPoint({
    required this.timestamp,
    required this.equity,
    required this.cumProfit,
  });
}
