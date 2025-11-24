import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../tracker/providers/tracker_provider.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tracker = context.watch<TrackerProvider>();
    final currentRank = _calculateRank(tracker.currentStreakDays);
    final nextRank = _getNextRank(tracker.currentStreakDays);
    final progress = _calculateProgress(tracker.currentStreakDays);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Rank')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Current Rank Display
            Center(
              child: Column(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      border: Border.all(
                          color: theme.colorScheme.primary, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _getRankEmoji(currentRank.name),
                        style: const TextStyle(fontSize: 60),
                      ),
                    ),
                  ).animate().scale(duration: 800.ms, curve: Curves.elasticOut),
                  const SizedBox(height: 24),
                  Text(
                    currentRank.name.toUpperCase(),
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                      letterSpacing: 2,
                    ),
                  ).animate().fadeIn().slideY(begin: 0.2),
                  const SizedBox(height: 8),
                  Text(
                    '${tracker.currentStreakDays} Days Streak',
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Progress Bar
            if (nextRank != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Progress to ${nextRank.name}'),
                  Text('${(progress * 100).toInt()}%'),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                borderRadius: BorderRadius.circular(10),
                backgroundColor: theme.colorScheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
              ).animate().shimmer(duration: 2.seconds),
              const SizedBox(height: 8),
              Text(
                '${nextRank.threshold - tracker.currentStreakDays} days remaining',
                style: theme.textTheme.bodySmall,
              ),
            ] else
              const Text('MAX RANK ACHIEVED!'),

            const SizedBox(height: 40),

            // All Ranks List
            Text(
              'Rank Progression',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _ranks.length,
              itemBuilder: (context, index) {
                final rank = _ranks[index];
                final isUnlocked = tracker.currentStreakDays >= rank.threshold;
                final isCurrent = currentRank.name == rank.name;

                return Card(
                  color: isCurrent ? theme.colorScheme.primaryContainer : null,
                  child: ListTile(
                    leading: Text(
                      _getRankEmoji(rank.name),
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(
                      rank.name,
                      style: TextStyle(
                        fontWeight:
                            isCurrent ? FontWeight.bold : FontWeight.normal,
                        color: isUnlocked ? null : Colors.grey,
                      ),
                    ),
                    trailing: isUnlocked
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : Text('${rank.threshold} Days'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Rank _calculateRank(int days) {
    for (var i = _ranks.length - 1; i >= 0; i--) {
      if (days >= _ranks[i].threshold) {
        return _ranks[i];
      }
    }
    return _ranks.first;
  }

  Rank? _getNextRank(int days) {
    for (var rank in _ranks) {
      if (days < rank.threshold) {
        return rank;
      }
    }
    return null;
  }

  double _calculateProgress(int days) {
    final current = _calculateRank(days);
    final next = _getNextRank(days);

    if (next == null) return 1.0;

    final range = next.threshold - current.threshold;
    final progress = days - current.threshold;

    // Handle case where range is 0 (shouldn't happen with correct logic but safe guard)
    if (range <= 0) return 0.0;

    return progress / range;
  }

  String _getRankEmoji(String rankName) {
    switch (rankName) {
      case 'Iron':
        return '🔩';
      case 'Bronze':
        return '🥉';
      case 'Silver':
        return '🥈';
      case 'Gold':
        return '🥇';
      case 'Platinum':
        return '💠';
      case 'Diamond':
        return '💎';
      case 'Ascendant':
        return '🟢';
      case 'Immortal':
        return '🔴';
      case 'Radiant':
        return '✨';
      default:
        return '❓';
    }
  }
}

class Rank {
  final String name;
  final int threshold;

  const Rank(this.name, this.threshold);
}

const List<Rank> _ranks = [
  Rank('Iron', 0),
  Rank('Bronze', 3),
  Rank('Silver', 7),
  Rank('Gold', 14),
  Rank('Platinum', 30),
  Rank('Diamond', 60),
  Rank('Ascendant', 90),
  Rank('Immortal', 180),
  Rank('Radiant', 365),
];
