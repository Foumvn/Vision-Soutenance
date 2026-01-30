
import 'package:flutter/material.dart';
import 'package:fred_soutenance_app/theme.dart';
import 'package:fred_soutenance_app/l10n.dart';
import 'package:fred_soutenance_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

class InviteParticipantsScreen extends StatefulWidget {
  const InviteParticipantsScreen({super.key});

  @override
  State<InviteParticipantsScreen> createState() => _InviteParticipantsScreenState();
}

class _InviteParticipantsScreenState extends State<InviteParticipantsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : Colors.grey[50],
      body: Stack(
        children: [
          // Background Gradient Base
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: themeProvider.isBlurEnabled ? 30.0 : 0.0,
                sigmaY: themeProvider.isBlurEnabled ? 30.0 : 0.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: isDark ? RadialGradient(
                    center: const Alignment(-0.8, -0.8),
                    radius: 1.2,
                    colors: [
                      const Color(0xFFF97316).withValues(alpha: 0.2),
                      AppTheme.backgroundDark,
                    ],
                  ) : null,
                  color: isDark ? null : Colors.grey[50],
                ),
              ),
            ),
          ),
          // Second aura (dark mode only)
          if (isDark)
            Positioned(
              bottom: -100,
              right: -100,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: themeProvider.isBlurEnabled ? 30.0 : 0.0,
                  sigmaY: themeProvider.isBlurEnabled ? 30.0 : 0.0,
                ),
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFB923C).withValues(alpha: 0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  // Header and Scrollable Content
                  Expanded(
                    child: NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverToBoxAdapter(
                            child: Column(
                              children: [
                                // Top bar
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () => Navigator.pop(context),
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[200],
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.close, color: isDark ? Colors.white : Colors.black54, size: 20),
                                        ),
                                      ),
                                      Text(
                                        l10n.translate('invite_participants'),
                                        style: TextStyle(
                                          color: isDark ? Colors.white : Colors.black87,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 40),
                                    ],
                                  ),
                                ),

                                // Meeting Link Card
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                  child: _buildGlassCard(
                                    isDark: isDark,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 64,
                                          height: 64,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(16),
                                            gradient: const LinearGradient(
                                              colors: [AppTheme.primary, Color(0xFFFB923C)],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppTheme.primary.withValues(alpha: 0.3),
                                                blurRadius: 15,
                                                offset: const Offset(0, 5),
                                              ),
                                            ],
                                          ),
                                          child: const Icon(Icons.link, color: Colors.white, size: 30),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          l10n.translate('meeting_link_label_caps'),
                                          style: TextStyle(
                                            color: isDark ? Colors.white.withValues(alpha: 0.6) : Colors.black54,
                                            fontSize: 10,
                                            letterSpacing: 2,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          "v-meeting.ai/dev-team-sync",
                                          style: TextStyle(
                                            color: isDark ? Colors.white : Colors.black87,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton.icon(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppTheme.primary,
                                            foregroundColor: AppTheme.backgroundDark,
                                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            elevation: 0,
                                          ).copyWith(
                                            shadowColor: WidgetStateProperty.all(AppTheme.primary.withValues(alpha: 0.4)),
                                            elevation: WidgetStateProperty.all(8),
                                          ),
                                          icon: const Icon(Icons.content_copy, size: 18),
                                          label: Text(
                                            l10n.translate('copy_link'),
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: _SliverAppBarDelegate(
                              child: Container(
                                color: isDark ? AppTheme.backgroundDark : Colors.grey[50],
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: TabBar(
                                    controller: _tabController,
                                    indicator: BoxDecoration(
                                      color: AppTheme.primary,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    dividerColor: Colors.transparent,
                                    labelColor: Colors.white,
                                    unselectedLabelColor: isDark ? Colors.white60 : Colors.black54,
                                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                                    tabs: [
                                      Tab(text: l10n.translate('individuals')),
                                      Tab(text: l10n.translate('groups')),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ];
                      },
                      body: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildIndividualsTab(l10n, isDark),
                          _buildGroupsTab(l10n, isDark),
                        ],
                      ),
                    ),
                  ),

                  // Fixed Bottom Buttons Section
                  Container(
                    padding: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF18181B).withValues(alpha: 0.95) : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Launch Meeting Button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          child: Container(
                            width: double.infinity,
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppTheme.primary, Color(0xFFFB923C)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primary.withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/pre-meeting');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.play_circle_filled, color: Colors.white, size: 22),
                                  const SizedBox(width: 12),
                                  Text(
                                    l10n.translate('launch_meeting'),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Share Section
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildShareButton(Icons.chat, "WhatsApp", const Color(0xFF25D366), isDark),
                              _buildShareButton(Icons.hub, "Slack", isDark ? Colors.white : Colors.black87, isDark, bg: const Color(0xFF4A154B)),
                              _buildShareButton(Icons.mail, "Email", isDark ? Colors.white : Colors.black87, isDark),
                              _buildShareButton(Icons.more_horiz, "More", isDark ? Colors.white : Colors.black87, isDark),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
      ),
    );
  }


  Widget _buildIndividualsTab(AppLocalizations l10n, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.translate('frequent_contacts'),
            style: TextStyle(
              color: isDark ? Colors.white.withValues(alpha: 0.4) : Colors.black54,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            "Alison Roberts",
            "Product Designer",
            "https://lh3.googleusercontent.com/aida-public/AB6AXuAeKLHwcvoQdMMAKMJLWtZm3N37e8Hqb7hdBe48Lj0EzqOxNtthWY-9ytfi0nFVoRC8iIROize-Bgt2up6Jbk73LK6KEgToDMRpQp_eNaAT6r2ugJ7VuBzNrRWSuYT8T_J0oNoZmQ18anOq5wA5h7pJMr66Vq2nq5NvxL20k-GNbTsBezhl9IM49N3_Hy3Jmmypp79Ag6jYlg1kiIHhTJAcNhStjtSdQRd3Qt3FW_XTqz4T-nal7KmhmDL86Ov3tu7oyAWD3RbXENg",
            l10n.translate('invite'),
            isDark,
          ),
          const SizedBox(height: 12),
          _buildContactItem(
            "Sarah Paige",
            "Engineering Lead",
            "https://lh3.googleusercontent.com/aida-public/AB6AXuDuI-yWwU-2tX8OzQhZPB9WEMyOCRS0i9l0KOeTCek6nW3hMFH0BY6y8Vj_QIQa7ZXhxQUJNf5hMlPs-rTZao2UXB-RptWUmHAuuWd9WbpcOOerDI62W7evT7cLodCAQXsMsZNlCWOzRixGEdePxkRIgvP8bFCHOVrNi8DMJl0V0TNYg_1Vb3mfOH-YeqCzeKFTl58HpALZECclqJ9RZvZf8qk5Ry25jVXHTW22QUX_ub8wtxsmM1i3vREUE3qs0tKhHQDyoMTw7bM",
            l10n.translate('invite'),
            isDark,
          ),
          const SizedBox(height: 12),
          _buildContactItem(
            "Peter Lee",
            "CTO",
            "https://lh3.googleusercontent.com/aida-public/AB6AXuCATDRZUqD4UaQcrFegcmQc9Ui3nhFN3i6CMa-y9XAySIQnwfHI1Qh8CMhVcMz70DzECxuiPjBcNo9ab3xqgIgie4LtpDcL1x6HJ5Eu4tXo6cy3-ChuaM_5mVBKboC_cOE3HSFSFjhGARLV_EsVq6UB29QC1cN3zKibRbNhMSp4zGEhDn2zYES-md44zb49LnA1uqCyHI11r75PBDwPQNVnEW41Viuaxh5h5fbGZpoj4P7HrmVl3TslnfNVL0feku4VFz7Ut6FosjY",
            l10n.translate('invite'),
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildGroupsTab(AppLocalizations l10n, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGroupItem(
            "Groupe d'étude",
            5,
            Icons.school,
            const Color(0xFFFB923C),
            l10n.translate('invite'),
            isDark,
          ),
          const SizedBox(height: 12),
          _buildGroupItem(
            "Kairos Entreprise",
            12,
            Icons.business,
            AppTheme.primary,
            l10n.translate('invite'),
            isDark,
          ),
          const SizedBox(height: 12),
          _buildGroupItem(
            "Équipe Design",
            8,
            Icons.palette,
            AppTheme.primary,
            l10n.translate('invite'),
            isDark,
          ),
          const SizedBox(height: 12),
          _buildGroupItem(
            "Développeurs",
            15,
            Icons.code,
            const Color(0xFFEC4899),
            l10n.translate('invite'),
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard({required Widget child, required bool isDark}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[200]!),
            boxShadow: isDark ? [] : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildContactItem(String name, String role, String imageUrl, String inviteText, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 13)),
                Text(role, style: TextStyle(color: isDark ? Colors.white.withValues(alpha: 0.4) : Colors.black54, fontSize: 11)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? Colors.white.withValues(alpha: 0.1) : AppTheme.primary.withValues(alpha: 0.1),
              foregroundColor: isDark ? Colors.white : AppTheme.primary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(inviteText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupItem(String groupName, int memberCount, IconData icon, Color color, String inviteText, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  groupName, 
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87, 
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "$memberCount ${l10n.translate('members')}", 
                  style: TextStyle(
                    color: isDark ? Colors.white.withValues(alpha: 0.4) : Colors.black54, 
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: color.withValues(alpha: 0.15),
              foregroundColor: color,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(inviteText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton(IconData icon, String label, Color iconColor, bool isDark, {Color? bg}) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: bg ?? iconColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: (bg ?? iconColor).withValues(alpha: 0.3)),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(height: 6),
        Text(
          label.toUpperCase(),
          style: TextStyle(color: isDark ? Colors.white.withValues(alpha: 0.6) : Colors.black54, fontSize: 9, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({required this.child});

  final Widget child;

  @override
  double get minExtent => 64.0;
  @override
  double get maxExtent => 64.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
