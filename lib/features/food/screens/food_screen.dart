import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../providers/food_provider.dart';
import '../../home/widgets/timer_display.dart';

class FoodScreen extends StatelessWidget {
  const FoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foodProvider = context.watch<FoodProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Food Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fasting Timer
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Text(
                    'Fasting Since Last Meal',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  TimerDisplay(duration: foodProvider.fastingDuration),
                ],
              ),
            ).animate().fadeIn().slideY(begin: -0.2),

            const SizedBox(height: 32),

            Text(
              'Log Meal',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMealButton(context, 'Breakfast', Icons.wb_sunny),
                _buildMealButton(context, 'Lunch', Icons.restaurant),
                _buildMealButton(context, 'Dinner', Icons.nights_stay),
                _buildMealButton(context, 'Snack', Icons.cookie),
              ],
            ),

            const SizedBox(height: 32),

            Text(
              'Recent Logs',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: foodProvider.logs.isEmpty
                  ? Center(
                      child: Text(
                        'No meals logged yet.',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: foodProvider.logs.length,
                      itemBuilder: (context, index) {
                        final log = foodProvider.logs[index];
                        return Dismissible(
                          key: Key(log.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (_) {
                            context.read<FoodProvider>().deleteLog(log.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Meal deleted')),
                            );
                          },
                          child: ListTile(
                            leading: Icon(
                              _getIconForMeal(log.mealType),
                              color: theme.colorScheme.primary,
                            ),
                            title: Text(log.mealType),
                            subtitle: Text(DateFormat('MMM d, h:mm a')
                                .format(log.eatenAt)),
                          ).animate().fadeIn(delay: (index * 50).ms).slideX(),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealButton(BuildContext context, String label, IconData icon) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            context.read<FoodProvider>().logMeal(label);
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
          ),
          child: Icon(icon),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    ).animate().scale();
  }

  IconData _getIconForMeal(String type) {
    switch (type) {
      case 'Breakfast':
        return Icons.wb_sunny;
      case 'Lunch':
        return Icons.restaurant;
      case 'Dinner':
        return Icons.nights_stay;
      case 'Snack':
        return Icons.cookie;
      default:
        return Icons.fastfood;
    }
  }
}
