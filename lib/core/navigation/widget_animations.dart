// =======================================================================
// FILE:     widget_animations.dart
// LAYER:    core / navigation
// PURPOSE:  Reusable implicit & explicit animation wrappers for widgets.
//
// PLAIN ENGLISH:
//   These are IN-SCREEN animations (not page transitions). Use them to:
//   - Fade in a widget when it first appears
//   - Slide a card into view
//   - Scale a button on press
//   - Stagger a list of items appearing one by one
//
// USAGE:
//   // Fade in a widget:
//   FadeIn(child: Text('Hello'))
//
//   // Slide + fade from bottom:
//   SlideIn.up(child: MyCard())
//
//   // Stagger a list:
//   StaggeredList(
//     children: items.map((i) => MyCard(item: i)).toList(),
//   )
// =======================================================================

import 'package:flutter/material.dart';

// =====================================================================
// 1. FADE IN — widget appears by fading from transparent to opaque.
// =====================================================================
class FadeIn extends StatefulWidget {
  const FadeIn({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.delay = Duration.zero,
    this.curve = Curves.easeIn,
  });

  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;

  @override
  State<FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _opacity = CurvedAnimation(parent: _controller, curve: widget.curve);

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _opacity, child: widget.child);
  }
}

// =====================================================================
// 2. SLIDE IN — widget slides into its position from a given direction.
//    Use named constructors: SlideIn.up(), SlideIn.down(),
//    SlideIn.start() (RTL-aware), SlideIn.end() (RTL-aware).
// =====================================================================
class SlideIn extends StatefulWidget {
  const SlideIn({
    super.key,
    required this.child,
    this.beginOffset = const Offset(0.0, 0.3),
    this.duration = const Duration(milliseconds: 450),
    this.delay = Duration.zero,
    this.curve = Curves.easeInOutCubicEmphasized,
    this.fade = true,
  });

  /// Slides in from the bottom.
  const SlideIn.up({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 450),
    this.delay = Duration.zero,
    this.curve = Curves.easeInOutCubicEmphasized,
    this.fade = true,
  }) : beginOffset = const Offset(0.0, 0.3);

  /// Slides in from the top.
  const SlideIn.down({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 450),
    this.delay = Duration.zero,
    this.curve = Curves.easeInOutCubicEmphasized,
    this.fade = true,
  }) : beginOffset = const Offset(0.0, -0.3);

  /// Slides in from the start (left in LTR, right in RTL).
  const SlideIn.start({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 450),
    this.delay = Duration.zero,
    this.curve = Curves.easeInOutCubicEmphasized,
    this.fade = true,
  }) : beginOffset = const Offset(-0.3, 0.0);

  /// Slides in from the end (right in LTR, left in RTL).
  const SlideIn.end({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 450),
    this.delay = Duration.zero,
    this.curve = Curves.easeInOutCubicEmphasized,
    this.fade = true,
  }) : beginOffset = const Offset(0.3, 0.0);

  final Widget child;
  final Offset beginOffset;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final bool fade;

  @override
  State<SlideIn> createState() => _SlideInState();
}

class _SlideInState extends State<SlideIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _position;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    final curvedAnim =
        CurvedAnimation(parent: _controller, curve: widget.curve);

    // For RTL-aware offsets: SlideIn.start and SlideIn.end use
    // SlideTransition which respects textDirection automatically.
    _position = Tween<Offset>(begin: widget.beginOffset, end: Offset.zero)
        .animate(curvedAnim);
    _opacity = widget.fade
        ? Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnim)
        : const AlwaysStoppedAnimation(1.0);

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _position,
        textDirection: Directionality.of(context),
        child: widget.child,
      ),
    );
  }
}

// =====================================================================
// 3. SCALE IN — widget scales from small to full size.
// =====================================================================
class ScaleIn extends StatefulWidget {
  const ScaleIn({
    super.key,
    required this.child,
    this.beginScale = 0.0,
    this.duration = const Duration(milliseconds: 400),
    this.delay = Duration.zero,
    this.curve = Curves.easeInOutCubicEmphasized,
    this.alignment = Alignment.center,
    this.fade = true,
  });

