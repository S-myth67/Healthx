import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../tracker/providers/tracker_provider.dart';
import '../../habits/providers/habit_provider.dart';
import '../../habits/screens/add_habit_screen.dart';
import '../../rewards/screens/rewards_screen.dart';
import '../../food/screens/food_screen.dart';
import '../../tasks/screens/tasks_screen.dart';
import '../../analytics/screens/analytics_screen.dart';
import '../../history/screens/history_screen.dart';
import '../widgets/timer_display.dart';
import '../../../core/theme/theme_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tracker = context.watch<TrackerProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.emoji_events),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RewardsScreen()));
            },
          ),
        ],
      ),
      // SOS Button Removed
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Streak Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Current Streak',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${tracker.currentStreakDays} Days',
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().scale(duration: 500.ms),
                  const SizedBox(height: 20),
                  TimerDisplay(duration: tracker.currentDuration),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _showRelapseDialog(context, tracker);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: theme.colorScheme.error,
                      elevation: 0,
                    ),
                    child: const Text('I Relapsed'),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.2),

            const SizedBox(height: 30),

            // Trackers Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildTrackerCard(
                  context,
                  'Food Tracker',
                  Icons.restaurant_menu,
                  Colors.orange,
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const FoodScreen())),
                ),
                _buildTrackerCard(
                  context,
                  'Tasks',
                  Icons.check_circle_outline,
                  Colors.blue,
                  () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const TasksScreen()));
                  },
                ),
                _buildTrackerCard(
                  context,
                  'Analytics',
                  Icons.show_chart,
                  Colors.purple,
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AnalyticsScreen())),
                ),
                _buildTrackerCard(
                  context,
                  'Ranks',
                  Icons.emoji_events,
                  Colors.amber,
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const RewardsScreen())),
                ),
                _buildTrackerCard(
                  context,
                  'History',
                  Icons.history,
                  Colors.teal,
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const HistoryScreen())),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Habits Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Habits',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  color: theme.colorScheme.primary,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddHabitScreen()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Consumer<HabitProvider>(
              builder: (context, habitProvider, child) {
                if (habitProvider.habits.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'No habits yet. Start by adding one!',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color
                              ?.withOpacity(0.5),
                        ),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: habitProvider.habits.length,
                  itemBuilder: (context, index) {
                    final habit = habitProvider.habits[index];
                    return _buildHabitItem(context, habit);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackerCard(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ).animate().scale(duration: 300.ms);
  }

  Widget _buildHabitItem(BuildContext context, dynamic habit) {
    final theme = Theme.of(context);
    final isCompleted = habit.isCompleted;

    return GestureDetector(
      onTap: () {
        context.read<HabitProvider>().toggleHabit(habit.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCompleted
                ? theme.colorScheme.primary.withOpacity(0.5)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isCompleted
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.primary),
              ),
              child: Icon(
                Icons.check,
                size: 16,
                color: isCompleted ? Colors.white : Colors.transparent,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                habit.title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                  color: isCompleted
                      ? theme.textTheme.bodyLarge?.color?.withOpacity(0.5)
                      : null,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete,
                  color: theme.colorScheme.error.withOpacity(0.5)),
              onPressed: () {
                context.read<HabitProvider>().deleteHabit(habit.id);
              },
            ),
          ],
        ),
      ).animate().fadeIn().slideX(),
    );
  }

  void _showRelapseDialog(BuildContext context, TrackerProvider tracker) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Oh no!'),
        content: const Text(
            'Don\'t worry, failure is part of the journey. Are you sure you want to reset your streak?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              tracker.relapse();
              Navigator.pop(context);
            },
            child: const Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
