import 'dart:math';
import 'package:flutter/material.dart';
import '../models/memory_card.dart';

class MemoryCardWidget extends StatefulWidget {
  final MemoryCard card;
  final VoidCallback onTap;
  final Color cardColor;

  const MemoryCardWidget({
    super.key,
    required this.card,
    required this.onTap,
    required this.cardColor,
  });

  @override
  State<MemoryCardWidget> createState() => _MemoryCardWidgetState();
}

class _MemoryCardWidgetState extends State<MemoryCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showFront = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // If card starts face up (preview mode), show front immediately
    if (widget.card.isFaceUp) {
      _controller.value = 1.0;
      _showFront = true;
    }
  }

  @override
  void didUpdateWidget(covariant MemoryCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final wasUp = oldWidget.card.isFaceUp;
    final isUp = widget.card.isFaceUp;

    if (wasUp == isUp) return; // no change, do nothing

    if (isUp) {
      // Flip to front
      _controller.forward().then((_) {
        if (mounted) setState(() => _showFront = true);
      });
    } else {
      // Flip to back
      setState(() => _showFront = false);
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * pi;
          final isFront = angle > pi / 2;

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            alignment: Alignment.center,
            child: isFront
                ? Transform(
              transform: Matrix4.identity()..rotateY(pi),
              alignment: Alignment.center,
              child: _buildFront(),
            )
                : _buildBack(),
          );
        },
      ),
    );
  }

  Widget _buildBack() {
    return Container(
      decoration: BoxDecoration(
        color: widget.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '?',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ),
    );
  }

  Widget _buildFront() {
    final isMatched = widget.card.isMatched;
    return Container(
      decoration: BoxDecoration(
        color: isMatched ? const Color(0xFFB9F6CA) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMatched ? const Color(0xFF00C853) : const Color(0xFFE0E0E0),
          width: isMatched ? 2.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isMatched
                ? const Color(0xFF00C853).withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(widget.card.emoji, style: const TextStyle(fontSize: 36)),
      ),
    );
  }
}
