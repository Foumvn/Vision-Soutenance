
import 'package:flutter/material.dart';
import 'package:fred_soutenance_app/theme.dart';
import 'package:fred_soutenance_app/l10n.dart';
import 'package:fred_soutenance_app/providers/theme_provider.dart';
import 'package:fred_soutenance_app/providers/meeting_provider.dart';
import 'package:fred_soutenance_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui';

class PreMeetingScreen extends StatefulWidget {
  const PreMeetingScreen({super.key});

  @override
  State<PreMeetingScreen> createState() => _PreMeetingScreenState();
}

class _PreMeetingScreenState extends State<PreMeetingScreen> {
  bool isMicEnabled = true;
  bool isCameraEnabled = true;
  bool isTranscriptionEnabled = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF050208) : Colors.white,
      body: Stack(
        children: [
          // Background Auras (Dark mode only)
          if (isDark) ...[
            Positioned(
              top: -100,
              left: -100,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: themeProvider.isBlurEnabled ? 100.0 : 0.0,
                  sigmaY: themeProvider.isBlurEnabled ? 100.0 : 0.0,
                ),
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primary.withValues(alpha: 0.15),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              right: -100,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: themeProvider.isBlurEnabled ? 100.0 : 0.0,
                  sigmaY: themeProvider.isBlurEnabled ? 100.0 : 0.0,
                ),
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withValues(alpha: 0.1),
                  ),
                ),
              ),
            ),
          ],

          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(context, l10n, isDark),
                
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Camera Preview Card
                        _buildCameraPreview(l10n, isDark),
                        const SizedBox(height: 32),
                        
                        // AI Transcription Section
                        _buildTranscriptionSection(l10n, isDark),
                        const SizedBox(height: 24),
                        
                        // Audio Level Section
                        _buildAudioLevelSection(l10n, isDark),
                        const SizedBox(height: 100), // Space for bottom button
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Button
          _buildBottomButton(l10n, isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close, color: isDark ? Colors.white : Colors.black87),
          ),
          Column(
            children: [
              Text(
                l10n.translate('pre_meeting_title'),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                l10n.translate('starting_in'),
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings, color: isDark ? Colors.white : Colors.black87),
            style: IconButton.styleFrom(
              backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview(AppLocalizations l10n, bool isDark) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[300]!),
          image: const DecorationImage(
            image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuCFxNlCEMkKQGKSmB_4SUYvMLz-_JG503oMhiTy8_BddUFQ9YYd6yyk7N2XNoxWxPSsJAq7Zhzlh6F3X3PSZafC1nHNhxeoarcBwt8cPNXI7C3OvpfYOvcixQYyPcWgM3YQj6J9ZmTcM9jR5aagpNlahwdi5JTjLtV_pPEtZhccC2fZSiIVDi90YCidHZIIzvEoQ0GUrJtZBgRoNC6ed8KPXk_k1do1tue0KdJ7XMt-s1_h2kkMgbdxXxmKG61Dk1Vy5svOp6HhYFU"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Mirroring Badge
            Positioned(
              top: 16,
              right: 16,
              child: _buildGlassContainer(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                isDark: isDark,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.flip, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      l10n.translate('mirroring_on'),
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            // Controls
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildControlCircle(
                      icon: isMicEnabled ? Icons.mic : Icons.mic_off,
                      label: l10n.translate('active'),
                      isEnabled: isMicEnabled,
                      onTap: () => setState(() => isMicEnabled = !isMicEnabled),
                      isDark: isDark,
                    ),
                    const SizedBox(width: 24),
                    _buildControlCircle(
                      icon: isCameraEnabled ? Icons.videocam : Icons.videocam_off,
                      label: l10n.translate('camera_on'),
                      isEnabled: isCameraEnabled,
                      onTap: () => setState(() => isCameraEnabled = !isCameraEnabled),
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildControlCircle({
    required IconData icon,
    required String label,
    required bool isEnabled,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.05),
              border: Border.all(
                color: isEnabled ? AppTheme.accentGreen.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.1),
                width: 2,
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: isEnabled ? AppTheme.accentGreen : Colors.white54,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTranscriptionSection(AppLocalizations l10n, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.translate('ai_multi_lang'),
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(full),
              ),
              child: const Text("BETA", style: TextStyle(color: AppTheme.primary, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildGlassContainer(
          isDark: isDark,
          padding: const EdgeInsets.all(20),
          highlight: true,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.translate('enable_live_transcription'),
                        style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        l10n.translate('real_time_captions'),
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  Switch(
                    value: isTranscriptionEnabled,
                    activeColor: AppTheme.accentGreen,
                    onChanged: (v) => setState(() => isTranscriptionEnabled = v),
                  ),
                ],
              ),
              const Divider(height: 32, color: Colors.white10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.language, color: AppTheme.primary, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.translate('translate_to').toUpperCase(),
                            style: const TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            AppLocalizations.of(context)!.locale.languageCode == 'fr' ? "Français (FR)" : "English (EN)",
                            style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.expand_more, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAudioLevelSection(AppLocalizations l10n, bool isDark) {
    return _buildGlassContainer(
      isDark: isDark,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.graphic_eq, color: Colors.grey, size: 20),
              const SizedBox(width: 12),
              // Mic Level Visualizer (Static placeholder)
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _bar(8, AppTheme.accentGreen),
                  _bar(16, AppTheme.accentGreen),
                  _bar(20, AppTheme.accentGreen),
                  _bar(12, AppTheme.accentGreen),
                  _bar(16, AppTheme.accentGreen),
                  _bar(8, Colors.white12),
                  _bar(8, Colors.white12),
                ],
              ),
            ],
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
              foregroundColor: AppTheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            child: Text(
              l10n.translate('test_speaker'),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bar(double height, Color color) {
    return Container(
      width: 3,
      height: height,
      margin: const EdgeInsets.only(right: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(full),
      ),
    );
  }

  Widget _buildBottomButton(AppLocalizations l10n, bool isDark) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              isDark ? const Color(0xFF050208) : Colors.white,
              isDark ? const Color(0xFF050208).withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.8),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, Color(0xFFa855f7)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () async {
                  final meetingProvider = Provider.of<MeetingProvider>(context, listen: false);
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                  
                  // Vérifier les permissions
                  if (isCameraEnabled) {
                    await Permission.camera.request();
                  }
                  if (isMicEnabled) {
                    await Permission.microphone.request();
                  }

                  try {
                    const String testRoom = 'dev-team-sync';
                    final String userName = authProvider.user?['full_name'] ?? 'Guest';
                    
                    await meetingProvider.joinMeeting(testRoom, userName);
                    
                    if (context.mounted) {
                      Navigator.pushNamed(context, '/meeting');
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erreur: $e')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.translate('join_meeting'),
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.login, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 128,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassContainer({
    required Widget child,
    required bool isDark,
    EdgeInsetsGeometry? padding,
    bool highlight = false,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black12),
            boxShadow: highlight && isDark ? [
              BoxShadow(
                color: AppTheme.primary.withValues(alpha: 0.1),
                blurRadius: 40,
                spreadRadius: -10,
              )
            ] : [],
          ),
          child: child,
        ),
      ),
    );
  }
}
const double full = 999;
