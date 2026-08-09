import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/colors.dart';
import '../widgets/logo_widget.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final List<String> _phrases = [
    'growthBox',
    'Grow Daily',
    'Level Up',
    'Next Step',
    'Move Forward',
    'Unlock Potential',
  ];

  int _phraseIndex = 0;
  String _currentText = '';
  int _charIndex = 0;
  bool _isDeleting = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTypingAnimation();
  }

  void _startTypingAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 90), (timer) {
      if (!mounted) return;
      final targetWord = _phrases[_phraseIndex];

      setState(() {
        if (!_isDeleting) {
          if (_charIndex < targetWord.length) {
            _charIndex++;
            _currentText = targetWord.substring(0, _charIndex);
          } else {
            _isDeleting = true;
            _timer?.cancel();
            Future.delayed(const Duration(milliseconds: 1800), () {
              if (mounted) _startTypingAnimation();
            });
          }
        } else {
          if (_charIndex > 0) {
            _charIndex--;
            _currentText = targetWord.substring(0, _charIndex);
          } else {
            _isDeleting = false;
            _phraseIndex = (_phraseIndex + 1) % _phrases.length;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _handleLocalLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loginWithLocalStorage();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _showOnlineLoginToast(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Continue with $provider via maniweb API'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LogoWidget(size: 86, showText: false),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currentText,
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.0,
                      ),
                    ),
                    Text(
                      '|',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w300,
                        color: theme.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Manage your notes and todos with AI.\nSimple, fast, and intelligent.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 48),

                // Continue with localStorage button (100% Offline)
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: _handleLocalLogin,
                    icon: const Icon(Icons.offline_bolt, size: 22),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.amber400,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    label: const Text(
                      'Continue with localStorage (100% Offline)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Continue with Google button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () => _showOnlineLoginToast('Google'),
                    icon: const Icon(Icons.g_mobiledata, size: 26),
                    label: const Text(
                      'Continue with Google (Cloud Sync)',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.textTheme.titleLarge?.color,
                      side: BorderSide(color: theme.dividerColor.withOpacity(0.25)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Continue with GitHub button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () => _showOnlineLoginToast('GitHub'),
                    icon: const Icon(Icons.code, size: 20),
                    label: const Text(
                      'Continue with GitHub (Cloud Sync)',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.textTheme.titleLarge?.color,
                      side: BorderSide(color: theme.dividerColor.withOpacity(0.25)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                Text(
                  'growthBox Android v1.0 • 100% Offline Capable & Privacy-First',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
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
