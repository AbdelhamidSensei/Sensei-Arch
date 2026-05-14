import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sensei/core/widgets/shipping_loading.dart';
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

  // Entry animations
  late final AnimationController _headerSlideController;
  late final AnimationController _logoController;
  late final AnimationController _formController;
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoRotate;
  late final Animation<Offset> _formSlide;
  late final Animation<double> _formFade;

  // ── Easter egg state ──
  int _logoTapCount = 0;
  bool _easterEggActive = false;
  double _logoPopScale = 1.0;
  double _explodeScale = 1.0;
  double _explodeOpacity = 1.0;
  double _explodeRotation = 0.0;
  double _logoShake = 0.0;

  AnimationController? _popController;
  AnimationController? _shurikenController;
  AnimationController? _kunaiController;
  AnimationController? _flashController;
  AnimationController? _explodeController;
  AnimationController? _reassembleController;
  AnimationController? _emberController;

  // Phase 1: 30 shurikens that fly in and STICK
  List<_ShurikenData> _shurikens = [];
  // Tracks how many have landed (0..1 progress per shuriken)
  bool _showShurikens = false;

  // Phase 2: Kunai with paper tag
  bool _showKunai = false;

  // Phase 3: Cinematic explosion
  double _flashOpacity = 0.0;
  bool _showExplosion = false;
  double _screenShakeX = 0.0;
  double _screenShakeY = 0.0;
  AnimationController? _shakeController;

  // Explosion layers
  List<_FireParticle> _fireParticles = [];
  List<_SmokeParticle> _smokeParticles = [];
  List<_SparkParticle> _sparkParticles = [];
  List<_ShockwaveRing> _shockwaves = [];
  List<_DebrisData> _debris = [];
  bool _showStuckDebris = false;
  bool _showEmbers = false;
  List<_EmberParticle> _embers = [];

  @override
  void initState() {
    super.initState();

    _headerSlideController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _headerSlideController, curve: Curves.easeOutCubic));

    _logoController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _logoScale = CurvedAnimation(
        parent: _logoController, curve: Curves.elasticOut);
    _logoRotate = Tween<double>(begin: -0.05, end: 0.0).animate(
        CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack));

    _formController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _formSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _formController, curve: Curves.easeOutCubic));
    _formFade =
        CurvedAnimation(parent: _formController, curve: Curves.easeIn);

    _headerSlideController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _logoController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _formController.forward();
    });
  }

  @override
  void dispose() {
    _loginIdController.dispose();
    _passwordController.dispose();
    _loginIdFocus.dispose();
    _passwordFocus.dispose();
    _headerSlideController.dispose();
    _logoController.dispose();
    _formController.dispose();
    _popController?.dispose();
    _shurikenController?.dispose();
    _kunaiController?.dispose();
    _flashController?.dispose();
    _explodeController?.dispose();
    _reassembleController?.dispose();
    _shakeController?.dispose();
    _emberController?.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════
  //  EASTER EGG — TAP HANDLER
  // ═══════════════════════════════════════════════════════════════

  void _onLogoTap() {
    if (_easterEggActive) return;
    _logoTapCount++;

    if (_logoTapCount < 5) {
      _popController?.dispose();
      _popController = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 300));
      _popController!.addListener(() {
        final t = _popController!.value;
        setState(() {
          _logoPopScale =
              1.0 + 0.25 * math.sin(t * math.pi) * (1 - t * 0.3);
        });
      });
      _popController!.addStatusListener((s) {
        if (s == AnimationStatus.completed) setState(() => _logoPopScale = 1.0);
      });
      _popController!.forward(from: 0);
    } else {
      _logoTapCount = 0;
      _startNinjaAttack();
    }
  }

  // ═══════════════════════════════════════════════════════════════
  //  PHASE 1: 30 SHURIKENS FLY IN WAVES AND STICK
  // ═══════════════════════════════════════════════════════════════

  void _startNinjaAttack() {
    setState(() => _easterEggActive = true);

    final rng = math.Random();
    // 30 shurikens from random directions, staggered
    _shurikens = List.generate(30, (i) {
      final angle = rng.nextDouble() * 2 * math.pi;
      final dist = 350.0 + rng.nextDouble() * 150;
      // Where they stick on the logo (random offset from center, within ~60px)
      final stickX = (rng.nextDouble() - 0.5) * 120;
      final stickY = (rng.nextDouble() - 0.5) * 120;
      final stickAngle = rng.nextDouble() * 2 * math.pi;
      return _ShurikenData(
        startX: math.cos(angle) * dist,
        startY: math.sin(angle) * dist,
        stickX: stickX,
        stickY: stickY,
        stickAngle: stickAngle,
        spinSpeed: 3 + rng.nextDouble() * 6,
        // Stagger: 30 shurikens over ~1.5s in 3 waves
        delay: (i ~/ 10) * 0.25 + (i % 10) * 0.02,
      );
    });

    _shurikenController?.dispose();
    _shurikenController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    setState(() => _showShurikens = true);
    _shurikenController!.addListener(() {
      // Shake the logo when shurikens hit
      final t = _shurikenController!.value;
      setState(() {
        _logoShake = math.sin(t * 60) * 3 * (t < 0.8 ? t : (1 - t) * 5);
      });
    });
    _shurikenController!.forward().then((_) {
      setState(() => _logoShake = 0);
      // Brief pause to admire stuck shurikens, then kunai
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) _throwKunai();
      });
    });
  }

  // ═══════════════════════════════════════════════════════════════
  //  PHASE 2: KUNAI WITH EXPLOSIVE TAG FLIES IN
  // ═══════════════════════════════════════════════════════════════

  void _throwKunai() {
    _kunaiController?.dispose();
    _kunaiController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    setState(() => _showKunai = true);
    _kunaiController!.addListener(() => setState(() {}));
    _kunaiController!.forward().then((_) {
      // Kunai has landed → flash then explode
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _detonateExplosiveTag();
      });
    });
  }

  // ═══════════════════════════════════════════════════════════════
  //  PHASE 3: PAPER TAG BURNS → WHITE FLASH → MASSIVE EXPLOSION
  // ═══════════════════════════════════════════════════════════════

  void _detonateExplosiveTag() {
    final rng = math.Random();

    // 1) Bright white flash
    _flashController?.dispose();
    _flashController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _flashController!.addListener(() {
      final t = _flashController!.value;
      setState(() {
        // Quick flash: ramps to 1.0 at 30%, holds, fades
        if (t < 0.3) {
          _flashOpacity = t / 0.3;
        } else {
          _flashOpacity = 1.0 - ((t - 0.3) / 0.7);
        }
      });
    });
    _flashController!.forward().then((_) {
      setState(() {
        _flashOpacity = 0;
        _showKunai = false;
        _showShurikens = false;
        _showExplosion = true;
        _showStuckDebris = true;
      });
      _startCinematicExplosion(rng);
    });
  }

  void _startCinematicExplosion(math.Random rng) {
    // ── Generate all particle layers ──

    // Layer 1: Shockwave rings (3 expanding rings)
    _shockwaves = List.generate(3, (i) => _ShockwaveRing(
      delay: i * 0.12,
      maxRadius: 180.0 + i * 60,
      strokeWidth: 4.0 - i * 1.0,
      color: i == 0
          ? Colors.white
          : i == 1
              ? const Color(0xFFFFAA00)
              : const Color(0xFFFF4400),
    ));

    // Layer 2: Inner fire (bright, fast, small radius)
    _fireParticles = List.generate(18, (i) {
      final angle = rng.nextDouble() * 2 * math.pi;
      final speed = 60.0 + rng.nextDouble() * 140;
      return _FireParticle(
        dx: math.cos(angle) * speed,
        dy: math.sin(angle) * speed,
        startSize: 20 + rng.nextDouble() * 30,
        growFactor: 1.5 + rng.nextDouble(),
        delay: rng.nextDouble() * 0.15,
      );
    });

    // Layer 3: Outer smoke (dark, slower, bigger, drifts up)
    _smokeParticles = List.generate(12, (i) {
      final angle = rng.nextDouble() * 2 * math.pi;
      final speed = 40.0 + rng.nextDouble() * 100;
      return _SmokeParticle(
        dx: math.cos(angle) * speed,
        dy: math.sin(angle) * speed - 30, // drift up
        maxSize: 40 + rng.nextDouble() * 60,
        delay: 0.1 + rng.nextDouble() * 0.2,
      );
    });

    // Layer 4: Sparks (thin, fast, long trails)
    _sparkParticles = List.generate(30, (i) {
      final angle = rng.nextDouble() * 2 * math.pi;
      final speed = 150.0 + rng.nextDouble() * 350;
      return _SparkParticle(
        dx: math.cos(angle) * speed,
        dy: math.sin(angle) * speed,
        length: 8 + rng.nextDouble() * 16,
        angle: angle,
        color: [
          const Color(0xFFFFDD00),
          const Color(0xFFFFAA00),
          const Color(0xFFFF6600),
          Colors.white,
        ][rng.nextInt(4)],
      );
    });

    // Layer 5: Debris (stuck shurikens blown away)
    _debris = _shurikens.map((s) {
      final angle = rng.nextDouble() * 2 * math.pi;
      final speed = 200.0 + rng.nextDouble() * 300;
      return _DebrisData(
        dx: math.cos(angle) * speed,
        dy: math.sin(angle) * speed,
        rotation: rng.nextDouble() * 10 * math.pi,
        startX: s.stickX,
        startY: s.stickY,
      );
    }).toList();

    // ── Screen shake (separate lightweight ticker) ──
    _shakeController?.dispose();
    _shakeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _shakeController!.addListener(_updateShake);
    _shakeController!.forward();

    // ── Main explosion controller — drives CustomPainter + logo ──
    _explodeController?.dispose();
    _explodeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _explodeController!.addListener(_updateExplosion);
    _explodeController!.forward().then((_) {
      setState(() {
        _showExplosion = false;
        _showStuckDebris = false;
        _screenShakeX = 0;
        _screenShakeY = 0;
        _explodeOpacity = 0.0;
        _showEmbers = true;
      });
      _startEmbers(rng);
    });
  }

  void _updateShake() {
    final t = _shakeController!.value;
    final intensity = 10.0 * (1.0 - t);
    _screenShakeX = math.sin(t * 45) * intensity;
    _screenShakeY = math.cos(t * 37) * intensity * 0.7;
    // Don't call setState here — _updateExplosion handles it
  }

  void _updateExplosion() {
    final t = _explodeController!.value;
    _explodeScale = 1.0 + t * 2.5;
    _explodeOpacity = (1.0 - t * 2.5).clamp(0.0, 1.0);
    _explodeRotation = t * 4 * math.pi;
    setState(() {}); // Single setState drives logo + painter + shake
  }

  // Lingering embers that float down after explosion
  void _startEmbers(math.Random rng) {
    _embers = List.generate(15, (i) {
      return _EmberParticle(
        startX: (rng.nextDouble() - 0.5) * 300,
        startY: (rng.nextDouble() - 0.5) * 200 - 50,
        driftX: (rng.nextDouble() - 0.5) * 40,
        fallSpeed: 30 + rng.nextDouble() * 60,
        flickerSpeed: 3 + rng.nextDouble() * 5,
        size: 3 + rng.nextDouble() * 5,
      );
    });

    // Drive ember repaints for 2 seconds then clean up
    _emberController?.dispose();
    _emberController = AnimationController(
        vsync: this, duration: const Duration(seconds: 2));
    _emberController!.addListener(() => setState(() {}));
    _emberController!.forward().then((_) {
      if (mounted) {
        setState(() {
          _showEmbers = false;
          _embers = [];
        });
        _reassembleLogo();
      }
    });
  }

  // ═══════════════════════════════════════════════════════════════
  //  PHASE 4: LOGO REASSEMBLES + TOAST
  // ═══════════════════════════════════════════════════════════════

  void _reassembleLogo() {
    _reassembleController?.dispose();
    _reassembleController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _reassembleController!.addListener(() {
      final t =
          Curves.elasticOut.transform(_reassembleController!.value);
      setState(() {
        _explodeScale = 1.0;
        _explodeOpacity = t;
        _explodeRotation = 0;
        _logoPopScale = 1.0;
      });
    });
    _reassembleController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _easterEggActive = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('~ Abdelhamid Ramadan ~',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1)),
                ],
              ),
              backgroundColor: const Color(0xFFB20018),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              margin:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    });
    _reassembleController!.forward();
  }

  // ═══════════════════════════════════════════════════════════════
  //  BUILD
  // ═══════════════════════════════════════════════════════════════

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
                borderRadius: BorderRadius.circular(20)),
            title: const Row(children: [
              Icon(Icons.error_outline, color: Color(0xFFB20018), size: 28),
              SizedBox(width: 10),
              Text('Login Failed',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ]),
            content: Text(next.errorMessage!,
                style: const TextStyle(fontSize: 15, height: 1.4)),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFB20018),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
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
        body: const Center(child: ShippingLoading(message: 'Loading...')),
      );
    }

    final bgGradient = isDark
        ? const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A0005), Color(0xFF000000)])
        : const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8F0F1), Color(0xFFFFFFFF)]);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Transform.translate(
        offset: Offset(_screenShakeX, _screenShakeY),
        child: Stack(
        children: [
          Container(decoration: BoxDecoration(gradient: bgGradient)),

          // Sliding red header
          SlideTransition(
            position: _headerSlide,
            child: Positioned(
              top: 0, left: 0, right: 0,
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
          ),

          // Content — keyboard-aware
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
                final isKeyboardOpen = keyboardHeight > 50;

                return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: AnimatedPadding(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutCubic,
                      padding: EdgeInsets.only(
                        top: isKeyboardOpen ? 10 : constraints.maxHeight * 0.12,
                      ),
                      child: Column(
                        children: [
                          // Logo — smoothly hides when keyboard opens
                          AnimatedSize(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: isKeyboardOpen ? 0.0 : 1.0,
                              child: SizedBox(
                                height: isKeyboardOpen ? 0 : null,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: _onLogoTap,
                                      child: ScaleTransition(
                                        scale: _logoScale,
                                        child: AnimatedBuilder(
                                          animation: _logoRotate,
                                          builder: (context, child) =>
                                              Transform.rotate(
                                            angle: _logoRotate.value * math.pi,
                                            child: child,
                                          ),
                                          child: Transform.translate(
                                            offset: Offset(_logoShake, 0),
                                            child: _buildLogoWithEffects(isDark),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text('LinkageApp',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: isDark
                                              ? Colors.white54
                                              : Colors.black45,
                                          letterSpacing: 3,
                                        )),
                                    const SizedBox(height: 36),
                                  ],
                                ),
                              ),
                            ),
                          ),

                      SlideTransition(
                        position: _formSlide,
                        child: FadeTransition(
                          opacity: _formFade,
                          child: _buildFormCard(state, isDark),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
                );
              },
            ),
          ),

          // ── Shuriken overlays (flying + stuck) ──
          if (_showShurikens) ..._buildShurikens(),

          // ── Kunai overlay ──
          if (_showKunai) _buildKunai(),

          // ── Explosion (single painter for performance) ──
          if (_showExplosion || _showStuckDebris || _showEmbers)
            Positioned.fill(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _ExplosionPainter(
                    progress: _explodeController?.value ?? 0.0,
                    center: Offset(
                      MediaQuery.of(context).size.width / 2,
                      MediaQuery.of(context).size.height * 0.32,
                    ),
                    shockwaves: _showExplosion ? _shockwaves : [],
                    fireParticles: _showExplosion ? _fireParticles : [],
                    smokeParticles: _showExplosion ? _smokeParticles : [],
                    sparkParticles: _showExplosion ? _sparkParticles : [],
                    debris: _showStuckDebris ? _debris : [],
                    embers: _showEmbers ? _embers : [],
                    showEmbers: _showEmbers,
                    time: DateTime.now().millisecondsSinceEpoch / 1000.0,
                  ),
                ),
              ),
            ),

          // ── Flash (white in light mode, warm orange in dark mode) ──
          if (_flashOpacity > 0)
            IgnorePointer(
              child: Container(
                color: (isDark ? const Color(0xFFFF8800) : Colors.white)
                    .withOpacity(_flashOpacity.clamp(0.0, 1.0)),
              ),
            ),

          // ── Loading overlay ──
          if (state.isLoading)
            Container(
              color: Colors.black.withOpacity(0.6),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0A0A0A) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2), blurRadius: 30),
                    ],
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const ShippingLoading(size: 48),
                    const SizedBox(height: 12),
                    Text('Signing in...',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white70 : Colors.black54,
                        )),
                  ]),
                ),
              ),
            ),
        ],
      ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  WIDGET BUILDERS
  // ═══════════════════════════════════════════════════════════════

  Widget _buildLogoWithEffects(bool isDark) {
    return Transform.scale(
      scale: _logoPopScale * _explodeScale,
      child: Transform.rotate(
        angle: _explodeRotation,
        child: Opacity(
          opacity: _explodeOpacity.clamp(0.0, 1.0),
          child: Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0A0A0A) : Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? const Color(0xFFB20018).withOpacity(0.2)
                      : const Color(0xFFB20018).withOpacity(0.3),
                  blurRadius: 30, spreadRadius: 2,
                  offset: const Offset(0, 10)),
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.5 : 0.1),
                  blurRadius: 15, offset: const Offset(0, 5)),
              ],
            ),
            child: const Center(
              child: Text('IDH',
                  style: TextStyle(
                    fontSize: 44, fontWeight: FontWeight.w900,
                    color: Color(0xFFB20018), letterSpacing: 2)),
            ),
          ),
        ),
      ),
    );
  }

  // Shurikens: flying in → then stuck on logo
  List<Widget> _buildShurikens() {
    final screenSize = MediaQuery.of(context).size;
    final centerX = screenSize.width / 2;
    final centerY = screenSize.height * 0.32;
    final progress = _shurikenController?.value ?? 0.0;

    return _shurikens.map((s) {
      // Each shuriken has its own timing
      final shurikenTime = ((progress * 2 - s.delay) / (1 - s.delay))
          .clamp(0.0, 1.0);

      if (shurikenTime <= 0) return const SizedBox.shrink();

      final hasLanded = shurikenTime >= 1.0;
      final flyProgress = hasLanded ? 1.0 : Curves.easeInQuad.transform(shurikenTime);

      // Flying: from startX/Y to stickX/Y
      final x = hasLanded
          ? centerX + s.stickX - 15
          : centerX + s.startX * (1 - flyProgress) + s.stickX * flyProgress - 15;
      final y = hasLanded
          ? centerY + s.stickY - 15
          : centerY + s.startY * (1 - flyProgress) + s.stickY * flyProgress - 15;

      // Spin while flying, stop when stuck
      final rotation =
          hasLanded ? s.stickAngle : s.spinSpeed * shurikenTime * math.pi;

      return Positioned(
        left: x, top: y,
        child: Transform.rotate(
          angle: rotation,
          child: const SizedBox(
            width: 30, height: 30,
            child: _ShurikenWidget(),
          ),
        ),
      );
    }).toList();
  }

  // Kunai with explosive paper tag flying from top-right
  Widget _buildKunai() {
    final screenSize = MediaQuery.of(context).size;
    final centerX = screenSize.width / 2;
    final centerY = screenSize.height * 0.32;
    final progress = _kunaiController?.value ?? 0.0;
    final eased = Curves.easeInCubic.transform(progress);

    // Fly from top-right corner to logo center
    final startX = screenSize.width + 50;
    final startY = -50.0;
    final x = startX + (centerX - startX) * eased - 25;
    final y = startY + (centerY - startY) * eased - 25;

    // Rotate to point toward center
    final angle = math.atan2(centerY - startY, centerX - startX);

    return Positioned(
      left: x, top: y,
      child: Transform.rotate(
        angle: angle + math.pi / 4,
        child: const SizedBox(width: 50, height: 50, child: _KunaiWidget()),
      ),
    );
  }

  // Debris: stuck shurikens blown away
  List<Widget> _buildDebris() {
    final screenSize = MediaQuery.of(context).size;
    final centerX = screenSize.width / 2;
    final centerY = screenSize.height * 0.32;
    final progress = _explodeController?.value ?? 0.0;
    final eased = Curves.easeOut.transform(progress);
    final opacity = (1.0 - progress * 1.3).clamp(0.0, 1.0);

    return _debris.map((d) {
      final x = centerX + d.startX + d.dx * eased - 15;
      final y = centerY + d.startY + d.dy * eased - 15;
      return Positioned(
        left: x, top: y,
        child: Opacity(
          opacity: opacity,
          child: Transform.rotate(
            angle: d.rotation * eased,
            child: const SizedBox(
                width: 20, height: 20, child: _ShurikenWidget()),
          ),
        ),
      );
    }).toList();
  }


  // ── Form card ──
  Widget _buildFormCard(LoginUiState state, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0A0A0A) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? const Color(0xFFB20018).withOpacity(0.15)
                : Colors.black.withOpacity(0.08),
            blurRadius: 30, offset: const Offset(0, 12)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Welcome Back',
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87)),
          const SizedBox(height: 6),
          Text('Sign in to continue',
              style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white38 : Colors.black38)),
          const SizedBox(height: 28),
          _buildTextField(
            controller: _loginIdController, focusNode: _loginIdFocus,
            label: 'Login ID', icon: Icons.badge_outlined, isDark: isDark,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => _passwordFocus.requestFocus()),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _passwordController, focusNode: _passwordFocus,
            label: 'Password', icon: Icons.lock_outline_rounded, isDark: isDark,
            obscure: _obscurePassword,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _onLogin(),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: Colors.grey, size: 20),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword))),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity, height: 52,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: state.isLoading
                    ? LinearGradient(
                        colors: [Colors.grey.shade400, Colors.grey.shade500])
                    : const LinearGradient(
                        colors: [Color(0xFFD50020), Color(0xFFB20018)]),
                boxShadow: state.isLoading
                    ? []
                    : [BoxShadow(
                        color: const Color(0xFFB20018).withOpacity(0.4),
                        blurRadius: 16, offset: const Offset(0, 6))],
              ),
              child: ElevatedButton(
                onPressed: state.isLoading ? null : _onLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26))),
                child: const Text('Sign In',
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w600,
                        letterSpacing: 0.5)),
              ),
            ),
          ),
        ]),
      ),
    );
  }

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
      controller: controller, focusNode: focusNode, obscureText: obscure,
      textInputAction: textInputAction, onSubmitted: onSubmitted,
      style: TextStyle(
          fontSize: 15, color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            color: isDark ? Colors.white38 : Colors.black38, fontSize: 14),
        prefixIcon: Icon(icon,
            color: const Color(0xFFB20018).withOpacity(0.7), size: 22),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: isDark
            ? Colors.white.withOpacity(0.04)
            : const Color(0xFFF5F5F7),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                const BorderSide(color: Color(0xFFB20018), width: 1.5)),
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

