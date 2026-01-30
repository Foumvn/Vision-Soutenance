import 'package:flutter/material.dart';

class NeonButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color baseColor;
  final Color glowColor;

  const NeonButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.baseColor = const Color(0xFFF97316),
    this.glowColor = const Color(0xFFF97316),
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onPressed();
        },
        onTapCancel: () => _controller.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 64,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _isHovered ? Color.alphaBlend(Colors.white.withOpacity(0.1), widget.baseColor) : widget.baseColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: widget.glowColor.withOpacity(_isHovered ? 0.6 : 0.4),
                  blurRadius: _isHovered ? 30 : 20,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Shimmer effect
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _ShimmerOverlay(isHovered: _isHovered),
                  ),
                ),
                Center(
                  child: Text(
                    widget.text,
                    style: const TextStyle(
                      color: Color(0xFF0B0A0F),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
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
}

class _ShimmerOverlay extends StatefulWidget {
  final bool isHovered;
  const _ShimmerOverlay({required this.isHovered});

  @override
  State<_ShimmerOverlay> createState() => _ShimmerOverlayState();
}

class _ShimmerOverlayState extends State<_ShimmerOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return FractionalTranslation(
          translation: Offset(-1.0 + (_shimmerController.value * 3.0), 0),
          child: Transform.rotate(
            angle: -0.3,
            child: Container(
              width: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0),
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
