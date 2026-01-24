
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fred_soutenance_app/theme.dart';
import 'package:fred_soutenance_app/providers/theme_provider.dart';
import 'package:fred_soutenance_app/screens/splash_screen.dart';
import 'package:fred_soutenance_app/screens/onboarding/onboarding_screen.dart';
import 'package:fred_soutenance_app/screens/main_scaffold.dart';
import 'package:fred_soutenance_app/screens/home/invite_participants_screen.dart';
import 'package:fred_soutenance_app/screens/home/pre_meeting_screen.dart';
import 'package:fred_soutenance_app/screens/home/meeting_screen.dart';
import 'package:fred_soutenance_app/screens/signup_screen.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fred_soutenance_app/providers/language_provider.dart';
import 'package:fred_soutenance_app/l10n.dart';
import 'dart:ui';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      title: 'Fred Soutenance',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      locale: languageProvider.locale,
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const MainScaffold(),
        '/invite': (context) => const InviteParticipantsScreen(),
        '/pre-meeting': (context) => const PreMeetingScreen(),
        '/meeting': (context) => const MeetingScreen(),
      },
    );
  }
}

