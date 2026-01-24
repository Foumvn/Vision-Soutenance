import 'package:flutter/material.dart';
import 'package:fred_soutenance_app/theme.dart';
import 'package:fred_soutenance_app/l10n.dart';
import 'dart:ui';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({super.key});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _pulseController;
  
  bool isMicOn = true;
  bool isSpeakerOn = true;
  bool _isChatOpen = false;
  
  final TextEditingController _chatController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      sender: 'Meeting AI',
      message: "I've summarized the last 5 minutes: Alison proposed a switch to Tailwind v4, Peter noted the performance benefits.",
      isAI: true,
      time: '19:00',
    ),
    ChatMessage(
      sender: 'Sarah Paige',
      message: 'Does that timeline work for the design team?',
      isAI: false,
      time: '19:01',
    ),
    ChatMessage(
      sender: 'You',
      message: 'Yes, we can start the migration next sprint.',
      isAI: false,
      isMe: true,
      time: '19:02',
    ),
    ChatMessage(
      sender: 'Meeting AI',
      message: 'Update project roadmap with migration phase by EOD Friday.',
      isAI: true,
      isActionItem: true,
      time: '19:02',
    ),
  ];
  
  int _meetingDuration = 32; // en secondes

  @override
  void initState() {
    super.initState();
    
    // Animation pour l'orbe flottante de l'AI
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    
    // Animation pour les barres audio de l'AI
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    // Timer pour la durée de la réunion
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() => _meetingDuration++);
        return true;
      }
      return false;
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    _pulseController.dispose();
    _chatController.dispose();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')} min';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Contenu principal de la réunion
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFE2A7B5),
                  const Color(0xFFD4A3E3),
                  isDark ? AppTheme.backgroundDark : Colors.white,
                ],
                stops: const [0.0, 0.15, 0.45],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  _buildHeader(l10n, isDark),
                  
                  // Grande vidéo du participant actif
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: _buildActiveSpeakerVideo(),
                  ),
                  
                  // Grille des autres participants
                  Expanded(
                    child: _buildParticipantsGrid(),
                  ),
                  
                  // Contrôles en bas
                  _buildBottomControls(l10n, isDark),
                ],
              ),
            ),
          ),
          
          // Panneau de chat qui slide depuis le bas
          if (_isChatOpen) _buildChatPanel(l10n, isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                ),
                Column(
                  children: [
                    Text(
                      l10n.translate('development_team') ?? 'Development Team',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _formatDuration(_meetingDuration),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.cast, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveSpeakerVideo() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFA3E635),
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFA3E635).withValues(alpha: 0.4),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuAeKLHwcvoQdMMAKMJLWtZm3N37e8Hqb7hdBe48Lj0EzqOxNtthWY-9ytfi0nFVoRC8iIROize-Bgt2up6Jbk73LK6KEgToDMRpQp_eNaAT6r2ugJ7VuBzNrRWSuYT8T_J0oNoZmQ18anOq5wA5h7pJMr66Vq2nq5NvxL20k-GNbTsBezhl9IM49N3_Hy3Jmmypp79Ag6jYlg1kiIHhTJAcNhStjtSdQRd3Qt3FW_XTqz4T-nal7KmhmDL86Ov3tu7oyAWD3RbXENg',
                fit: BoxFit.cover,
              ),
              // Badge "Speaking"
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA3E635).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFA3E635).withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Text(
                    'SPEAKING',
                    style: TextStyle(
                      color: Color(0xFFA3E635),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              // Nom du participant
              Positioned(
                bottom: 0,
                left: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(16)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundDark.withValues(alpha: 0.9),
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(16)),
                      ),
                      child: const Text(
                        'Alison Roberts',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParticipantsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: [
          _buildAIParticipant(),
          _buildParticipantTile(
            'Sarah Paige',
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDuI-yWwU-2tX8OzQhZPB9WEMyOCRS0i9l0KOeTCek6nW3hMFH0BY6y8Vj_QIQa7ZXhxQUJNf5hMlPs-rTZao2UXB-RptWUmHAuuWd9WbpcOOerDI62W7evT7cLodCAQXsMsZNlCWOzRixGEdePxkRIgvP8bFCHOVrNi8DMJl0V0TNYg_1Vb3mfOH-YeqCzeKFTl58HpALZECclqJ9RZvZf8qk5Ry25jVXHTW22QUX_ub8wtxsmM1i3vREUE3qs0tKhHQDyoMTw7bM',
            isMicMuted: true,
            isAvatar: true,
          ),
          _buildParticipantTile(
            'Peter Lee',
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCATDRZUqD4UaQcrFegcmQc9Ui3nhFN3i6CMa-y9XAySIQnwfHI1Qh8CMhVcMz70DzECxuiPjBcNo9ab3xqgIgie4LtpDcL1x6HJ5Eu4tXo6cy3-ChuaM_5mVBKboC_cOE3HSFSFjhGARLV_EsVq6UB29QC1cN3zKibRbNhMSp4zGEhDn2zYES-md44zb49LnA1uqCyHI11r75PBDwPQNVnEW41Viuaxh5h5fbGZpoj4P7HrmVl3TslnfNVL0feku4VFz7Ut6FosjY',
          ),
          _buildParticipantTile(
            'Luke Smith',
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCC3xvWM1UYZ-sCN02LF_iczwYmoBWcsRGc1mAh3TWO7eMcnh6XjjJPwblHCooCCQe8jt7Y4Ddw0H2cywFef0t9ApO90a1BO7NFmGkzvmItv8cxduCN3vIkmJ2ZDn5evgbPiRALvDUxC1CAXHi14kAZQH9bpSu8JJrl2Qa7YAEX9vJM-E4Mn4FMRsgc7fz2VsWPqCPC3TNs3ke4-Yvb_CSJ9CSTjZaCucxqFzehQYJelgnelxFCofKBY_mfGHwA0KtdU1C6q98r2DA',
            isMicMuted: true,
            isAvatar: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAIParticipant() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.0,
          colors: [
            const Color(0xFF8B5CF6).withValues(alpha: 0.15),
            const Color(0xFF3B82F6).withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
            blurRadius: 20,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Orbe holographique animée
          Center(
            child: AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -5 * _floatController.value),
                  child: Transform.scale(
                    scale: 1.0 + (0.02 * _floatController.value),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          center: Alignment(-0.3, -0.3),
                          colors: [
                            Color(0xFFC084FC),
                            Color(0xFF8B5CF6),
                            Color(0xFF3B82F6),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8B5CF6).withValues(alpha: 0.6),
                            blurRadius: 30,
                          ),
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.4),
                            blurRadius: 15,
                            spreadRadius: -5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: _buildAIAudioBars(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Icône AI en haut à droite
          Positioned(
            top: 12,
            right: 12,
            child: const Icon(
              Icons.auto_awesome,
              color: Color(0xFF8B5CF6),
              size: 18,
            ),
          ),
          // Badge "Meeting AI"
          Positioned(
            bottom: 0,
            left: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topRight: Radius.circular(12)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                    border: const Border(
                      top: BorderSide(color: Colors.white24),
                      right: BorderSide(color: Colors.white24),
                    ),
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(12)),
                  ),
                  child: const Text(
                    'Meeting AI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIAudioBars() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildAudioBar(24, 1.5),
            const SizedBox(width: 2),
            _buildAudioBar(40, 1.2),
            const SizedBox(width: 2),
            _buildAudioBar(16, 1.8),
          ],
        );
      },
    );
  }

  Widget _buildAudioBar(double maxHeight, double speed) {
    final animValue = (((_pulseController.value * speed) % 1.0) * 2 - 1).abs();
    return Container(
      width: 4,
      height: maxHeight * (0.4 + 0.6 * animValue),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildParticipantTile(String name, String imageUrl, {bool isMicMuted = false, bool isAvatar = false}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Stack(
        children: [
          if (!isAvatar)
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            )
          else
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 2),
                ),
                child: ClipOval(
                  child: Image.network(imageUrl, fit: BoxFit.cover),
                ),
              ),
            ),
          if (isMicMuted)
            Positioned(
              top: 12,
              left: 12,
              child: Icon(
                Icons.mic_off,
                color: Colors.white.withValues(alpha: 0.4),
                size: 18,
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topRight: Radius.circular(12)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundDark.withValues(alpha: 0.8),
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(12)),
                  ),
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls(AppLocalizations l10n, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            AppTheme.backgroundDark,
            AppTheme.backgroundDark.withValues(alpha: 0.95),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                icon: isMicOn ? Icons.mic : Icons.mic_off,
                onTap: () => setState(() => isMicOn = !isMicOn),
              ),
              _buildControlButton(
                icon: Icons.chat_bubble,
                onTap: () => setState(() => _isChatOpen = !_isChatOpen),
              ),
              _buildControlButton(
                icon: isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                onTap: () => setState(() => isSpeakerOn = !isSpeakerOn),
              ),
              _buildControlButton(
                icon: Icons.flip_camera_ios,
                onTap: () {},
              ),
              _buildEndCallButton(),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            width: 128,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: Colors.white.withValues(alpha: 0.8),
          size: 24,
        ),
      ),
    );
  }

  Widget _buildEndCallButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withValues(alpha: 0.2),
              blurRadius: 12,
            ),
          ],
        ),
        child: const Icon(
          Icons.call_end,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildChatPanel(AppLocalizations l10n, bool isDark) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      bottom: 0,
      left: 0,
      right: 0,
      height: MediaQuery.of(context).size.height * 0.72,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E).withValues(alpha: 0.7),
              border: const Border(
                top: BorderSide(
                  color: Colors.white12,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  width: 48,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                // Liste des messages
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _buildChatMessage(_messages[index], isDark);
                    },
                  ),
                ),
                
                // Quick replies
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildQuickReply('Agree'),
                        const SizedBox(width: 8),
                        _buildQuickReply('Could you repeat?'),
                        const SizedBox(width: 8),
                        _buildQuickReply('Take notes'),
                      ],
                    ),
                  ),
                ),
                
                // Input area
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppTheme.backgroundDark,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _chatController,
                                    style: const TextStyle(color: Colors.white, fontSize: 15),
                                    decoration: InputDecoration(
                                      hintText: 'Type a message...',
                                      hintStyle: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.3),
                                        fontSize: 15,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.sentiment_satisfied,
                                    color: Colors.white.withValues(alpha: 0.4),
                                    size: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF22D3EE),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF22D3EE).withValues(alpha: 0.4),
                                blurRadius: 15,
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () {
                              if (_chatController.text.isNotEmpty) {
                                setState(() {
                                  _messages.add(ChatMessage(
                                    sender: 'You',
                                    message: _chatController.text,
                                    isAI: false,
                                    isMe: true,
                                    time: TimeOfDay.now().format(context),
                                  ));
                                  _chatController.clear();
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.send,
                              color: AppTheme.backgroundDark,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatMessage(ChatMessage message, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!message.isMe) ...[
            Row(
              children: [
                if (message.isAI)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        center: Alignment(-0.3, -0.3),
                        colors: [
                          Color(0xFFC084FC),
                          Color(0xFF8B5CF6),
                          Color(0xFF3B82F6),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B5CF6).withValues(alpha: 0.6),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  )
                else
                  CircleAvatar(
                    radius: 10,
                    backgroundImage: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuDuI-yWwU-2tX8OzQhZPB9WEMyOCRS0i9l0KOeTCek6nW3hMFH0BY6y8Vj_QIQa7ZXhxQUJNf5hMlPs-rTZao2UXB-RptWUmHAuuWd9WbpcOOerDI62W7evT7cLodCAQXsMsZNlCWOzRixGEdePxkRIgvP8bFCHOVrNi8DMJl0V0TNYg_1Vb3mfOH-YeqCzeKFTl58HpALZECclqJ9RZvZf8qk5Ry25jVXHTW22QUX_ub8wtxsmM1i3vREUE3qs0tKhHQDyoMTw7bM',
                    ),
                  ),
                const SizedBox(width: 8),
                Text(
                  message.isAI ? 'MEETING AI' : message.sender,
                  style: TextStyle(
                    color: message.isAI ? const Color(0xFF22D3EE) : Colors.white.withValues(alpha: 0.6),
                    fontSize: 11,
                    fontWeight: message.isAI ? FontWeight.bold : FontWeight.w600,
                    letterSpacing: message.isAI ? 1 : 0,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  message.time,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * (message.isMe ? 0.85 : 0.9),
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: message.isMe
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF7C3AED), Color(0xFF4C1D95)],
                    )
                  : null,
              color: message.isMe
                  ? null
                  : (message.isAI
                      ? const Color(0xFF0F172A).withValues(alpha: 0.6)
                      : Colors.white.withValues(alpha: 0.1)),
              borderRadius: BorderRadius.circular(16).copyWith(
                topLeft: message.isMe ? const Radius.circular(16) : Radius.zero,
                topRight: message.isMe ? Radius.zero : const Radius.circular(16),
              ),
              border: message.isAI
                  ? Border.all(
                      color: const Color(0xFF22D3EE).withValues(alpha: 0.3),
                    )
                  : (message.isMe
                      ? null
                      : Border.all(color: Colors.white.withValues(alpha: 0.05))),
              boxShadow: message.isMe
                  ? [
                      BoxShadow(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : (message.isAI
                      ? [
                          BoxShadow(
                            color: const Color(0xFF22D3EE).withValues(alpha: 0.1),
                            blurRadius: 10,
                          ),
                        ]
                      : []),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.isActionItem) ...[
                  Row(
                    children: [
                      const Icon(
                        Icons.task_alt,
                        color: Color(0xFF22D3EE),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'New Action Item',
                        style: const TextStyle(
                          color: Color(0xFF22D3EE),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
                Text(
                  message.message,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          
          if (message.isMe) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(
                'Read',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickReply(String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _chatController.text = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// Classe pour représenter un message de chat
class ChatMessage {
  final String sender;
  final String message;
  final bool isAI;
  final bool isMe;
  final bool isActionItem;
  final String time;

  ChatMessage({
    required this.sender,
    required this.message,
    this.isAI = false,
    this.isMe = false,
    this.isActionItem = false,
    required this.time,
  });
}
