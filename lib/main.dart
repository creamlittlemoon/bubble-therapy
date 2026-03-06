import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'providers/bubble_provider.dart';
import 'providers/memory_provider.dart';
import 'screens/main_screen.dart';

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
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6B9AC4),
            brightness: Brightness.light,
            primary: const Color(0xFF6B9AC4),
            secondary: const Color(0xFFE8A87C),
            surface: const Color(0xFFF7F9FC),
            background: const Color(0xFFF7F9FC),
          ),
          scaffoldBackgroundColor: const Color(0xFFF7F9FC),
          fontFamily: 'SF Pro Display',
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D3748),
              letterSpacing: -0.5,
            ),
            displayMedium: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
              letterSpacing: -0.3,
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              color: Color(0xFF4A5568),
              height: 1.6,
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              color: Color(0xFF718096),
              height: 1.5,
            ),
          ),
        ),
        home: const MainScreen(),
      ),
    );
  }
}
