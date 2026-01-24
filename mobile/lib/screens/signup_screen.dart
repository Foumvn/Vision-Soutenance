import 'dart:math';
import 'package:flutter/material.dart';
import 'widgets/glass_input_field.dart';
import 'widgets/neon_button.dart';
import 'widgets/social_login_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with SingleTickerProviderStateMixin {
  late AnimationController _auroraController;

  @override
  void initState() {
    super.initState();
    _auroraController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _auroraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0A0F),
      body: Stack(
        children: [
          // Aurora Background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _auroraController,
              builder: (context, child) {
                return CustomPaint(
                  painter: AuroraPainter(progress: _auroraController.value),
                );
              },
            ),
          ),
          
          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Back Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                      ),
                      child: const Icon(Icons.chevron_left, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Title
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Join the next generation of AI-powered video conferencing.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Form Fields
                  const GlassInputField(
                    label: 'Full Name',
                    hintText: 'John Doe',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 20),
                  const GlassInputField(
                    label: 'Email Address',
                    hintText: 'john@example.com',
                    icon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  const GlassInputField(
                    label: 'Password',
                    hintText: '••••••••',
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),
                  const SizedBox(height: 32),
                  
                  // Sign Up Button
                  NeonButton(
                    text: 'Create Account',
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                  ),
                  const SizedBox(height: 40),
                  
                  // Divider
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.white.withOpacity(0.1), Colors.transparent],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'OR CONTINUE WITH',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.white.withOpacity(0.1), Colors.transparent],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Social Buttons
                  Row(
                    children: [
                      Expanded(
                        child: SocialLoginButton(
                          icon: Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
                            height: 20,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, color: Colors.blue, size: 30),
                          ),
                          label: 'Google',
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SocialLoginButton(
                          icon: const Icon(Icons.apple, color: Colors.white, size: 24),
                          label: 'Apple',
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  
                  // Footer
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigate to login
                          },
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              color: Color(0xFF00F0FF),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Bottom Indicator
                  Center(
                    child: Container(
                      width: 120,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuroraPainter extends CustomPainter {
  final double progress;

  AuroraPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);

    // Purple Aura (Top Left-ish)
    final purplePath = Path();
    double pX = size.width * (0.2 + 0.1 * sin(progress * 2 * pi));
    double pY = size.height * (0.2 + 0.1 * cos(progress * 2 * pi));
    canvas.drawCircle(
      Offset(pX, pY),
      size.width * 0.8,
      paint..color = const Color(0xFF8B5CF6).withOpacity(0.15),
    );

    // Pink/Blue Aura (Bottom Right-ish)
    double bX = size.width * (0.8 + 0.1 * cos(progress * 2 * pi));
    double bY = size.height * (0.8 + 0.1 * sin(progress * 2 * pi));
    canvas.drawCircle(
      Offset(bX, bY),
      size.width * 0.8,
      paint..color = const Color(0xFFEC4899).withOpacity(0.1),
    );
  }

  @override
  bool shouldRepaint(covariant AuroraPainter oldDelegate) => oldDelegate.progress != progress;
}
