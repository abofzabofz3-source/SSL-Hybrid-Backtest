import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../config/app_config.dart';

class DataUploadScreen extends StatefulWidget {
  const DataUploadScreen({Key? key}) : super(key: key);

  @override
  State<DataUploadScreen> createState() => _DataUploadScreenState();
}

class _DataUploadScreenState extends State<DataUploadScreen> {
  String? _selectedInstrument = AppConfig.defaultInstrument;
  String? _selectedTimeframe = AppConfig.defaultTimeframe;
  String? _uploadedFileName;
  int? _rowCount;
  bool _isProcessing = false;

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        setState(() {
          _uploadedFileName = result.files.single.name;
          _rowCount = 0; // TODO: Count rows from CSV
          _isProcessing = true;
        });

        // Simulate processing
        await Future.delayed(const Duration(seconds: 2));

        setState(() {
          _isProcessing = false;
          _rowCount = 500; // Mock data
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ File uploaded successfully'),
            backgroundColor: Color(0xFF81C784),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Color(0xFFE53935),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upload Historical Data',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          // Instrument Selection
          const Text(
            'Instrument',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
            ),
            items: AppConfig.instruments
                .map((instrument) => DropdownMenuItem(
                      value: instrument,
                      child: Text(instrument),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedInstrument = value;
              });
            },
          ),
          const SizedBox(height: 20),
          // Timeframe Selection
          const Text(
            'Timeframe',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
            ),
            items: AppConfig.timeframes
                .map((timeframe) => DropdownMenuItem(
                      value: timeframe,
                      child: Text(timeframe),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedTimeframe = value;
              });
            },
          ),
          const SizedBox(height: 30),
          // File Upload Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF00C3FF),
                width: 2,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFF00C3FF).withOpacity(0.05),
            ),
            child: _isProcessing
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF00C3FF),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 48,
                        color: const Color(0xFF00C3FF),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Click to upload CSV file',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF00C3FF),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Format: datetime, open, high, low, close, volume',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF78909C),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _pickFile,
                        icon: const Icon(Icons.folder_open),
                        label: const Text('Choose File'),
                      ),
                    ],
                  ),
          ),
          if (_uploadedFileName != null) ...[{
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF81C784).withOpacity(0.1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF81C784),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _uploadedFileName!,
                        style: const TextStyle(
                          color: Color(0xFF81C784),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rows: $_rowCount',
                    style: const TextStyle(
                      color: Color(0xFF78909C),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          }],
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _uploadedFileName != null
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Data loaded successfully!'),
                          backgroundColor: Color(0xFF81C784),
                        ),
                      );
                    }
                  : null,
              child: const Text('Load Data'),
            ),
          ),
        ],
      ),
    );
  }
}
