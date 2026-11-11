import 'package:flutter/material.dart';
import 'package:doctor_on_duty/ui/theme/app_theme.dart';

/// Full-screen gradient field + soft color blobs (opacity only, no blur).
class LiquidCanvas extends StatelessWidget {
  const LiquidCanvas({
    super.key,
    required this.child,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? const [
                      Color(0xFF070B12),
                      Color(0xFF0C1524),
                      Color(0xFF0D1F1C),
                    ]
                  : const [
                      Color(0xFFEFF6FF),
                      Color(0xFFF0FDFA),
                      Color(0xFFF8FAFC),
                    ],
            ),
          ),
        ),
        Positioned(
          top: -72,
          right: -48,
          child: _Blob(
            diameter: 240,
            color: primary.withValues(alpha: isDark ? 0.16 : 0.22),
          ),
        ),
        Positioned(
          top: 120,
          left: -90,
          child: _Blob(
            diameter: 200,
            color: AppColors.opd.withValues(alpha: isDark ? 0.1 : 0.18),
          ),
        ),
        Positioned(
          bottom: 40,
          right: -30,
          child: _Blob(
            diameter: 180,
            color: AppColors.emergency.withValues(alpha: isDark ? 0.08 : 0.12),
          ),
        ),
        Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.diameter, required this.color});

  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color,
            color.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}

/// Transparent [Scaffold] on top of [LiquidCanvas].
class LiquidScaffold extends StatelessWidget {
  const LiquidScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.extendBody = true,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final bool extendBody;

  @override
  Widget build(BuildContext context) {
    final appBarHeight = appBar?.preferredSize.height ?? kToolbarHeight;
    final underAppBar = appBar != null
        ? Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top + appBarHeight,
            ),
            child: body,
          )
        : body;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: extendBody,
      extendBodyBehindAppBar: appBar != null,
      appBar: appBar,
      body: LiquidCanvas(child: underAppBar),
      floatingActionButton: floatingActionButton,
    );
  }
}
