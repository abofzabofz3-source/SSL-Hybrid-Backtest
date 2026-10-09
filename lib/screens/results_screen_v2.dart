import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/backtest_provider.dart';
import '../providers/strategy_provider.dart';
import '../services/backtest_engine.dart';
import '../services/xauusd_data_loader.dart';
import '../config/app_config.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({Key? key}) : super(key: key);

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  String _selectedTimeframe = '1D';

  @override
  Widget build(BuildContext context) {
    return Consumer2<BacktestProvider, StrategyProvider>(
      builder: (context, backtestProvider, strategyProvider, child) {
        final result = backtestProvider.currentResult;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Backtest Results',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Timeframe Selection
              Wrap(
                spacing: 8,
                children: ['1D', '4H'].map((tf) {
                  return FilterChip(
                    label: Text(tf),
                    selected: _selectedTimeframe == tf,
                    onSelected: (selected) {
                      setState(() {
                        _selectedTimeframe = tf;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              // Run Backtest Button
              if (result == null || backtestProvider.isLoading)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: backtestProvider.isLoading
                        ? null
                        : () => _runBacktest(backtestProvider, strategyProvider),
                    icon: backtestProvider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.play_arrow),
                    label: Text(
                      backtestProvider.isLoading ? 'Running...' : 'Run Backtest',
                    ),
                  ),
                ),
              if (result != null && !backtestProvider.isLoading) ...[{
                _buildMetricsGrid(result),
                const SizedBox(height: 20),
                _buildTradeStats(result),
                const SizedBox(height: 20),
                _buildTradeList(result),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Results exported successfully'),
                              backgroundColor: Color(0xFF81C784),
                            ),
                          );
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Export CSV'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          backtestProvider.clearHistory();
                          setState(() {});
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('New Backtest'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF0062),
                        ),
                      ),
                    ),
                  ],
                ),
              }],
            ],
          ),
        );
      },
    );
  }

  Future<void> _runBacktest(
    BacktestProvider backtestProvider,
    StrategyProvider strategyProvider,
  ) async {
    try {
      // Load data based on selected timeframe
      final candles = _selectedTimeframe == '1D'
          ? XAUUSDDataLoader.getXAUUSDDailyData()
          : XAUUSDDataLoader.getXAUUSD4HourlyData();

      if (candles.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No data available'),
            backgroundColor: Color(0xFFE53935),
          ),
        );
        return;
      }

      // Run backtest
      await backtestProvider.runBacktestWithData(
        candles,
        strategyProvider.currentStrategy.parameters,
        strategyProvider.currentStrategy.id,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Backtest completed successfully'),
          backgroundColor: Color(0xFF81C784),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: const Color(0xFFE53935),
        ),
      );
    }
  }

  Widget _buildMetricsGrid(dynamic result) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildMetricCard(
          'Win Rate',
          '${result.winRate.toStringAsFixed(1)}%',
          const Color(0xFF81C784),
        ),
        _buildMetricCard(
          'Profit Factor',
          result.profitFactor.toStringAsFixed(2),
          const Color(0xFF00C3FF),
        ),
        _buildMetricCard(
          'Total Profit',
          '\$${result.totalProfit.toStringAsFixed(2)}',
          const Color(0xFFFFD700),
        ),
        _buildMetricCard(
          'Max Drawdown',
          '${result.maxDrawdown.toStringAsFixed(1)}%',
          const Color(0xFFE53935),
        ),
        _buildMetricCard(
          'Sharpe Ratio',
          result.sharpeRatio.toStringAsFixed(2),
          const Color(0xFF00C3FF),
        ),
        _buildMetricCard(
          'Return/Risk',
          result.returnOnRisk.toStringAsFixed(2),
          const Color(0xFFFFD700),
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF1A1A1A),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF78909C),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradeStats(dynamic result) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF1A1A1A),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trade Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatRow('Total Trades', result.totalTrades.toString()),
          _buildStatRow(
            'Winning Trades',
            '${result.winningTrades} ✓',
            color: const Color(0xFF81C784),
          ),
          _buildStatRow(
            'Losing Trades',
            '${result.losingTrades} ✗',
            color: const Color(0xFFE53935),
          ),
          _buildStatRow(
            'Avg Trade Duration',
            '${result.averageTradeDuration.toStringAsFixed(1)} hours',
          ),
        ],
      ),
    );
  }

  Widget _buildTradeList(dynamic result) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF1A1A1A),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trade Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: result.trades.length > 10 ? 10 : result.trades.length,
            itemBuilder: (context, index) {
              final trade = result.trades[index];
              return _buildTradeRow(trade);
            },
          ),
          if (result.trades.length > 10)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                '+${result.trades.length - 10} more trades',
                style: const TextStyle(
                  color: Color(0xFF78909C),
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTradeRow(dynamic trade) {
    final bgColor = trade.isWinning
        ? const Color(0xFF81C784).withOpacity(0.1)
        : const Color(0xFFE53935).withOpacity(0.1);
    final borderColor =
        trade.isWinning ? const Color(0xFF81C784) : const Color(0xFFE53935);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${trade.entrySignal}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              Text(
                '${trade.profitLoss?.toStringAsFixed(2) ?? '0'} USD',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: trade.isWinning
                      ? const Color(0xFF81C784)
                      : const Color(0xFFE53935),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Entry: ${trade.entryPrice.toStringAsFixed(2)} | Exit: ${trade.exitPrice?.toStringAsFixed(2) ?? 'OPEN'}',
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF78909C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(
    String label,
    String value, {
    Color color = const Color(0xFF00C3FF),
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFFB0BEC5),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
