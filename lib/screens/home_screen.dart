import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/strategy_provider.dart';
import '../config/app_config.dart';
import 'strategy_screen.dart';
import 'data_upload_screen.dart';
import 'results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    const DataUploadScreen(),
    const StrategyScreen(),
    const ResultsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SSL Hybrid Backtester'),
        centerTitle: true,
        elevation: 0,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.upload_file),
            label: 'Data',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Strategy',
          ),
          NavigationDestination(
            icon: Icon(Icons.assessment),
            label: 'Results',
          ),
        ],
      ),
    );
  }
}
