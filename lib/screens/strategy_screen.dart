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
  @override
  Widget build(BuildContext context) {
    return Consumer<StrategyProvider>(
      builder: (context, strategyProvider, child) {
        final params = strategyProvider.currentStrategy.parameters;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Strategy Parameters',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // SSL1 Settings
              _buildSectionHeader('SSL1 / Baseline'),
              _buildDropdownSetting(
                'Type',
                params['ssl1_type'],
                AppConfig.maTypes,
                (value) => strategyProvider.updateStrategyParameter('ssl1_type', value),
              ),
              _buildSliderSetting(
                'Length',
                params['ssl1_length'].toDouble(),
                20,
                200,
                (value) => strategyProvider.updateStrategyParameter('ssl1_length', value.toInt()),
              ),
              const SizedBox(height: 20),
              // SSL2 Settings
              _buildSectionHeader('SSL2 / Continuation'),
              _buildDropdownSetting(
                'Type',
                params['ssl2_type'],
                AppConfig.maTypes,
                (value) => strategyProvider.updateStrategyParameter('ssl2_type', value),
              ),
              _buildSliderSetting(
                'Length',
                params['ssl2_length'].toDouble(),
                2,
                50,
                (value) => strategyProvider.updateStrategyParameter('ssl2_length', value.toInt()),
              ),
              const SizedBox(height: 20),
              // SSL3 Settings
              _buildSectionHeader('SSL3 / Exit'),
              _buildDropdownSetting(
                'Type',
                params['ssl3_type'],
                AppConfig.maTypes,
                (value) => strategyProvider.updateStrategyParameter('ssl3_type', value),
              ),
              _buildSliderSetting(
                'Length',
                params['ssl3_length'].toDouble(),
                5,
                100,
                (value) => strategyProvider.updateStrategyParameter('ssl3_length', value.toInt()),
              ),
              const SizedBox(height: 20),
              // ATR Settings
              _buildSectionHeader('ATR Settings'),
              _buildSliderSetting(
                'Period',
                params['atr_period'].toDouble(),
                5,
                50,
                (value) => strategyProvider.updateStrategyParameter('atr_period', value.toInt()),
              ),
              _buildSliderSetting(
                'Multiplier',
                params['atr_mult'],
                0.1,
                3.0,
                (value) => strategyProvider.updateStrategyParameter('atr_mult', value),
                step: 0.1,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    strategyProvider.resetToDefaults();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reset to default parameters'),
                        backgroundColor: Color(0xFF81C784),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF0062),
                  ),
                  child: const Text('Reset to Defaults'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF00C3FF),
        ),
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
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: const Color(0xFF1A1A1A),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
    Function(double) onChanged, {
    double step = 1.0,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              Text(
                value.toStringAsFixed(step == 1.0 ? 0 : 2),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00C3FF),
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
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