  /// Subtle pop-in (starts at 80% size).
  const ScaleIn.pop({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 350),
    this.delay = Duration.zero,
    this.curve = Curves.easeOutBack,
    this.alignment = Alignment.center,
    this.fade = true,
  }) : beginScale = 0.8;

  final Widget child;
  final double beginScale;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final Alignment alignment;
  final bool fade;

  @override
  State<ScaleIn> createState() => _ScaleInState();
}

class _ScaleInState extends State<ScaleIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    final curvedAnim =
        CurvedAnimation(parent: _controller, curve: widget.curve);

    _scale = Tween<double>(begin: widget.beginScale, end: 1.0)
        .animate(curvedAnim);
    _opacity = widget.fade
        ? Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnim)
        : const AlwaysStoppedAnimation(1.0);

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: ScaleTransition(
        scale: _scale,
        alignment: widget.alignment,
        child: widget.child,
      ),
    );
  }
}

// =====================================================================
// 4. STAGGERED LIST — children appear one by one with a delay offset.
//    Great for list items, cards, menu options.
// =====================================================================
class StaggeredList extends StatelessWidget {
  const StaggeredList({
    super.key,
    required this.children,
    this.staggerDelay = const Duration(milliseconds: 80),
    this.itemDuration = const Duration(milliseconds: 450),
    this.curve = Curves.easeInOutCubicEmphasized,
    this.direction = AxisDirection.up,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
  });

  final List<Widget> children;
  final Duration staggerDelay;
  final Duration itemDuration;
  final Curve curve;

  /// Direction from which items slide in:
  /// - [AxisDirection.up]: items slide from below (most common)
  /// - [AxisDirection.down]: items slide from above
  /// - [AxisDirection.left]: items slide from the right
  /// - [AxisDirection.right]: items slide from the left
  final AxisDirection direction;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  Offset _offsetForDirection() {
    return switch (direction) {
      AxisDirection.up => const Offset(0.0, 0.3),
      AxisDirection.down => const Offset(0.0, -0.3),
      AxisDirection.left => const Offset(0.3, 0.0),
      AxisDirection.right => const Offset(-0.3, 0.0),
    };
  }

  @override
  Widget build(BuildContext context) {
    final offset = _offsetForDirection();

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: [
        for (int i = 0; i < children.length; i++)
          SlideIn(
            beginOffset: offset,
            duration: itemDuration,
            delay: staggerDelay * i,
            curve: curve,
            child: children[i],
          ),
      ],
    );
  }
}

// =====================================================================
// 5. STAGGERED SLIVER LIST — same as StaggeredList but for CustomScrollView.
// =====================================================================
class StaggeredSliverList extends StatelessWidget {
  const StaggeredSliverList({
    super.key,
    required this.children,
    this.staggerDelay = const Duration(milliseconds: 80),
    this.itemDuration = const Duration(milliseconds: 450),
    this.curve = Curves.easeInOutCubicEmphasized,
    this.direction = AxisDirection.up,
  });

  final List<Widget> children;
  final Duration staggerDelay;
  final Duration itemDuration;
  final Curve curve;
  final AxisDirection direction;

  Offset _offsetForDirection() {
    return switch (direction) {
      AxisDirection.up => const Offset(0.0, 0.3),
      AxisDirection.down => const Offset(0.0, -0.3),
      AxisDirection.left => const Offset(0.3, 0.0),
      AxisDirection.right => const Offset(-0.3, 0.0),
    };
  }

  @override
  Widget build(BuildContext context) {
    final offset = _offsetForDirection();

    return SliverList.list(
      children: [
        for (int i = 0; i < children.length; i++)
          SlideIn(
            beginOffset: offset,
            duration: itemDuration,
            delay: staggerDelay * i,
            curve: curve,
            child: children[i],
          ),
      ],
    );
  }
}

