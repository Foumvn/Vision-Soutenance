import 'package:flutter/material.dart';
import 'package:fred_soutenance_app/theme.dart';
import 'package:fred_soutenance_app/l10n.dart';

class HistoryItemData {
  final String title;
  final String time;
  final bool hasAiSummary;

  HistoryItemData({
    required this.title,
    required this.time,
    required this.hasAiSummary,
  });
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchVisible = false;

  
  final List<HistoryItemData> _allHistory = [
    HistoryItemData(
      title: "Project Sync: Alpha",
      time: "Yesterday, 4:15 PM • 45m",
      hasAiSummary: true,
    ),
    HistoryItemData(
      title: "Weekly Product Review",
      time: "Dec 12, 11:00 AM • 1h 20m",
      hasAiSummary: true,
    ),
    HistoryItemData(
      title: "Backend Architecture",
      time: "Dec 11, 09:30 AM • 30m",
      hasAiSummary: false,
    ),
    HistoryItemData(
      title: "Team Brainstorming",
      time: "Dec 10, 2:00 PM • 1h",
      hasAiSummary: true,
    ),
    HistoryItemData(
      title: "Client Feedback Session",
      time: "Dec 09, 10:00 AM • 45m",
      hasAiSummary: false,
    ),
  ];

  List<HistoryItemData> _filteredHistory = [];

  @override
  void initState() {
    super.initState();
    _filteredHistory = _allHistory;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _filteredHistory = _allHistory
          .where((item) => item.title.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.translate('history'),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isSearchVisible = !_isSearchVisible;
                          if (!_isSearchVisible) {
                            _searchController.clear();
                          }
                        });
                      },
                      child: _buildIconButton(Icons.search, isDark, isActive: _isSearchVisible),
                    ),
                    const SizedBox(width: 8),
                    _buildIconButton(Icons.tune, isDark),
                  ],
                ),

              ],
            ),
            AnimatedContainer(

              duration: const Duration(milliseconds: 300),
              height: _isSearchVisible ? 70 : 0,
              curve: Curves.easeInOut,
              child: _isSearchVisible 
                ? Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[200]!),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                        decoration: InputDecoration(
                          hintText: l10n.translate('search_hint'),
                          hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey[400], fontSize: 14),
                          border: InputBorder.none,
                          icon: Icon(Icons.search, size: 20, color: isDark ? Colors.white38 : Colors.grey[400]),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.translate('recent_meetings'),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
                Text(
                  "${_filteredHistory.length} ITEMS",
                  style: TextStyle(fontSize: 11, color: AppTheme.primary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_filteredHistory.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Column(
                    children: [
                      Icon(Icons.search_off, size: 48, color: isDark ? Colors.white24 : Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        "No results found",
                        style: TextStyle(color: isDark ? Colors.white38 : Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredHistory.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final item = _filteredHistory[index];
                  return _buildHistoryItem(
                    title: item.title,
                    time: item.time,
                    hasAiSummary: item.hasAiSummary,
                    isDark: isDark,
                    l10n: l10n,
                  );
                },
              ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, bool isDark, {bool isActive = false}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isActive 
          ? AppTheme.primary.withValues(alpha: 0.1) 
          : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100]),
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive 
            ? AppTheme.primary.withValues(alpha: 0.5) 
            : (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[200]!)
        ),
      ),
      child: Icon(
        icon, 
        size: 20, 
        color: isActive ? AppTheme.primary : (isDark ? Colors.white70 : Colors.black54)
      ),
    );
  }

  Widget _buildHistoryItem({required String title, required String time, required bool hasAiSummary, required bool isDark, required AppLocalizations l10n}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.6), blurRadius: 4)]
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(time, style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.black54)),
                    ),
                  ],
                ),
              ),
              Icon(Icons.more_horiz, color: isDark ? Colors.white24 : Colors.grey[400]),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 28,
                width: 80,
                child: Stack(
                  children: [
                    for (int i = 0; i < 2; i++)
                      Positioned(
                        left: i * 18.0,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: isDark ? AppTheme.backgroundDark : Colors.white,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${i + 10}'),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (hasAiSummary)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: AppTheme.primary, size: 14),
                      const SizedBox(width: 4),
                      Text(l10n.translate('ai_summary'), style: const TextStyle(color: AppTheme.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.description, color: isDark ? Colors.white24 : Colors.grey[400], size: 14),
                      const SizedBox(width: 4),
                      Text(l10n.translate('no_summary'), style: TextStyle(color: isDark ? Colors.white24 : Colors.grey[400], fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
            ],
          )
        ],
      ),
    );
  }
}
