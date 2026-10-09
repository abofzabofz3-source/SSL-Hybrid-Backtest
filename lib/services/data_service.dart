import '../models/candle_model.dart';

class DataService {
  // Generate sample XAUUSD data for testing
  static List<Candle> generateSampleXAUUSDData({int days = 100}) {
    List<Candle> candles = [];
    DateTime now = DateTime.now();
    double price = 2050.0;
    
    for (int i = -days; i <= 0; i++) {
      DateTime date = now.add(Duration(days: i));
      
      // Generate realistic candlestick data
      double dailyChange = (DateTime.now().millisecond % 10 - 5) * 0.5;
      double open = price;
      double close = price + dailyChange;
      double high = max(open, close) + (DateTime.now().microsecond % 5) * 0.1;
      double low = min(open, close) - (DateTime.now().microsecond % 5) * 0.1;
      
      candles.add(Candle(
        timestamp: date,
        open: open,
        high: high,
        low: low,
        close: close,
        volume: 10000 + DateTime.now().microsecond % 5000,
      ));
      
      price = close;
    }
    
    return candles;
  }
  
  // Convert daily data to 4H data
  static List<Candle> convertTo4Hourly(List<Candle> dailyCandles) {
    List<Candle> hourlyCandles = [];
    
    for (var daily in dailyCandles) {
      for (int i = 0; i < 6; i++) {
        DateTime time = daily.timestamp.add(Duration(hours: i * 4));
        double variation = (i - 2.5) * 0.2; // Add variation across the day
        
        hourlyCandles.add(Candle(
          timestamp: time,
          open: daily.open + variation,
          high: daily.high + variation,
          low: daily.low + variation,
          close: daily.close + variation,
          volume: (daily.volume / 6).toInt(),
        ));
      }
    }
    
    return hourlyCandles;
  }
}

double max(double a, double b) => a > b ? a : b;
double min(double a, double b) => a < b ? a : b;
