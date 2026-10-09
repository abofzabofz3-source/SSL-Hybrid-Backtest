import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'config/app_config.dart';
import 'config/theme_config.dart';
import 'providers/strategy_provider.dart';
import 'providers/backtest_provider.dart';
import 'screens/splash_screen.dart';

future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('backtests');
  
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
        home: const SplashScreen(),
      ),
    );
  }
}
