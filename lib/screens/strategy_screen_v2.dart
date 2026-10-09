import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/strategy_provider.dart';
import '../config/app_config.dart';

class StrategyScreen extends StatefulWidget {
  const StrategyScreen({Key? key}) : super(key: key);

  @override
  State<StrategyScreen> createState() => _StrategyScreenState();
}

class _StrategyScreenState extends State<StrategyScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StrategyProvider>(
      builder: (context, strategyProvider, child) {
        final params = strategyProvider.currentStrategy.parameters;

        return SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Strategy Configuration',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Adjust SSL Hybrid NNFX parameters',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF78909C),
                ),
              ),
              const SizedBox(height: 24),
              // SSL1 Settings
              _buildSectionHeader(
                'SSL1 - Baseline (Primary Trend)',
                const Color(0xFF00C3FF),
              ),
              _buildDropdownSetting(
                'Moving Average Type',
                params['ssl1_type'],
                ['SMA', 'EMA', 'HMA', 'DEMA', 'WMA'],
                (value) =>
                    strategyProvider.updateStrategyParameter('ssl1_type', value),
              ),
              _buildSliderSetting(
                'Length',
                params['ssl1_length'].toDouble(),
                20,
                200,
                1,
                (value) =>
                    strategyProvider.updateStrategyParameter('ssl1_length', value.toInt()),
              ),
              const SizedBox(height: 24),
              // SSL2 Settings
              _buildSectionHeader(
                'SSL2 - Confirmation (Continuation Filter)',
                const Color(0xFFFF0062),
              ),
              _buildDropdownSetting(
                'Moving Average Type',
                params['ssl2_type'],
                ['SMA', 'EMA', 'HMA', 'DEMA', 'WMA'],
                (value) =>
                    strategyProvider.updateStrategyParameter('ssl2_type', value),
              ),
              _buildSliderSetting(
                'Length',
                params['ssl2_length'].toDouble(),
                2,
                50,
                1,
                (value) =>
                    strategyProvider.updateStrategyParameter('ssl2_length', value.toInt()),
              ),
              const SizedBox(height: 24),
              // SSL3 Settings
              _buildSectionHeader(
                'SSL3 - Exit Signal',
                const Color(0xFF81C784),
              ),
              _buildDropdownSetting(
                'Moving Average Type',
                params['ssl3_type'],
                ['SMA', 'EMA', 'HMA', 'DEMA', 'WMA'],
                (value) =>
                    strategyProvider.updateStrategyParameter('ssl3_type', value),
              ),
              _buildSliderSetting(
                'Length',
                params['ssl3_length'].toDouble(),
                5,
                100,
                1,
                (value) =>
                    strategyProvider.updateStrategyParameter('ssl3_length', value.toInt()),
              ),
              const SizedBox(height: 24),
              // ATR Settings
              _buildSectionHeader(
                'ATR - Volatility Measurement',
                const Color(0xFFFFD700),
              ),
              _buildSliderSetting(
                'ATR Period',
                params['atr_period'].toDouble(),
                5,
                50,
                1,
                (value) =>
                    strategyProvider.updateStrategyParameter('atr_period', value.toInt()),
              ),
              _buildSliderSetting(
                'ATR Multiplier',
                params['atr_mult'],
                0.1,
                3.0,
                0.1,
                (value) =>
                    strategyProvider.updateStrategyParameter('atr_mult', value),
              ),
              const SizedBox(height: 30),
              // Quick Tips
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF00C3FF).withOpacity(0.05),
                  border: Border.all(
                    color: const Color(0xFF00C3FF),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.tips_and_updates_outlined,
                          color: Color(0xFF00C3FF),
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Quick Tips',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00C3FF),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• Longer SSL1 = Fewer trades, cleaner trends',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFB0BEC5),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '• Shorter SSL2 = More confirmation trades',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFB0BEC5),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '• Higher ATR Multiplier = Wider ranges',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFB0BEC5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Reset Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    strategyProvider.resetToDefaults();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reset to default parameters'),
                        backgroundColor: Color(0xFF81C784),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset to Defaults'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF0062),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting(
    String label,
    String value,
    List<String> items,
    Function(String) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFFB0BEC5),
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: const Color(0xFF1A1A1A),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              prefixIcon: const Icon(Icons.tune, color: Color(0xFF00C3FF)),
            ),
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ))
                .toList(),
            onChanged: (newValue) {
              if (newValue != null) {
                onChanged(newValue);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSliderSetting(
    String label,
    double value,
    double min,
    double max,
    double step,
    Function(double) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFB0BEC5),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C3FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: const Color(0xFF00C3FF),
                    width: 1,
                  ),
                ),
                child: Text(
                  step == 1 ? value.toInt().toString() : value.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00C3FF),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: ((max - min) / step).toInt(),
            activeColor: const Color(0xFF00C3FF),
            inactiveColor: const Color(0xFF00C3FF).withOpacity(0.2),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