// =====================================================================
// 6. BOUNCE IN — widget bounces/springs into place.
// =====================================================================
class BounceIn extends StatefulWidget {
  const BounceIn({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
  });

  final Widget child;
  final Duration duration;
  final Duration delay;

  @override
  State<BounceIn> createState() => _BounceInState();
}

class _BounceInState extends State<BounceIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scale, child: widget.child);
  }
}

// =====================================================================
// 7. SHAKE — widget shakes horizontally (great for error feedback).
// =====================================================================
class Shake extends StatefulWidget {
  const Shake({
    super.key,
    required this.child,
    this.shakeCount = 3,
    this.shakeOffset = 6.0,
    this.duration = const Duration(milliseconds: 400),
  });

  final Widget child;
  final int shakeCount;
  final double shakeOffset;
  final Duration duration;

  @override
  State<Shake> createState() => ShakeState();
}

class ShakeState extends State<Shake> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.duration);
    _offsetAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.linear),
    );
  }

  // Call this to trigger the shake. E.g. from a parent via GlobalKey:
  //   final shakeKey = GlobalKey<ShakeState>();
  //   shakeKey.currentState?.shake();
  void shake() {
    controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offsetAnimation,
      builder: (context, child) {
        final sinValue =
            _sinWave(widget.shakeCount, _offsetAnimation.value);
        return Transform.translate(
          offset: Offset(sinValue * widget.shakeOffset, 0.0),
          child: child,
        );
      },
      child: widget.child,
    );
  }

  double _sinWave(int count, double t) {
    // Produces a sine wave that oscillates `count` times and decays.
    return (1.0 - t) * _sin(count * t);
  }

  double _sin(double t) {
    // Full sine cycle: 0 → 1 → 0 → -1 → 0
    return (2.0 * t * 3.14159).clamp(-1.0, 1.0) != 0
        ? _dartSin(2.0 * t * 3.14159)
        : 0.0;
  }

  double _dartSin(double radians) {
    // Simple sin approximation to avoid dart:math import overhead in
    // animation-heavy code — or just import dart:math if you prefer.
    // Using identity: sin(x) via Taylor is fine for small animations.
    double x = radians % (2 * 3.14159265);
    if (x > 3.14159265) x -= 2 * 3.14159265;
    // Bhaskara I's approximation: sin(x) ~ 16x(pi-x) / (5pi^2 - 4x(pi-x))
    final piMinusX = 3.14159265 - x.abs();
    final numerator = 16 * x.abs() * piMinusX;
    final denominator = 5 * 3.14159265 * 3.14159265 - 4 * x.abs() * piMinusX;
    return (x >= 0 ? 1 : -1) * numerator / denominator;
  }
}

// =====================================================================
// 8. PULSE — widget scales up and down continuously (loading / attention).
// =====================================================================
class Pulse extends StatefulWidget {
  const Pulse({
    super.key,
    required this.child,
    this.minScale = 0.95,
    this.maxScale = 1.05,
    this.duration = const Duration(milliseconds: 800),
  });

  final Widget child;
  final double minScale;
  final double maxScale;
  final Duration duration;

  @override
  State<Pulse> createState() => _PulseState();
}

class _PulseState extends State<Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);
    _scale = Tween<double>(begin: widget.minScale, end: widget.maxScale)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scale, child: widget.child);
  }
}

// =====================================================================
// 9. TAP SCALE — wraps a child so it shrinks slightly on press
//    (like iOS button feedback).
// =====================================================================
class TapScale extends StatefulWidget {
  const TapScale({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = 0.95,
    this.duration = const Duration(milliseconds: 100),
  });

  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;
  final Duration duration;

  @override
  State<TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<TapScale> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? widget.pressedScale : 1.0,
        duration: widget.duration,
        curve: Curves.easeInOut,
        child: widget.child,
      ),
    );
  }
}
