import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'providers/bubble_provider.dart';
import 'providers/memory_provider.dart';
import 'screens/bootstrap_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const BubbleTherapyApp());
}

class BubbleTherapyApp extends StatelessWidget {
  const BubbleTherapyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => BubbleProvider()),
        ChangeNotifierProvider(create: (_) => MemoryProvider()),
      ],
      child: MaterialApp(
        title: 'Bubble Therapy',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const BootstrapScreen(),
      ),
    );
  }
}
