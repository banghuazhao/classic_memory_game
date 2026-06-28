import 'dart:math';
import 'package:flutter/material.dart';
import 'colors.dart';

/// A memory card that flips in 3D when revealed and pulses when matched.
class MemoryCard extends StatefulWidget {
  final bool isRevealed; // face-up (selected this turn)
  final bool isMatched;  // permanently matched
  final Widget front;    // emoji / symbol shown face-up
  final Widget back;     // question mark shown face-down
  final VoidCallback? onTap;

  const MemoryCard({
    super.key,
    required this.isRevealed,
    required this.isMatched,
    required this.front,
    required this.back,
    this.onTap,
  });

  @override
  State<MemoryCard> createState() => _MemoryCardState();
}

class _MemoryCardState extends State<MemoryCard>
    with TickerProviderStateMixin {
  late final AnimationController _flipCtrl;
  late final AnimationController _pulseCtrl;
  late final Animation<double> _flipAnim;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _glowAnim;

  bool _faceUp = false;

  @override
  void initState() {
    super.initState();

    _flipCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _flipAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipCtrl, curve: Curves.easeInOut),
    );

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.18), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.18, end: 0.95), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOut));

    _glowAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOut),
    );

    _faceUp = widget.isRevealed || widget.isMatched;
    if (_faceUp) _flipCtrl.value = 1.0;
  }

  @override
  void didUpdateWidget(MemoryCard old) {
    super.didUpdateWidget(old);

    final nowFaceUp = widget.isRevealed || widget.isMatched;
    if (nowFaceUp != _faceUp) {
      _faceUp = nowFaceUp;
      if (_faceUp) {
        _flipCtrl.forward();
      } else {
        _flipCtrl.reverse();
      }
    }

    if (widget.isMatched && !old.isMatched) {
      _pulseCtrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _flipCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_flipAnim, _scaleAnim, _glowAnim]),
        builder: (context, _) {
          final angle = _flipAnim.value * pi;
          final isFrontVisible = _flipAnim.value >= 0.5;

          return Transform.scale(
            scale: widget.isMatched ? _scaleAnim.value : 1.0,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              child: isFrontVisible
                  ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(pi),
                      child: _CardFace(
                        color: widget.isMatched
                            ? const Color(0xff7C8D6E)
                            : const Color(0xff8697A4),
                        glow: widget.isMatched ? _glowAnim.value : 0,
                        child: widget.front,
                      ),
                    )
                  : _CardFace(
                      color: MyColors.cardBackground,
                      glow: 0,
                      child: widget.back,
                    ),
            ),
          );
        },
      ),
    );
  }
}

class _CardFace extends StatelessWidget {
  final Color color;
  final double glow;
  final Widget child;

  const _CardFace({required this.color, required this.glow, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
          if (glow > 0)
            BoxShadow(
              color: const Color(0xffA8D5A2).withOpacity(glow * 0.8),
              blurRadius: 16 * glow,
              spreadRadius: 4 * glow,
            ),
        ],
      ),
      child: Center(child: child),
    );
  }
}
