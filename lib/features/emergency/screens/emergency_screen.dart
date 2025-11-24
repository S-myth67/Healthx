import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<String> _quotes = [
    "This too shall pass.",
    "You are stronger than your urges.",
    "Focus on your long-term goals.",
    "Breathe in... Breathe out...",
    "Discipline is choosing what you want most over what you want now.",
    "Don't give up what you want most for what you want now.",
    "Pain is temporary. Pride is forever.",
  ];

  late String _currentQuote;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _currentQuote = _quotes[math.Random().nextInt(_quotes.length)];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('Safe Mode'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Breathing Animation
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  width: 200 + (_controller.value * 100),
                  height: 200 + (_controller.value * 100),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        theme.colorScheme.primary.withOpacity(0.2),
                        theme.colorScheme.primary.withOpacity(0.0),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 150 + (_controller.value * 50),
                      height: 150 + (_controller.value * 50),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.primary.withOpacity(0.3),
                      ),
                      child: Center(
                        child: Text(
                          _controller.value < 0.5
                              ? "Breathe In"
                              : "Breathe Out",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 60),

            // Quote
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                _currentQuote,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.textTheme.bodyLarge?.color?.withOpacity(0.8),
                ),
              ).animate().fadeIn(duration: 1.seconds).slideY(begin: 0.2),
            ),

            const SizedBox(height: 40),

            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _currentQuote =
                      _quotes[math.Random().nextInt(_quotes.length)];
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('New Motivation'),
            ),
          ],
        ),
      ),
    );
  }
}
