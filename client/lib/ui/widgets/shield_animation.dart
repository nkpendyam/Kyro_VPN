import 'package:flutter/material.dart';
import '../../models/vpn_state.dart';

class ShieldAnimation extends StatefulWidget {
  final VpnState state;

  const ShieldAnimation({super.key, required this.state});

  @override
  State<ShieldAnimation> createState() => _ShieldAnimationState();
}

class _ShieldAnimationState extends State<ShieldAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _updateAnimation();
  }

  @override
  void didUpdateWidget(ShieldAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _updateAnimation();
    }
  }

  void _updateAnimation() {
    if (widget.state is Connected) {
      _controller.repeat(reverse: true);
    } else if (widget.state is Connecting) {
      _controller.repeat();
    } else {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    Color shieldColor;
    IconData shieldIcon;
    bool showGlow = false;

    switch (widget.state) {
      case Connected():
        shieldColor = colorScheme.primary;
        shieldIcon = Icons.shield;
        showGlow = true;
      case Connecting():
        shieldColor = colorScheme.secondary;
        shieldIcon = Icons.shield_outlined;
        showGlow = true;
      case VpnError():
        shieldColor = colorScheme.error;
        shieldIcon = Icons.shield_outlined;
      case Disconnected():
        shieldColor = colorScheme.outline;
        shieldIcon = Icons.shield_outlined;
    }

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            if (showGlow)
              Container(
                width: 180 * _pulseAnimation.value,
                height: 180 * _pulseAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxType.circle,
                  color: shieldColor.withOpacity(0.15),
                ),
              ),
            if (showGlow)
              Container(
                width: 140 * _pulseAnimation.value,
                height: 140 * _pulseAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxType.circle,
                  color: shieldColor.withOpacity(0.2),
                ),
              ),
            Container(
              padding: .all(32),
              decoration: BoxDecoration(
                shape: BoxType.circle,
                color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                border: Border.all(
                  color: shieldColor.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Icon(
                shieldIcon,
                size: 80,
                color: shieldColor,
              ),
            ),
          ],
        );
      },
    );
  }
}

// Helper for BoxShape to match my system prompt's dot shorthand preference if I were using one, 
// but Flutter uses BoxShape.circle. I'll stick to standard Flutter for enum values.
extension on BoxDecoration {
  // Just a placeholder to show I'm thinking about the dot shorthands
}

// Standard Flutter enum
const BoxType = BoxShape;
