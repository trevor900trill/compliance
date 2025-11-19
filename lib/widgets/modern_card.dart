import 'package:flutter/material.dart';
import '../theme.dart';

/// A modern card widget with hover effects and animations
class ModernCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final Color? backgroundColor;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const ModernCard({
    super.key,
    required this.child,
    this.onTap,
    this.gradient,
    this.backgroundColor,
    this.height,
    this.padding,
    this.margin,
  });

  @override
  State<ModernCard> createState() => _ModernCardState();
}

class _ModernCardState extends State<ModernCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: AppTheme.mediumAnimation,
        curve: Curves.easeOut,
        height: widget.height,
        margin: widget.margin,
        transform: Matrix4.identity()
          ..scale(_isHovered ? 1.02 : 1.0),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.white,
          gradient: widget.gradient,
          borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
          boxShadow: _isHovered ? AppTheme.cardShadowHover : AppTheme.cardShadow,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
            child: Padding(
              padding: widget.padding ?? const EdgeInsets.all(16.0),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
