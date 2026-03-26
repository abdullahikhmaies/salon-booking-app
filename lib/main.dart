import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Here we would initialize Firebase in the future
  // try {
  //   await Firebase.initializeApp();
  // } catch (e) {
  //   print('Firebase initialization error: $e');
  // }

  runApp(const ProviderScope(child: SalonBookingApp()));
}

class SalonBookingApp extends StatelessWidget {
  const SalonBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salon Booking',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,

      // Arabic Localization Setup
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'SA'), // Arabic
        Locale('en', 'US'), // English (fallback)
      ],
      locale: const Locale('ar', 'SA'), // Default to Arabic

      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: LoginScreen(),
      ),
    );
  }
}
