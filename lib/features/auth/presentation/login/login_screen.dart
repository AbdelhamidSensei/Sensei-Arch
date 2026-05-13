import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sensei/features/auth/di/auth_providers.dart';
import 'package:sensei/features/auth/presentation/login/login_ui_state.dart';
import 'package:sensei/features/branch_selection/di/branch_selection_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  final _loginIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginIdFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _obscurePassword = true;

  // Animation controllers
  late final AnimationController _logoController;
  late final AnimationController _formController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoRotate;
  late final Animation<Offset> _formSlide;
  late final Animation<double> _formFade;

  @override
  void initState() {
    super.initState();

    // Logo: scale up + gentle rotation on entry
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _logoScale = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );
    _logoRotate = Tween<double>(begin: -0.05, end: 0.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    // Form: slide up + fade in
    _formController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _formSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _formController,
      curve: Curves.easeOutCubic,
    ));
    _formFade = CurvedAnimation(
      parent: _formController,
      curve: Curves.easeIn,
    );

    // Stagger: logo first, then form
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _formController.forward();
    });
  }

  @override
  void dispose() {
    _loginIdController.dispose();
    _passwordController.dispose();
    _loginIdFocus.dispose();
    _passwordFocus.dispose();
    _logoController.dispose();
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginViewModelProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen<LoginUiState>(loginViewModelProvider, (prev, next) {
      if (next.user != null && prev?.user == null) {
        ref.read(currentUserProvider.notifier).state = next.user;
        context.go('/branch-selection');
      }
      if (next.errorMessage != null &&
          prev?.errorMessage != next.errorMessage) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Row(
              children: [
                Icon(Icons.error_outline, color: Color(0xFFB20018), size: 28),
                SizedBox(width: 10),
                Text('Login Failed',
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            content: Text(next.errorMessage!,
                style: const TextStyle(fontSize: 15, height: 1.4)),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFB20018),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        );
      }
    });

    if (state.isCheckingSession) {
      return Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: const Color(0xFFB20018),
            backgroundColor:
                isDark ? Colors.white12 : const Color(0xFFB20018).withOpacity(0.15),
          ),
        ),
      );
    }

    // Background color: dark theme = black gradient, light theme = soft white
    final bgGradient = isDark
        ? const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A0005), Color(0xFF000000)],
          )
        : const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8F0F1), Color(0xFFFFFFFF)],
          );

    return Scaffold(
      body: Stack(
        children: [
          // ── Background gradient + curved top shape ──
          Container(
            decoration: BoxDecoration(gradient: bgGradient),
          ),
          // Curved red header shape
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.35,
            child: ClipPath(
              clipper: _CurvedClipper(),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFD50020), Color(0xFF8E0000)],
                  ),
                ),
              ),
            ),
          ),

          // ── Content ──
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // ── Animated Logo Card ──
                    ScaleTransition(
                      scale: _logoScale,
                      child: AnimatedBuilder(
                        animation: _logoRotate,
                        builder: (context, child) => Transform.rotate(
                          angle: _logoRotate.value * math.pi,
                          child: child,
                        ),
                        child: Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFB20018).withOpacity(0.3),
                                blurRadius: 30,
                                spreadRadius: 2,
                                offset: const Offset(0, 10),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'IDH',
                              style: TextStyle(
                                fontSize: 44,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFB20018),
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                    // Subtitle
                    Text(
                      'LinkageApp',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white54 : Colors.black45,
                        letterSpacing: 3,
                      ),
                    ),

                    const SizedBox(height: 36),

                    // ── Animated Form Card ──
                    SlideTransition(
                      position: _formSlide,
                      child: FadeTransition(
                        opacity: _formFade,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E1E1E)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? Colors.black45
                                    : Colors.black.withOpacity(0.08),
                                blurRadius: 30,
                                spreadRadius: 0,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Welcome Back',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Sign in to continue',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        isDark ? Colors.white38 : Colors.black38,
                                  ),
                                ),
                                const SizedBox(height: 28),

                                // Login ID field — rounded bubble style
                                _buildTextField(
                                  controller: _loginIdController,
                                  focusNode: _loginIdFocus,
                                  label: 'Login ID',
                                  icon: Icons.badge_outlined,
                                  isDark: isDark,
                                  textInputAction: TextInputAction.next,
                                  onSubmitted: (_) =>
                                      _passwordFocus.requestFocus(),
                                ),
                                const SizedBox(height: 16),

                                // Password field — rounded bubble style with toggle
                                _buildTextField(
                                  controller: _passwordController,
                                  focusNode: _passwordFocus,
                                  label: 'Password',
                                  icon: Icons.lock_outline_rounded,
                                  isDark: isDark,
                                  obscure: _obscurePassword,
                                  textInputAction: TextInputAction.done,
                                  onSubmitted: (_) => _onLogin(),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_rounded
                                          : Icons.visibility_rounded,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    onPressed: () => setState(
                                        () => _obscurePassword = !_obscurePassword),
                                  ),
                                ),
                                const SizedBox(height: 28),

                                // Login button — pill shape with gradient
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(26),
                                      gradient: state.isLoading
                                          ? LinearGradient(
                                              colors: [
                                                Colors.grey.shade400,
                                                Colors.grey.shade500,
                                              ],
                                            )
                                          : const LinearGradient(
                                              colors: [
                                                Color(0xFFD50020),
                                                Color(0xFFB20018),
                                              ],
                                            ),
                                      boxShadow: state.isLoading
                                          ? []
                                          : [
                                              BoxShadow(
                                                color: const Color(0xFFB20018)
                                                    .withOpacity(0.4),
                                                blurRadius: 16,
                                                offset: const Offset(0, 6),
                                              ),
                                            ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed:
                                          state.isLoading ? null : _onLogin,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(26),
                                        ),
                                      ),
                                      child: const Text(
                                        'Sign In',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
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

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),

          // ── Full-screen loading overlay ──
          if (state.isLoading)
            AnimatedOpacity(
              opacity: state.isLoading ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                color: Colors.black.withOpacity(0.6),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 52,
                          height: 52,
                          child: CircularProgressIndicator(
                            strokeWidth: 3.5,
                            color: Color(0xFFB20018),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Signing in...',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white70 : Colors.black54,
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

  // ── Reusable rounded "bubble" text field ──
  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required IconData icon,
    required bool isDark,
    bool obscure = false,
    TextInputAction? textInputAction,
    ValueChanged<String>? onSubmitted,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscure,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      style: TextStyle(
        fontSize: 15,
        color: isDark ? Colors.white : Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDark ? Colors.white38 : Colors.black38,
          fontSize: 14,
        ),
        prefixIcon: Icon(icon,
            color: const Color(0xFFB20018).withOpacity(0.7), size: 22),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: isDark
            ? Colors.white.withOpacity(0.06)
            : const Color(0xFFF5F5F7),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFB20018),
            width: 1.5,
          ),
        ),
      ),
    );
  }

  void _onLogin() {
    final loginId = _loginIdController.text.trim();
    final password = _passwordController.text.trim();
    if (loginId.isEmpty || password.isEmpty) return;
    ref.read(loginViewModelProvider.notifier).login(loginId, password);
  }
}

// Custom clipper for the curved red header shape
class _CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 1.15,
      size.width,
      size.height * 0.7,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
