import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/backtest_provider.dart';
import '../config/app_config.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({Key? key}) : super(key: key);

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BacktestProvider>(
      builder: (context, backtestProvider, child) {
        final result = backtestProvider.currentResult;
        
        if (result == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bar_chart,
                  size: 64,
                  color: const Color(0xFF00C3FF).withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No backtest results yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF78909C),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Upload data and run a backtest to see results',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF78909C),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    backtestProvider.runBacktest('default_ssl_hybrid');
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Run Backtest'),
                ),
              ],
            ),
          );
        }
        
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
              const SizedBox(height: 20),
              // Performance Metrics
              _buildMetricsGrid(result),
              const SizedBox(height: 20),
              // Trade Statistics
              _buildTradeStats(result),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Export results
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Export Results'),
                ),
              ),
            ],
          ),
        );
      },
    );
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
              fontSize: 20,
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
            'Trade Statistics',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatRow(
            'Total Trades',
            result.totalTrades.toString(),
          ),
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
            'Sharpe Ratio',
            result.sharpeRatio.toStringAsFixed(2),
          ),
          _buildStatRow(
            'Return on Risk',
            result.returnOnRisk.toStringAsFixed(2),
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
