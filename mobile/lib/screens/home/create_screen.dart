import 'package:flutter/material.dart';
import 'package:fred_soutenance_app/theme.dart';
import 'package:fred_soutenance_app/l10n.dart';

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.primary.withOpacity(0.5), width: 2),
                      ),
                      child: const CircleAvatar(
                        backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuAeKLHwcvoQdMMAKMJLWtZm3N37e8Hqb7hdBe48Lj0EzqOxNtthWY-9ytfi0nFVoRC8iIROize-Bgt2up6Jbk73LK6KEgToDMRpQp_eNaAT6r2ugJ7VuBzNrRWSuYT8T_J0oNoZmQ18anOq5wA5h7pJMr66Vq2nq5NvxL20k-GNbTsBezhl9IM49N3_Hy3Jmmypp79Ag6jYlg1kiIHhTJAcNhStjtSdQRd3Qt3FW_XTqz4T-nal7KmhmDL86Ov3tu7oyAWD3RbXENg'), // Placeholder
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.translate('welcome_hi'),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          l10n.translate('ready_session'),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: isDark ? Colors.white38 : Colors.black45,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : Colors.grey[200],
                    shape: BoxShape.circle,
                    border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[300]!),
                  ),
                  child: Icon(Icons.notifications_outlined, color: isDark ? Colors.white : Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Title
            Text(
              l10n.translate('create_meeting'),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            // Form Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF151518).withOpacity(0.6) : Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: isDark ? Colors.white.withOpacity(0.06) : Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    l10n.translate('meeting_title_label'),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    style: TextStyle(color: isDark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[50],
                      hintText: "e.g. Weekly Sync",
                      hintStyle: TextStyle(color: isDark ? Colors.white24 : Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: AppTheme.primary, width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.translate('meeting_type_label'),
                     style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _TypeButton(
                          icon: Icons.videocam,
                          label: l10n.translate('video'),
                          isSelected: true,
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _TypeButton(
                          icon: Icons.auto_awesome,
                          label: l10n.translate('ai_assisted'),
                          isSelected: false,
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _TypeButton(
                          icon: Icons.mic,
                          label: l10n.translate('audio'),
                          isSelected: false,
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.primary, AppTheme.accentBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/invite');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.videocam, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(l10n.translate('create_meeting'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  l10n.translate('scheduled_meetings'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(l10n.translate('see_all'), style: const TextStyle(color: AppTheme.accentBlue)),
                )
              ],
            ),
            const SizedBox(height: 16),
            _buildMeetingItem(
              title: "Design Sprint",
              time: "Today, 2:30 PM • 3 participants",
              icon: Icons.event_repeat,
              color: AppTheme.accentBlue,
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            _buildMeetingItem(
              title: "Monthly Recap",
              time: "Tomorrow, 10:00 AM • 12 participants",
              icon: Icons.groups,
              color: AppTheme.primary,
              isDark: isDark,
            ),
            const SizedBox(height: 100), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingItem({required String title, required String time, required IconData icon, required Color color, required bool isDark}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151518).withOpacity(0.8) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.06) : Colors.grey[200]!),
        boxShadow: isDark ? [] : [
           BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
                const SizedBox(height: 2),
                Text(time, style: TextStyle(fontSize: 11, color: isDark ? Colors.white60 : Colors.black54)),
              ],
            ),
          ),
          Icon(Icons.more_vert, color: isDark ? Colors.white30 : Colors.black26),
        ],
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isDark;

  const _TypeButton({required this.icon, required this.label, required this.isSelected, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isSelected 
          ? AppTheme.primary.withOpacity(isDark ? 0.2 : 0.1)
          : (isDark ? Colors.white.withOpacity(0.05) : Colors.grey[50]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected 
            ? AppTheme.primary.withOpacity(0.5)
            : (isDark ? Colors.white.withOpacity(0.1) : Colors.grey[200]!),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: isSelected ? AppTheme.primary : (isDark ? Colors.white70 : Colors.black54)),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppTheme.primary : (isDark ? Colors.white70 : Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
