// =======================================================================
// FILE:     page_transitions.dart
// LAYER:    core / navigation
// PURPOSE:  Reusable page transition builders for GoRouter.
//
// PLAIN ENGLISH:
//   When navigating between screens (like Android Fragment transactions),
//   these transitions control HOW the new screen appears:
//   slide from right/left (RTL-aware), fade, scale, slide-up, etc.
//
//   Each method returns a CustomTransitionPage that GoRouter understands.
//   Use them in your route's `pageBuilder` instead of `builder`.
//
// USAGE:
//   GoRoute(
//     path: '/home',
//     pageBuilder: (context, state) => PageTransitions.slide(
//       key: state.pageKey,
//       child: const HomeScreen(),
//     ),
//   ),
// =======================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Reusable page transitions for screen-to-screen navigation.
///
/// These are the equivalent of Android's FragmentTransaction animations
/// (slide, fade, scale, etc.) — but for Flutter + GoRouter.
abstract final class PageTransitions {
  // ─── Duration Defaults ──────────────────────────────────────────

  static const Duration defaultDuration = Duration(milliseconds: 350);
  static const Duration fastDuration = Duration(milliseconds: 200);
  static const Duration slowDuration = Duration(milliseconds: 500);

  // ─── Curves ─────────────────────────────────────────────────────

  static const Curve defaultCurve = Curves.easeInOutCubicEmphasized;
  static const Curve sharpCurve = Curves.easeInOutCubic;
  static const Curve bouncyCurve = Curves.elasticOut;

