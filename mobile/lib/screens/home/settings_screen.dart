
import 'package:flutter/material.dart';
import 'package:fred_soutenance_app/theme.dart';
import 'package:fred_soutenance_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

import 'package:fred_soutenance_app/providers/language_provider.dart';
import 'package:fred_soutenance_app/l10n.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Header
          const SizedBox(height: 32),
          Center(
            child: Stack(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.primary, width: 2),
                  ),
                  child: const CircleAvatar(
                    backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuAeKLHwcvoQdMMAKMJLWtZm3N37e8Hqb7hdBe48Lj0EzqOxNtthWY-9ytfi0nFVoRC8iIROize-Bgt2up6Jbk73LK6KEgToDMRpQp_eNaAT6r2ugJ7VuBzNrRWSuYT8T_J0oNoZmQ18anOq5wA5h7pJMr66Vq2nq5NvxL20k-GNbTsBezhl9IM49N3_Hy3Jmmypp79Ag6jYlg1kiIHhTJAcNhStjtSdQRd3Qt3FW_XTqz4T-nal7KmhmDL86Ov3tu7oyAWD3RbXENg'),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 3),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Alison",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            "alison.design@nebula.ai",
            style: TextStyle(color: isDark ? Colors.white38 : Colors.black45),
          ),
          const SizedBox(height: 32),

          // Sections
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader("Account", isDark),
                _buildSettingsCard(
                  context,
                  [
                    _buildExpandableTile(
                      context,
                      icon: Icons.person,
                      title: "Profile",
                      color: AppTheme.primary,
                      isDark: isDark,
                      children: [
                        _buildSettingsTile(
                          icon: Icons.edit,
                          title: "Edit Username",
                          color: AppTheme.primary,
                          isDark: isDark,
                          onTap: () {},
                        ),
                        _buildSettingsTile(
                          icon: Icons.email,
                          title: "Update Email",
                          color: AppTheme.primary,
                          isDark: isDark,
                          onTap: () {},
                        ),
                      ],
                    ),
                    _buildDivider(isDark),
                    _buildExpandableTile(
                      context,
                      icon: Icons.notifications,
                      title: "Notifications",
                      color: AppTheme.accentBlue,
                      isDark: isDark,
                      children: [
                        _buildSwitchTile(
                          icon: Icons.notifications_active,
                          title: "Push Notifications",
                          color: AppTheme.accentBlue,
                          value: true,
                          isDark: isDark,
                          onChanged: (v) {},
                        ),
                        _buildSwitchTile(
                          icon: Icons.mail,
                          title: "Email Alerts",
                          color: AppTheme.accentBlue,
                          value: false,
                          isDark: isDark,
                          onChanged: (v) {},
                        ),
                      ],
                    ),

                  ],
                  isDark,
                ),

                
                const SizedBox(height: 24),
                _buildSectionHeader("Meeting Settings", isDark),
                _buildSettingsCard(
                  context,
                  [
                    _buildSwitchTile(
                      icon: Icons.auto_awesome,
                      title: l10n.translate('ai_transcription'),
                      color: AppTheme.primary,
                      value: true,
                      isDark: isDark,
                      onChanged: (v) {},
                    ),
                    _buildDivider(isDark),
                    _buildSwitchTile(
                      icon: Icons.blur_on,
                      title: "Background Blur",
                      color: Colors.grey,
                      value: themeProvider.isBlurEnabled,
                      isDark: isDark,
                      onChanged: (v) {
                        themeProvider.toggleBlur(v);
                      },
                    ),

                  ],
                  isDark,
                ),

                const SizedBox(height: 24),
                _buildSectionHeader(l10n.translate('settings'), isDark),
                _buildSettingsCard(
                  context,
                  [
                    _buildSwitchTile(
                      icon: Icons.dark_mode,
                      title: l10n.translate('dark_mode'),
                      color: AppTheme.primary,
                      value: themeProvider.isDarkMode,
                      isDark: isDark,
                      onChanged: (v) {
                        themeProvider.toggleTheme(v);
                      },
                    ),
                    _buildDivider(isDark),
                    _buildSettingsTile(
                      icon: Icons.language,
                      title: l10n.translate('language'),
                      trailingText: languageProvider.locale.languageCode == 'en' ? "English" : "Français",
                      color: AppTheme.accentBlue,
                      isDark: isDark,
                      onTap: () {
                        _showLanguagePicker(context, languageProvider);
                      },
                    ),
                  ],
                  isDark,
                ),

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      foregroundColor: Colors.redAccent,
                    ),
                    child: const Text("Sign Out", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: isDark ? Colors.white30 : Colors.black38,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, List<Widget> children, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(height: 1, thickness: 1, color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100]);
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required Color color,
    required bool isDark,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null) ...[
            Text(trailingText, style: const TextStyle(fontSize: 12, color: AppTheme.accentBlue)),
            const SizedBox(width: 8),
          ],
          Icon(Icons.chevron_right, color: isDark ? Colors.white24 : Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required Color color,
    required bool value,
    required bool isDark,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      secondary: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: value ? AppTheme.primary.withValues(alpha: 0.1) : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100]),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: value ? AppTheme.primary : (isDark ? Colors.white54 : Colors.black54), size: 20),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
    );
  }

  Widget _buildExpandableTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required bool isDark,
    required List<Widget> children,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: isDark ? Colors.white : Colors.black87,
            )),
        trailing: Icon(
          Icons.chevron_right,
          color: isDark ? Colors.white24 : Colors.grey[400],
        ),
        childrenPadding: const EdgeInsets.only(left: 16),
        children: children,
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, LanguageProvider provider) {

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Select Language / Choisir la langue",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text("English"),
              leading: const Icon(Icons.language),
              trailing: provider.locale.languageCode == 'en' ? const Icon(Icons.check, color: AppTheme.primary) : null,
              onTap: () {
                provider.changeLanguage('en');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Français"),
              leading: const Icon(Icons.language),
              trailing: provider.locale.languageCode == 'fr' ? const Icon(Icons.check, color: AppTheme.primary) : null,
              onTap: () {
                provider.changeLanguage('fr');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
