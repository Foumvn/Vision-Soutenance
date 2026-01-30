import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'widgets/glass_input_field.dart';
import 'widgets/neon_button.dart';
import 'widgets/social_login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _auroraController;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Please check your credentials.')),
      );
    }
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
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Log in to access your AI-powered meetings.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  GlassInputField(
                    label: 'Email Address',
                    hintText: 'john@example.com',
                    icon: Icons.mail_outline,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  GlassInputField(
                    label: 'Password',
                    hintText: '••••••••',
                    icon: Icons.lock_outline,
                    controller: _passwordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: 32),
                  
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) {
                      return NeonButton(
                        text: auth.isLoading ? 'Logging in...' : 'Log In',
                        onPressed: auth.isLoading ? () {} : _handleLogin,
                      );
                    },
                  ),
                  
                  const SizedBox(height: 40),
                  
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/signup'),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Color(0xFFF97316),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
      paint..color = const Color(0xFFF97316).withOpacity(0.15),
    );

    // Pink/Blue Aura (Bottom Right-ish)
    double bX = size.width * (0.8 + 0.1 * cos(progress * 2 * pi));
    double bY = size.height * (0.8 + 0.1 * sin(progress * 2 * pi));
    canvas.drawCircle(
      Offset(bX, bY),
      size.width * 0.8,
      paint..color = const Color(0xFFFB923C).withOpacity(0.1),
    );
  }

  @override
  bool shouldRepaint(covariant AuroraPainter oldDelegate) => oldDelegate.progress != progress;
}
