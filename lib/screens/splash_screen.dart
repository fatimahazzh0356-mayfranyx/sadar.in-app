import 'dart:async';
import 'package:flutter/material.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _blobController;

  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _slideAnimation;

  late final Animation<double> _textFadeAnimation;
  late final Animation<Offset> _textSlideAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _blobController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.78, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeOutBack,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeOutCubic,
      ),
    );

    _textFadeAnimation = CurvedAnimation(
      parent: _logoController,
      curve: const Interval(
        0.45,
        1.0,
        curve: Curves.easeOut,
      ),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(
          0.45,
          1.0,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _logoController.forward();

    Timer(const Duration(milliseconds: 2400), () async {
      if (!mounted) return;

      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 650),
          pageBuilder: (_, animation, __) {
            return FadeTransition(
              opacity: animation,
              child: isLoggedIn ? const MainShell() : const AuthScreen(),
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _blobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = SizeConfig(context);

    return Scaffold(
      body: Stack(
        children: [
          const _GradientBackground(),
          _FloatingBlob(
            controller: _blobController,
            top: -70,
            right: -60,
            size: 210,
            color: AppColors.softPink,
          ),
          _FloatingBlob(
            controller: _blobController,
            bottom: -80,
            left: -70,
            size: 240,
            color: AppColors.cyan,
            reverse: true,
          ),
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.55),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.pink.withOpacity(0.22),
                              blurRadius: 35,
                              offset: const Offset(0, 16),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/logo/sadarin_logo.png',
                          width: size.isTablet ? 140 : 112,
                          height: size.isTablet ? 140 : 112,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 22),
                      FadeTransition(
                        opacity: _textFadeAnimation,
                        child: SlideTransition(
                          position: _textSlideAnimation,
                          child: Text(
                            'Sadar.in',
                            style: TextStyle(
                              fontFamily: 'Chillax',
                              fontSize: size.responsiveFont(36, tablet: 46),
                              fontWeight: FontWeight.w800,
                              color: AppColors.pink,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientBackground extends StatelessWidget {
  const _GradientBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF7F7),
            Color(0xFFFFE6ED),
            Color(0xFFEAFBFD),
          ],
        ),
      ),
    );
  }
}

class _FloatingBlob extends StatelessWidget {
  final AnimationController controller;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double size;
  final Color color;
  final bool reverse;

  const _FloatingBlob({
    required this.controller,
    required this.size,
    required this.color,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final move = reverse ? -18 * controller.value : 18 * controller.value;

        return Positioned(
          top: top == null ? null : top! + move,
          bottom: bottom == null ? null : bottom! + move,
          left: left,
          right: right,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.24),
            ),
          ),
        );
      },
    );
  }
}