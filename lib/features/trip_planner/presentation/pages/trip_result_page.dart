import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metrogo/l10n/app_localizations.dart';
import '../../domain/entities/trip_plan.dart';
import '../../domain/entities/trip_segment.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/metro_constants.dart';
import '../../../../core/widgets/line_chip.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';

class TripResultPage extends ConsumerStatefulWidget {
  final TripPlan tripPlan;

  const TripResultPage({super.key, required this.tripPlan});

  @override
  ConsumerState<TripResultPage> createState() => _TripResultPageState();
}

class _TripResultPageState extends ConsumerState<TripResultPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _headerSlide;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _headerSlide = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final locale = Localizations.localeOf(context);
    final lang = locale.languageCode;
    final plan = widget.tripPlan;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Calculate estimated arrival
    final now = TimeOfDay.now();
    final totalMins = plan.totalTimeWithWalking;
    final arrivalMinutes = now.hour * 60 + now.minute + totalMins;
    final arrivalTime = TimeOfDay(
      hour: (arrivalMinutes ~/ 60) % 24,
      minute: arrivalMinutes % 60,
    );

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0E0E14) : const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text(l10n.tripSummary),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_add_outlined),
            onPressed: () {
              ref.read(favoritesProvider.notifier).addTrip(
                    plan.boardingStation.id,
                    plan.alightingStation.id,
                    '${plan.boardingStation.localizedName(lang)} → ${plan.alightingStation.localizedName(lang)}',
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.saveTrip),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header summary card
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.3),
              end: Offset.zero,
            ).animate(_headerSlide),
            child: FadeTransition(
              opacity: _headerSlide,
              child: _SummaryHeader(
                plan: plan,
                arrivalTime: arrivalTime,
                l10n: l10n,
                lang: lang,
                isDark: isDark,
              ),
            ),
          ),
          // Timeline
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                // Walking to station
                if (plan.walkingMinsToBoard != null)
                  _WalkingStep(
                    text: l10n.walkTo(
                      plan.walkingMinsToBoard!,
                      plan.boardingStation.localizedName(lang),
                    ),
                    meters: plan.walkingDistanceToBoard,
                    animDelay: 0,
                  ),
                // Segments
                for (int i = 0; i < plan.segments.length; i++) ...[
                  _SegmentCard(
                    segment: plan.segments[i],
                    lang: lang,
                    l10n: l10n,
                    isDark: isDark,
                    isLast: i == plan.segments.length - 1,
                    animDelay: (i + 1) * 100,
                  ),
                  // Transfer between segments
                  if (i < plan.segments.length - 1)
                    _TransferStep(
                      fromLine: plan.segments[i].lineId,
                      toLine: plan.segments[i + 1].lineId,
                      stationName: plan.segments[i].toStation.localizedName(lang),
                      l10n: l10n,
                      lang: lang,
                      isDark: isDark,
                      animDelay: (i + 1) * 100 + 50,
                    ),
                ],
                // Walking from station
                if (plan.walkingMinsFromAlight != null)
                  _WalkingStep(
                    text: l10n.walkFrom(
                      plan.walkingMinsFromAlight!,
                      plan.alightingStation.localizedName(lang),
                    ),
                    meters: plan.walkingDistanceFromAlight,
                    animDelay: (plan.segments.length + 1) * 100,
                  ),
                const SizedBox(height: 16),
                // Fare breakdown
                _FareCard(plan: plan, l10n: l10n, isDark: isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Summary header ─────────────────────────────────────────────────────

class _SummaryHeader extends StatelessWidget {
  final TripPlan plan;
  final TimeOfDay arrivalTime;
  final AppL10n l10n;
  final String lang;
  final bool isDark;

  const _SummaryHeader({
    required this.plan,
    required this.arrivalTime,
    required this.l10n,
    required this.lang,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final transferCount = plan.segments.length - 1;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A28) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.shade200,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        children: [
          // From → To
          Row(
            children: [
              _StationBadge(
                name: plan.boardingStation.localizedName(lang),
                lineId: plan.segments.first.lineId,
                isStart: true,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      // Line colors bar
                      Row(
                        children: plan.segments.map((seg) {
                          return Expanded(
                            child: Container(
                              height: 3,
                              margin: const EdgeInsets.symmetric(horizontal: 1),
                              decoration: BoxDecoration(
                                color: AppColors.lineColor(seg.lineId),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        transferCount == 0
                            ? l10n.noTransfers
                            : l10n.transfers(transferCount),
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _StationBadge(
                name: plan.alightingStation.localizedName(lang),
                lineId: plan.segments.last.lineId,
                isStart: false,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Stats row
          Row(
            children: [
              _StatChip(
                icon: Icons.access_time_rounded,
                label: '${plan.totalTimeWithWalking} min',
                sublabel: l10n.totalDuration,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              _StatChip(
                icon: Icons.train_rounded,
                label: '${plan.totalStations}',
                sublabel: l10n.stations(plan.totalStations).split(' ').last,
                color: AppColors.lineColor(plan.segments.first.lineId),
              ),
              const SizedBox(width: 8),
              _StatChip(
                icon: Icons.payments_rounded,
                label: '${plan.fareEGP} EGP',
                sublabel: l10n.fare(plan.fareEGP).split(':').first.trim(),
                color: Colors.amber[700]!,
              ),
              const SizedBox(width: 8),
              _StatChip(
                icon: Icons.schedule_rounded,
                label: arrivalTime.format(context),
                sublabel: l10n.arrivalTime,
                color: Colors.green[600]!,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StationBadge extends StatelessWidget {
  final String name;
  final String lineId;
  final bool isStart;

  const _StationBadge({
    required this.name,
    required this.lineId,
    required this.isStart,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.lineColor(lineId);
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isStart ? Icons.trip_origin_rounded : Icons.flag_rounded,
            size: 16,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 70,
          child: Text(
            name,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.12 : 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              sublabel,
              style: TextStyle(
                fontSize: 8,
                color: isDark ? Colors.grey[500] : Colors.grey[600],
              ),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Segment card with expandable stops ─────────────────────────────────

class _SegmentCard extends StatefulWidget {
  final TripSegment segment;
  final String lang;
  final AppL10n l10n;
  final bool isDark;
  final bool isLast;
  final int animDelay;

  const _SegmentCard({
    required this.segment,
    required this.lang,
    required this.l10n,
    required this.isDark,
    required this.isLast,
    required this.animDelay,
  });

  @override
  State<_SegmentCard> createState() => _SegmentCardState();
}

class _SegmentCardState extends State<_SegmentCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _entryController;
  late Animation<double> _entryAnim;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _entryAnim = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
    );
    Future.delayed(Duration(milliseconds: widget.animDelay), () {
      if (mounted) _entryController.forward();
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final seg = widget.segment;
    final color = AppColors.lineColor(seg.lineId);
    final lineName = AppColors.lineName(seg.lineId, widget.lang);

    // Direction: last station in that line's direction
    final directionStation = seg.toStation.localizedName(widget.lang);

    return FadeTransition(
      opacity: _entryAnim,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.05, 0),
          end: Offset.zero,
        ).animate(_entryAnim),
        child: Container(
          margin: const EdgeInsets.only(bottom: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline rail
              _TimelineRail(
                color: color,
                isFirst: true,
                isLast: widget.isLast,
                stationCount:
                    _expanded ? seg.intermediateStations.length + 2 : 2,
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Board station
                    _TimelineStation(
                      name: seg.fromStation.localizedName(widget.lang),
                      subtitle: widget.l10n.boardAt(
                          seg.fromStation.localizedName(widget.lang)),
                      lineId: seg.lineId,
                      isBoard: true,
                      isDark: widget.isDark,
                    ),
                    // Segment info bar
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: widget.isDark ? 0.12 : 0.07),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: color.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              LineChip(lineId: seg.lineId, label: lineName),
                              const SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded,
                                  size: 14, color: color),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  directionStation,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: widget.isDark
                                        ? Colors.grey[300]
                                        : Colors.grey[700],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.access_time_rounded,
                                  size: 13, color: Colors.grey[500]),
                              const SizedBox(width: 4),
                              Text(
                                widget.l10n.estimatedTime(seg.minutes),
                                style: TextStyle(
                                    fontSize: 11, color: Colors.grey[500]),
                              ),
                              const SizedBox(width: 12),
                              Icon(Icons.linear_scale_rounded,
                                  size: 13, color: Colors.grey[500]),
                              const SizedBox(width: 4),
                              Text(
                                widget.l10n.stops(seg.stationCount),
                                style: TextStyle(
                                    fontSize: 11, color: Colors.grey[500]),
                              ),
                            ],
                          ),
                          // Expandable intermediate stops
                          if (seg.intermediateStations.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => _expanded = !_expanded),
                              child: Row(
                                children: [
                                  Icon(
                                    _expanded
                                        ? Icons.expand_less_rounded
                                        : Icons.expand_more_rounded,
                                    size: 16,
                                    color: color,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _expanded
                                        ? widget.l10n.hideStops
                                        : widget.l10n.showStops(
                                            seg.intermediateStations.length),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: color,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedCrossFade(
                              firstChild: const SizedBox.shrink(),
                              secondChild: Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Column(
                                  children: seg.intermediateStations
                                      .map((s) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 6,
                                                  height: 6,
                                                  decoration: BoxDecoration(
                                                    color: color.withValues(alpha: 0.5),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  s.localizedName(widget.lang),
                                                  style: TextStyle(
                                                    fontSize: 11.5,
                                                    color: widget.isDark
                                                        ? Colors.grey[400]
                                                        : Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ),
                              crossFadeState: _expanded
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              duration: const Duration(milliseconds: 250),
                            ),
                          ],
                        ],
                      ),
                    ),
                    // Alight station
                    _TimelineStation(
                      name: seg.toStation.localizedName(widget.lang),
                      subtitle: widget.l10n.alightAt(
                          seg.toStation.localizedName(widget.lang)),
                      lineId: seg.lineId,
                      isBoard: false,
                      isDark: widget.isDark,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Timeline rail ──────────────────────────────────────────────────────

class _TimelineRail extends StatelessWidget {
  final Color color;
  final bool isFirst;
  final bool isLast;
  final int stationCount;

  const _TimelineRail({
    required this.color,
    required this.isFirst,
    required this.isLast,
    required this.stationCount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      child: Column(
        children: [
          // Top dot
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 3),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          // Line
          Container(
            width: 4,
            height: 120,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Center(
              child: Container(
                width: 3,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          // Bottom dot
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: isLast ? color : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 3),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineStation extends StatelessWidget {
  final String name;
  final String subtitle;
  final String lineId;
  final bool isBoard;
  final bool isDark;

  const _TimelineStation({
    required this.name,
    required this.subtitle,
    required this.lineId,
    required this.isBoard,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.lineColor(lineId);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                isBoard ? 'Board' : 'Alight',
                style: TextStyle(
                  fontSize: 10.5,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Transfer step ──────────────────────────────────────────────────────

class _TransferStep extends StatefulWidget {
  final String fromLine;
  final String toLine;
  final String stationName;
  final AppL10n l10n;
  final String lang;
  final bool isDark;
  final int animDelay;

  const _TransferStep({
    required this.fromLine,
    required this.toLine,
    required this.stationName,
    required this.l10n,
    required this.lang,
    required this.isDark,
    required this.animDelay,
  });

  @override
  State<_TransferStep> createState() => _TransferStepState();
}

class _TransferStepState extends State<_TransferStep>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    Future.delayed(Duration(milliseconds: widget.animDelay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final toLineName = AppColors.lineName(widget.toLine, widget.lang);

    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.amber.withValues(alpha: widget.isDark ? 0.1 : 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.amber.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.swap_horiz_rounded,
                  size: 18, color: Colors.amber[700]),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.l10n.transferAt(widget.stationName),
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: widget.isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.l10n.transferWalk(
                      toLineName,
                      MetroConstants.transferMinutes,
                    ),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            LineChip(lineId: widget.toLine, label: toLineName, small: true),
          ],
        ),
      ),
    );
  }
}

// ─── Walking step ───────────────────────────────────────────────────────

class _WalkingStep extends StatefulWidget {
  final String text;
  final double? meters;
  final int animDelay;

  const _WalkingStep({
    required this.text,
    this.meters,
    required this.animDelay,
  });

  @override
  State<_WalkingStep> createState() => _WalkingStepState();
}

class _WalkingStepState extends State<_WalkingStep>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    Future.delayed(Duration(milliseconds: widget.animDelay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final distText = widget.meters != null
        ? (widget.meters! < 1000
            ? '${widget.meters!.round()} m'
            : '${(widget.meters! / 1000).toStringAsFixed(1)} km')
        : null;

    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: isDark ? 0.08 : 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  const Icon(Icons.directions_walk_rounded, size: 18, color: Colors.blue),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
            ),
            if (distText != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  distText,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Fare breakdown card ────────────────────────────────────────────────

class _FareCard extends StatelessWidget {
  final TripPlan plan;
  final AppL10n l10n;
  final bool isDark;

  const _FareCard({
    required this.plan,
    required this.l10n,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final walkMins =
        (plan.walkingMinsToBoard ?? 0) + (plan.walkingMinsFromAlight ?? 0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A28) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          _fareRow(
            Icons.train_rounded,
            l10n.rideTime,
            '${plan.totalMinutes} min',
            AppColors.lineColor(plan.segments.first.lineId),
          ),
          if (walkMins > 0) ...[
            const SizedBox(height: 8),
            _fareRow(
              Icons.directions_walk_rounded,
              l10n.walkTime,
              '$walkMins min',
              Colors.blue,
            ),
          ],
          if (plan.segments.length > 1) ...[
            const SizedBox(height: 8),
            _fareRow(
              Icons.swap_horiz_rounded,
              l10n.transfers(plan.segments.length - 1),
              '${(plan.segments.length - 1) * MetroConstants.transferMinutes} min',
              Colors.amber[700]!,
            ),
          ],
          Divider(
            height: 20,
            color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.shade200,
          ),
          Row(
            children: [
              Icon(Icons.payments_rounded, size: 20, color: Colors.green[600]),
              const SizedBox(width: 8),
              Text(
                l10n.fare(plan.fareEGP),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const Spacer(),
              Text(
                l10n.fareNote,
                style: TextStyle(fontSize: 9, color: Colors.grey[500]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fareRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }
}
