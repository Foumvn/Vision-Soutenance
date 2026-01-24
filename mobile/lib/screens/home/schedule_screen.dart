import 'package:flutter/material.dart';
import 'package:fred_soutenance_app/theme.dart';
import 'package:fred_soutenance_app/l10n.dart';

class MeetingData {
  final String title;
  final String time;
  final String status;
  final Color statusColor;
  final int participants;

  MeetingData({
    required this.title,
    required this.time,
    required this.status,
    required this.statusColor,
    required this.participants,
  });
}

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchVisible = false;

  final List<MeetingData> _allMeetings = [
    MeetingData(
      title: "Strategy Alignment",
      time: "11:30 AM - 12:30 PM",
      status: "Upcoming",
      statusColor: AppTheme.primary,
      participants: 3,
    ),
    MeetingData(
      title: "Design Critique",
      time: "02:00 PM - 03:00 PM",
      status: "Pending",
      statusColor: AppTheme.accentBlue,
      participants: 2,
    ),
    MeetingData(
      title: "AI Integration Workshop",
      time: "04:30 PM - 05:30 PM",
      status: "AI Insight",
      statusColor: AppTheme.primary,
      participants: 4,
    ),
    MeetingData(
      title: "Quarterly Review",
      time: "09:00 AM - 10:30 AM",
      status: "Completed",
      statusColor: Colors.green,
      participants: 5,
    ),
  ];

  List<MeetingData> _filteredMeetings = [];

  @override
  void initState() {
    super.initState();
    _filteredMeetings = _allMeetings;
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
      _filteredMeetings = _allMeetings
          .where((meeting) => meeting.title.toLowerCase().contains(_searchController.text.toLowerCase()))
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
                  l10n.translate('schedule'),
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
            // Calendar Strip
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCalendarDay("MON", "11", false, isDark),
                  _buildCalendarDay("TUE", "12", false, isDark),
                  _buildCalendarDay("WED", "13", true, isDark),
                  _buildCalendarDay("THU", "14", false, isDark),
                  _buildCalendarDay("FRI", "15", false, isDark),
                  _buildCalendarDay("SAT", "16", false, isDark),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.translate('today_meetings'),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
                Text(
                  "${_filteredMeetings.length} EVENTS",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (_filteredMeetings.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Column(
                    children: [
                      Icon(Icons.event_busy, size: 48, color: isDark ? Colors.white24 : Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        "No events found",
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
                itemCount: _filteredMeetings.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final meeting = _filteredMeetings[index];
                  return _buildScheduleCard(
                    title: meeting.title,
                    time: meeting.time,
                    status: meeting.status,
                    statusColor: meeting.statusColor,
                    participants: meeting.participants,
                    isDark: isDark,
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

  Widget _buildCalendarDay(String day, String date, bool isActive, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 60,
      height: 90,
      decoration: BoxDecoration(
        color: isActive 
          ? null 
          : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white),
        gradient: isActive ? const LinearGradient(colors: [AppTheme.primary, Color(0xFF6D28D9)]) : null,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? Colors.transparent : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!)),
        boxShadow: isActive 
          ? [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.4), blurRadius: 10)]
          : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(day, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isActive ? Colors.white70 : (isDark ? Colors.white38 : Colors.black45))),
          const SizedBox(height: 4),
          Text(date, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isActive ? Colors.white : (isDark ? Colors.white : Colors.black87))),
        ],
      ),
    );
  }

  Widget _buildScheduleCard({
    required String title,
    required String time,
    required String status,
    required Color statusColor,
    required int participants,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100]!),
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
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 14, color: statusColor),
                        const SizedBox(width: 4),
                        Text(time, style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.black54)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor.withValues(alpha: 0.2)),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               SizedBox(
                height: 32,
                width: 100, 
                child: Stack(
                  children: [
                    for (int i = 0; i < 3; i++)
                      Positioned(
                        left: i * 20.0,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: isDark ? AppTheme.backgroundDark : Colors.white,
                          child: CircleAvatar(
                             radius: 12,
                             backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=$i'),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                 decoration: BoxDecoration(
                   color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
                   borderRadius: BorderRadius.circular(12),
                 ),
                 child: const Text("Details", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              )
            ],
          )
        ],
      ),
    );
  }
}