// ═══════════════════════════════════════════════════════════════
//  CUSTOM PAINTERS
// ═══════════════════════════════════════════════════════════════

// Shuriken (4-point ninja star)
class _ShurikenWidget extends StatelessWidget {
  const _ShurikenWidget();
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _ShurikenPainter(), size: Size.infinite);
}

class _ShurikenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = const RadialGradient(
        colors: [Color(0xFFAAAAAA), Color(0xFF444444)],
      ).createShader(
          Rect.fromCircle(center: center, radius: size.width / 2));

    final path = Path();
    final outerR = size.width / 2;
    final innerR = size.width / 6;
    for (var i = 0; i < 4; i++) {
      final oAngle = (i / 4) * 2 * math.pi - math.pi / 2;
      final iAngle1 = oAngle - math.pi / 4;
      final iAngle2 = oAngle + math.pi / 4;
      final op = Offset(
          center.dx + math.cos(oAngle) * outerR,
          center.dy + math.sin(oAngle) * outerR);
      final ip1 = Offset(
          center.dx + math.cos(iAngle1) * innerR,
          center.dy + math.sin(iAngle1) * innerR);
      final ip2 = Offset(
          center.dx + math.cos(iAngle2) * innerR,
          center.dy + math.sin(iAngle2) * innerR);
      if (i == 0) {
        path.moveTo(ip1.dx, ip1.dy);
      } else {
        path.lineTo(ip1.dx, ip1.dy);
      }
      path.lineTo(op.dx, op.dy);
      path.lineTo(ip2.dx, ip2.dy);
    }
    path.close();
    canvas.drawShadow(path, Colors.black, 3, true);
    canvas.drawPath(path, paint);
    canvas.drawCircle(center, 2, Paint()..color = const Color(0xFF222222));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Kunai with explosive paper tag (like Naruto)
