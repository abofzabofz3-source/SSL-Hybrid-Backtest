import 'dart:io';
import 'package:csv/csv.dart';
import '../models/candle_model.dart';

class CSVService {
  static Future<List<Candle>> loadCandlesFromCSV(String filePath) async {
    try {
      final file = File(filePath);
      final input = file.openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(CsvToListConverter())
          .toList();
      
      List<Candle> candles = [];
      
      // Skip header row
      for (int i = 1; i < fields.length; i++) {
        try {
          final row = fields[i];
          if (row.length >= 6) {
            candles.add(Candle(
              timestamp: DateTime.parse(row[0].toString()),
              open: double.parse(row[1].toString()),
              high: double.parse(row[2].toString()),
              low: double.parse(row[3].toString()),
              close: double.parse(row[4].toString()),
              volume: int.parse(row[5].toString()),
            ));
          }
        } catch (e) {
          print('Error parsing row $i: $e');
          continue;
        }
      }
      
      return candles;
    } catch (e) {
      print('Error loading CSV: $e');
      rethrow;
    }
  }
  
  static String generateCSVReport(
    List<dynamic> trades,
    Map<String, dynamic> metrics,
  ) {
    List<List<dynamic>> rows = [];
    
    // Header
    rows.add([
      'Trade #',
      'Entry Time',
      'Entry Price',
      'Entry Signal',
      'Exit Time',
      'Exit Price',
      'Exit Signal',
      'P&L',
      'P&L %',
      'Status',
    ]);
    
    // Trade data
    for (var trade in trades) {
      rows.add([
        trade.index,
        trade.entryTime.toString(),
        trade.entryPrice.toStringAsFixed(4),
        trade.entrySignal,
        trade.exitTime?.toString() ?? 'OPEN',
        trade.exitPrice?.toStringAsFixed(4) ?? '-',
        trade.exitSignal ?? '-',
        trade.profitLoss?.toStringAsFixed(2) ?? '-',
        trade.profitLossPercent?.toStringAsFixed(2) ?? '-',
        trade.isWinning ? 'WIN' : 'LOSS',
      ]);
    }
    
    // Metrics
    rows.add([]);
    rows.add(['SUMMARY METRICS']);
    rows.add(['Win Rate', '${metrics['winRate']}%']);
    rows.add(['Profit Factor', metrics['profitFactor']]);
    rows.add(['Total Profit', metrics['totalProfit']]);
    rows.add(['Max Drawdown', '${metrics['maxDrawdown']}%']);
    rows.add(['Sharpe Ratio', metrics['sharpeRatio']]);
    rows.add(['Total Trades', metrics['totalTrades']]);
    
    return const ListToCsvConverter().convert(rows);
  }
}
