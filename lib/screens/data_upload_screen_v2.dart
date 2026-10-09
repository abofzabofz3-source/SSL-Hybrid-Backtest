import 'package:flutter/material.dart';

class DataUploadScreen extends StatefulWidget {
  const DataUploadScreen({Key? key}) : super(key: key);

  @override
  State<DataUploadScreen> createState() => _DataUploadScreenState();
}

class _DataUploadScreenState extends State<DataUploadScreen> {
  String _selectedInstrument = 'XAUUSD';
  String _selectedTimeframe = '1D';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Data Source',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          // Instrument Selection
          const Text(
            'Instrument',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedInstrument,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: const Color(0xFF1A1A1A),
              prefixIcon: const Icon(Icons.trending_up, color: Color(0xFF00C3FF)),
            ),
            items: const [
              DropdownMenuItem(value: 'XAUUSD', child: Text('XAUUSD (Gold)')),
              DropdownMenuItem(value: 'EURUSD', child: Text('EURUSD')),
              DropdownMenuItem(value: 'GBPUSD', child: Text('GBPUSD')),
            ]
                .map((item) => item)
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedInstrument = value ?? 'XAUUSD';
              });
            },
          ),
          const SizedBox(height: 20),
          // Timeframe Selection
          const Text(
            'Timeframe',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedTimeframe,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: const Color(0xFF1A1A1A),
              prefixIcon: const Icon(Icons.schedule, color: Color(0xFF00C3FF)),
            ),
            items: const ['1D', '4H']
                .map((tf) => DropdownMenuItem(value: tf, child: Text(tf)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedTimeframe = value ?? '1D';
              });
            },
          ),
          const SizedBox(height: 30),
          // Data Source Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFF00C3FF).withOpacity(0.05),
              border: Border.all(
                color: const Color(0xFF00C3FF),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.info_outlined,
                      color: Color(0xFF00C3FF),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Data Information',
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
                  '• Real historical XAUUSD data loaded',
                  style: TextStyle(fontSize: 12, color: Color(0xFFB0BEC5)),
                ),
                const SizedBox(height: 4),
                const Text(
                  '• Daily: Last 30 trading days',
                  style: TextStyle(fontSize: 12, color: Color(0xFFB0BEC5)),
                ),
                const SizedBox(height: 4),
                const Text(
                  '• 4H: Last 20 days (4-hourly)',
                  style: TextStyle(fontSize: 12, color: Color(0xFFB0BEC5)),
                ),
                const SizedBox(height: 4),
                const Text(
                  '• Data is ready to backtest',
                  style: TextStyle(fontSize: 12, color: Color(0xFFB0BEC5)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Data loaded: $_selectedInstrument $_selectedTimeframe',
                    ),
                    backgroundColor: const Color(0xFF81C784),
                  ),
                );
              },
              icon: const Icon(Icons.check_circle),
              label: const Text('Load Data'),
            ),
          ),
          const SizedBox(height: 20),
          // FAQ Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFF1A1A1A),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'About SSL Hybrid',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'SSL Hybrid is a trend-following strategy based on the NNFX method. It uses three moving averages (SSL1, SSL2, SSL3) and ATR bands to identify entry and exit points.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFB0BEC5),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C3FF).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Color(0xFF00C3FF),
                        size: 18,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Tip: Start with default parameters for best results',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF00C3FF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