class _KunaiWidget extends StatelessWidget {
  const _KunaiWidget();
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _KunaiPainter(), size: Size.infinite);
}

class _KunaiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Blade (triangle, dark steel)
    final bladePaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.grey.shade300, Colors.grey.shade700],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final blade = Path()
      ..moveTo(w * 0.5, 0) // tip
      ..lineTo(w * 0.35, h * 0.45)
      ..lineTo(w * 0.65, h * 0.45)
      ..close();
    canvas.drawPath(blade, bladePaint);

    // Handle (thin rectangle, dark)
    final handlePaint = Paint()..color = const Color(0xFF333333);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.43, h * 0.45, w * 0.14, h * 0.3),
        const Radius.circular(2)),
      handlePaint);

    // Wrap (orange/brown around handle)
    final wrapPaint = Paint()
      ..color = const Color(0xFF8B6914)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < 4; i++) {
      final y = h * 0.48 + i * h * 0.065;
      canvas.drawLine(
          Offset(w * 0.41, y), Offset(w * 0.59, y + h * 0.03), wrapPaint);
    }

    // Ring at bottom of handle
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.8),
      w * 0.08,
      Paint()
        ..color = const Color(0xFF555555)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5);

    // ── Explosive paper tag (white rectangle with red kanji-like marks) ──
    final tagW = w * 0.3;
    final tagH = h * 0.25;
    final tagX = w * 0.58;
    final tagY = h * 0.5;

    // Slight rotation for hanging effect
    canvas.save();
    canvas.translate(tagX, tagY);
    canvas.rotate(0.15);

    // Paper
    final tagRect = Rect.fromLTWH(0, 0, tagW, tagH);
    canvas.drawRect(
        tagRect, Paint()..color = const Color(0xFFF5F0E0));
    canvas.drawRect(
        tagRect,
        Paint()
          ..color = const Color(0xFF999999)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5);

    // Red "seal" marks (kanji-like stripes)
    final sealPaint = Paint()
      ..color = const Color(0xFFCC0000)
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;
    // Vertical center line
    canvas.drawLine(
        Offset(tagW * 0.5, tagH * 0.15),
        Offset(tagW * 0.5, tagH * 0.85),
        sealPaint);
    // Horizontal strokes
    canvas.drawLine(
        Offset(tagW * 0.25, tagH * 0.35),
        Offset(tagW * 0.75, tagH * 0.35),
        sealPaint);
    canvas.drawLine(
        Offset(tagW * 0.3, tagH * 0.6),
        Offset(tagW * 0.7, tagH * 0.6),
        sealPaint);
    // Small circle (seal stamp)
    canvas.drawCircle(
        Offset(tagW * 0.5, tagH * 0.78),
        tagW * 0.12,
        Paint()
          ..color = const Color(0xFFCC0000)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ═══════════════════════════════════════════════════════════════
//  EXPLOSION PAINTER — all effects in ONE paint() call
// ═══════════════════════════════════════════════════════════════

class _ExplosionPainter extends CustomPainter {
  final double progress;
  final Offset center;
  final List<_ShockwaveRing> shockwaves;
  final List<_FireParticle> fireParticles;
  final List<_SmokeParticle> smokeParticles;
  final List<_SparkParticle> sparkParticles;
  final List<_DebrisData> debris;
  final List<_EmberParticle> embers;
  final bool showEmbers;
  final double time;

  _ExplosionPainter({
    required this.progress,
    required this.center,
    required this.shockwaves,
    required this.fireParticles,
    required this.smokeParticles,
    required this.sparkParticles,
    required this.debris,
    required this.embers,
    required this.showEmbers,
    required this.time,
  });

  double _ease(double t) => t < 0 ? 0 : (t > 1 ? 1 : t * (2 - t)); // easeOut

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // ── Shockwave rings ──
    for (final ring in shockwaves) {
      final t = ((progress - ring.delay) / (0.6 - ring.delay)).clamp(0.0, 1.0);
      if (t <= 0) continue;
      final eased = _ease(t);
      final radius = ring.maxRadius * eased;
      final opacity = (1.0 - t) * 0.8;
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = ring.strokeWidth * (1 - t * 0.5)
        ..color = ring.color.withOpacity(opacity.clamp(0.0, 1.0));
      canvas.drawCircle(center, radius, paint);
    }

    // ── Smoke (behind fire) ──
    for (final p in smokeParticles) {
      final t = ((progress - p.delay) / (1.0 - p.delay)).clamp(0.0, 1.0);
      if (t <= 0) continue;
      final eased = _ease(t);
      final r = p.maxSize * (0.3 + eased * 0.7) / 2;
      final x = center.dx + p.dx * eased;
      final y = center.dy + p.dy * eased;
      final opacity = (0.5 - t * 0.5).clamp(0.0, 1.0);
      paint
        ..style = PaintingStyle.fill
        ..color = const Color(0xFF333333).withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), r, paint);
    }

    // ── Fire particles ──
    for (final p in fireParticles) {
      final t = ((progress - p.delay) / (0.7 - p.delay)).clamp(0.0, 1.0);
      if (t <= 0) continue;
      final eased = _ease(t);
      final r = p.startSize * (1 + eased * p.growFactor) / 2;
      final x = center.dx + p.dx * eased;
      final y = center.dy + p.dy * eased;
      final opacity = (1.0 - t * 1.3).clamp(0.0, 1.0);

      // Color shift: white → yellow → orange
      final int rv, gv, bv;
      if (t < 0.3) {
        rv = 255;
        gv = (255 - (t / 0.3 * 85)).round();
        bv = (255 - (t / 0.3 * 200)).round();
      } else {
        rv = 255;
        gv = (170 - ((t - 0.3) / 0.7 * 100)).round().clamp(0, 255);
        bv = (55 - ((t - 0.3) / 0.7 * 55)).round().clamp(0, 255);
      }
      paint
        ..style = PaintingStyle.fill
        ..color = Color.fromRGBO(rv, gv, bv, opacity);
      canvas.drawCircle(Offset(x, y), r, paint);
    }

    // ── Sparks (thin lines) ──
    final sparkOpacity = (1.0 - progress * 1.5).clamp(0.0, 1.0);
    if (sparkOpacity > 0) {
      final sparkEased = _ease(progress);
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round;
      for (final s in sparkParticles) {
        final x = center.dx + s.dx * sparkEased;
        final y = center.dy + s.dy * sparkEased;
        final endX = x + math.cos(s.angle) * s.length;
        final endY = y + math.sin(s.angle) * s.length;
        paint.color = s.color.withOpacity(sparkOpacity);
        canvas.drawLine(Offset(x, y), Offset(endX, endY), paint);
      }
    }

    // ── Debris (shurikens flying away) ──
    final debrisEased = _ease(progress);
    final debrisOpacity = (1.0 - progress * 1.3).clamp(0.0, 1.0);
    if (debrisOpacity > 0) {
      for (final d in debris) {
        final x = center.dx + d.startX + d.dx * debrisEased;
        final y = center.dy + d.startY + d.dy * debrisEased;
        final angle = d.rotation * debrisEased;
        canvas.save();
        canvas.translate(x, y);
        canvas.rotate(angle);
        // Draw tiny shuriken shape
        paint
          ..style = PaintingStyle.fill
          ..color = Color.fromRGBO(150, 150, 150, debrisOpacity);
        final path = Path();
        const r = 6.0;
        const ir = 2.0;
        for (var i = 0; i < 4; i++) {
          final oAngle = (i / 4) * 2 * math.pi;
          final iAngle1 = oAngle - math.pi / 4;
          final iAngle2 = oAngle + math.pi / 4;
          if (i == 0) {
            path.moveTo(math.cos(iAngle1) * ir, math.sin(iAngle1) * ir);
          } else {
            path.lineTo(math.cos(iAngle1) * ir, math.sin(iAngle1) * ir);
          }
          path.lineTo(math.cos(oAngle) * r, math.sin(oAngle) * r);
          path.lineTo(math.cos(iAngle2) * ir, math.sin(iAngle2) * ir);
        }
        path.close();
        canvas.drawPath(path, paint);
        canvas.restore();
      }
    }

    // ── Embers (lingering glow dots) ──
    if (showEmbers) {
      for (final e in embers) {
        final elapsed = time % 10;
        final x = center.dx + e.startX +
            math.sin(elapsed * e.flickerSpeed) * e.driftX;
        final y = center.dy + e.startY + elapsed * e.fallSpeed * 0.3;
        final flicker =
            0.4 + 0.6 * ((math.sin(elapsed * e.flickerSpeed * 3) + 1) / 2);
        final int g = (100 + (flicker * 70).round()).clamp(0, 255);
        paint
          ..style = PaintingStyle.fill
          ..color = Color.fromRGBO(255, g, 0, flicker);
        canvas.drawCircle(Offset(x, y), e.size / 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_ExplosionPainter old) => true;
}

// ── Curved header clipper ──
class _CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.7);
    path.quadraticBezierTo(
        size.width * 0.5, size.height * 1.15, size.width, size.height * 0.7);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// ═══════════════════════════════════════════════════════════════
