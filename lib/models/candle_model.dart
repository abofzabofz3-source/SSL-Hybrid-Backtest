class Candle {
  final DateTime timestamp;
  final double open;
  final double high;
  final double low;
  final double close;
  final int volume;
  
  Candle({
    required this.timestamp,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });
  
  double get bodySize => (close - open).abs();
  double get highLowRange => high - low;
  bool get isBullish => close > open;
  bool get isBearish => close < open;
  
  factory Candle.fromJson(Map<String, dynamic> json) {
    return Candle(
      timestamp: DateTime.parse(json['datetime']),
      open: double.parse(json['open'].toString()),
      high: double.parse(json['high'].toString()),
      low: double.parse(json['low'].toString()),
      close: double.parse(json['close'].toString()),
      volume: int.parse(json['volume'].toString()),
    );
  }
  
  Map<String, dynamic> toJson() => {
    'datetime': timestamp.toIso8601String(),
    'open': open,
    'high': high,
    'low': low,
    'close': close,
    'volume': volume,
  };
}
