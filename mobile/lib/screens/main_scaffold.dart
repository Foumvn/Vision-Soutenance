
import 'package:flutter/material.dart';
import 'package:fred_soutenance_app/theme.dart';
import 'package:fred_soutenance_app/screens/home/create_screen.dart';
import 'package:fred_soutenance_app/screens/home/schedule_screen.dart';
import 'package:fred_soutenance_app/screens/home/history_screen.dart';
import 'package:fred_soutenance_app/screens/home/settings_screen.dart';
import 'package:fred_soutenance_app/l10n.dart';
import 'package:fred_soutenance_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const CreateScreen(),
    const ScheduleScreen(),
    const HistoryScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          // Background Aura
          if (isDark)
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: themeProvider.isBlurEnabled ? 30.0 : 0.0,
                  sigmaY: themeProvider.isBlurEnabled ? 30.0 : 0.0,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      radius: 1.2,
                      center: Alignment(0, -0.2),
                      colors: [
                        Color(0xFF0F172A),
                        Color(0xFF050508),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          SafeArea(child: _screens[_currentIndex]),
          
          // Custom Floating Bottom Navigation Bar
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0B0A0F).withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(35),
                border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.add_circle, l10n.translate('create'), 0, isDark),
                  _buildNavItem(Icons.calendar_today, l10n.translate('schedule'), 1, isDark),
                  _buildNavItem(Icons.history, l10n.translate('history'), 2, isDark),
                  _buildNavItem(Icons.settings, l10n.translate('settings'), 3, isDark),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, bool isDark) {
    final bool isSelected = _currentIndex == index;
    final Color color = isSelected 
      ? AppTheme.primary 
      : (isDark ? Colors.white30 : Colors.black26);

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        color: Colors.transparent, // Hit test
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
              shadows: isSelected && isDark 
                ? [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.6), blurRadius: 10)] 
                : [],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
