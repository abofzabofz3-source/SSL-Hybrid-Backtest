import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/strategy_provider.dart';
import 'providers/backtest_provider.dart';
import 'config/theme_config.dart';
import 'config/app_config.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const SSLHybridBacktesterApp());
}

class SSLHybridBacktesterApp extends StatelessWidget {
  const SSLHybridBacktesterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StrategyProvider()),
        ChangeNotifierProvider(create: (_) => BacktestProvider()),
      ],
      child: MaterialApp(
        title: 'SSL Hybrid Backtester',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: const HomeScreen(),
      ),
    );
  }
}
