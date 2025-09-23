import 'package:flutter/material.dart';

class AdvancedAnimation extends StatefulWidget {
  const AdvancedAnimation({super.key});

  @override
  State<AdvancedAnimation> createState() => _AdvancedAnimationState();
}

class _AdvancedAnimationState extends State<AdvancedAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    _scaleAnimations = List.generate(3, (index) {
      return Tween(begin: 0.5, end: 1.2).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.2,
            0.6 + index * 0.2,
            curve: Curves.easeOutCubic,
          ),
        ),
      );
    });

    _fadeAnimations = List.generate(3, (index) {
      return Tween(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.2,
            0.6 + index * 0.2,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RepaintBoundary(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (index) => FadeTransition(
              opacity: _fadeAnimations[index],
              child: ScaleTransition(
                scale: _scaleAnimations[index],
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