  // =================================================================
  // 1. SLIDE (RTL / LTR aware)
  //    New screen slides in from the leading edge (right in LTR,
  //    left in RTL) — exactly like Android's slide_in_right.
  // =================================================================
  static CustomTransitionPage<void> slide({
    required LocalKey key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 350),
    Curve curve = Curves.easeInOutCubicEmphasized,
  }) {
    return CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final isRtl = Directionality.of(context) == TextDirection.rtl;
        final begin = Offset(isRtl ? -1.0 : 1.0, 0.0);

        return SlideTransition(
          position: Tween<Offset>(begin: begin, end: Offset.zero)
              .animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );
      },
    );
  }

  // =================================================================
  // 2. SLIDE LEFT (always from left, ignores text direction)
  // =================================================================
  static CustomTransitionPage<void> slideLeft({
    required LocalKey key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 350),
    Curve curve = Curves.easeInOutCubicEmphasized,
  }) {
    return CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );
      },
    );
  }

  // =================================================================
  // 3. SLIDE RIGHT (always from right, ignores text direction)
  // =================================================================
  static CustomTransitionPage<void> slideRight({
    required LocalKey key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 350),
    Curve curve = Curves.easeInOutCubicEmphasized,
  }) {
    return CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );
      },
    );
  }

  // =================================================================
  // 4. SLIDE UP (bottom sheet / modal style)
  // =================================================================
  static CustomTransitionPage<void> slideUp({
    required LocalKey key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 350),
    Curve curve = Curves.easeInOutCubicEmphasized,
  }) {
    return CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );
      },
    );
  }

  // =================================================================
  // 5. SLIDE DOWN
  // =================================================================
  static CustomTransitionPage<void> slideDown({
    required LocalKey key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 350),
    Curve curve = Curves.easeInOutCubicEmphasized,
  }) {
    return CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );
      },
    );
  }

  // =================================================================
  // 6. FADE (cross-fade between screens)
  // =================================================================
  static CustomTransitionPage<void> fade({
    required LocalKey key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeIn,
  }) {
    return CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: curve),
          child: child,
        );
      },
    );
  }

  // =================================================================
  // 7. SCALE (zoom in from center)
  // =================================================================
  static CustomTransitionPage<void> scale({
    required LocalKey key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 350),
    Curve curve = Curves.easeInOutCubicEmphasized,
    Alignment alignment = Alignment.center,
  }) {
    return CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0)
              .animate(CurvedAnimation(parent: animation, curve: curve)),
          alignment: alignment,
          child: child,
        );
      },
    );
  }

  // =================================================================
  // 8. SCALE + FADE (Material 3 style container transform)
  //    Zooms in from 85% to 100% while fading in — feels premium.
  // =================================================================
  static CustomTransitionPage<void> scaleFade({
    required LocalKey key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 350),
    Curve curve = Curves.easeInOutCubicEmphasized,
    double beginScale = 0.85,
  }) {
    return CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnim = CurvedAnimation(parent: animation, curve: curve);
        return FadeTransition(
          opacity: curvedAnim,
          child: ScaleTransition(
            scale: Tween<double>(begin: beginScale, end: 1.0)
                .animate(curvedAnim),
            child: child,
          ),
        );
      },
    );
  }

  // =================================================================
  // 9. SLIDE + FADE (slide in from leading edge while fading in)
  //    RTL-aware. Best general-purpose transition.
  // =================================================================
  static CustomTransitionPage<void> slideFade({
    required LocalKey key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 350),
    Curve curve = Curves.easeInOutCubicEmphasized,
  }) {
    return CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final isRtl = Directionality.of(context) == TextDirection.rtl;
        final begin = Offset(isRtl ? -0.3 : 0.3, 0.0);
        final curvedAnim = CurvedAnimation(parent: animation, curve: curve);

        return FadeTransition(
          opacity: curvedAnim,
          child: SlideTransition(
            position:
                Tween<Offset>(begin: begin, end: Offset.zero).animate(curvedAnim),
            child: child,
          ),
        );
      },
    );
  }

  // =================================================================
  // 10. SLIDE UP + FADE (modal-style appearance)
  // =================================================================
  static CustomTransitionPage<void> slideUpFade({
    required LocalKey key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 350),
    Curve curve = Curves.easeInOutCubicEmphasized,
  }) {
    return CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnim = CurvedAnimation(parent: animation, curve: curve);

        return FadeTransition(
          opacity: curvedAnim,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.15),
              end: Offset.zero,
            ).animate(curvedAnim),
            child: child,
          ),
        );
      },
    );
  }

  // =================================================================
  // 11. ROTATION + FADE (playful spin-in)
  // =================================================================
  static CustomTransitionPage<void> rotateFade({
    required LocalKey key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeInOutCubicEmphasized,
    double beginTurns = 0.5,
  }) {
    return CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnim = CurvedAnimation(parent: animation, curve: curve);
        return FadeTransition(
          opacity: curvedAnim,
          child: RotationTransition(
            turns: Tween<double>(begin: beginTurns, end: 1.0)
                .animate(curvedAnim),
            child: child,
          ),
        );
      },
    );
  }

  // =================================================================
  // 12. SHARED AXIS HORIZONTAL (Material motion — old page slides out
  //     left, new page slides in from right, both with fade)
  // =================================================================
  static CustomTransitionPage<void> sharedAxisHorizontal({
    required LocalKey key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.easeInOutCubicEmphasized,
  }) {
    return CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final isRtl = Directionality.of(context) == TextDirection.rtl;
        final direction = isRtl ? -1.0 : 1.0;
        final curvedAnim = CurvedAnimation(parent: animation, curve: curve);

        // Incoming page slides in from leading edge
        final slideIn = Tween<Offset>(
          begin: Offset(0.3 * direction, 0.0),
          end: Offset.zero,
        ).animate(curvedAnim);

        // Outgoing page slides out toward trailing edge
        final slideOut = Tween<Offset>(
          begin: Offset.zero,
          end: Offset(-0.3 * direction, 0.0),
        ).animate(CurvedAnimation(parent: secondaryAnimation, curve: curve));

        return SlideTransition(
          position: slideOut,
          child: SlideTransition(
            position: slideIn,
            child: FadeTransition(
              opacity: curvedAnim,
              child: child,
            ),
          ),
        );
      },
    );
  }

  // =================================================================
  // 13. SHARED AXIS VERTICAL (scroll-like: old page fades up,
  //     new page fades in from below)
  // =================================================================
  static CustomTransitionPage<void> sharedAxisVertical({
    required LocalKey key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.easeInOutCubicEmphasized,
  }) {
    return CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnim = CurvedAnimation(parent: animation, curve: curve);

        final slideIn = Tween<Offset>(
          begin: const Offset(0.0, 0.3),
          end: Offset.zero,
        ).animate(curvedAnim);

        final slideOut = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0.0, -0.3),
        ).animate(CurvedAnimation(parent: secondaryAnimation, curve: curve));

        return SlideTransition(
          position: slideOut,
          child: SlideTransition(
            position: slideIn,
            child: FadeTransition(
              opacity: curvedAnim,
              child: child,
            ),
          ),
        );
      },
    );
  }

  // =================================================================
  // 14. FADE THROUGH (Material 3: old page fades out + scales down,
  //     new page fades in + scales up — used for top-level destinations)
  // =================================================================
  static CustomTransitionPage<void> fadeThrough({
    required LocalKey key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Outgoing page fades out and scales down
        final fadeOut = ReverseAnimation(secondaryAnimation);

        return FadeTransition(
          opacity: CurvedAnimation(
            parent: fadeOut,
            curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
          ),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
            ),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.92, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: const Interval(0.3, 1.0,
                      curve: Curves.easeInOutCubicEmphasized),
                ),
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }

  // =================================================================
  // 15. NO TRANSITION (instant swap, like Android's setTransition(0))
  // =================================================================
  static CustomTransitionPage<void> none({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }
}