//  DATA CLASSES
// ═══════════════════════════════════════════════════════════════

class _ShurikenData {
  final double startX, startY;
  final double stickX, stickY, stickAngle;
  final double spinSpeed, delay;
  const _ShurikenData({
    required this.startX, required this.startY,
    required this.stickX, required this.stickY,
    required this.stickAngle, required this.spinSpeed,
    required this.delay,
  });
}

class _FireParticle {
  final double dx, dy, startSize, growFactor, delay;
  const _FireParticle({
    required this.dx, required this.dy,
    required this.startSize, required this.growFactor,
    required this.delay,
  });
}

class _SmokeParticle {
  final double dx, dy, maxSize, delay;
  const _SmokeParticle({
    required this.dx, required this.dy,
    required this.maxSize, required this.delay,
  });
}

class _SparkParticle {
  final double dx, dy, length, angle;
  final Color color;
  const _SparkParticle({
    required this.dx, required this.dy,
    required this.length, required this.angle,
    required this.color,
  });
}

class _ShockwaveRing {
  final double delay, maxRadius, strokeWidth;
  final Color color;
  const _ShockwaveRing({
    required this.delay, required this.maxRadius,
    required this.strokeWidth, required this.color,
  });
}

class _EmberParticle {
  final double startX, startY, driftX, fallSpeed, flickerSpeed, size;
  const _EmberParticle({
    required this.startX, required this.startY,
    required this.driftX, required this.fallSpeed,
    required this.flickerSpeed, required this.size,
  });
}

class _DebrisData {
  final double dx, dy, rotation, startX, startY;
  const _DebrisData({
    required this.dx, required this.dy, required this.rotation,
    required this.startX, required this.startY,
  });
}
