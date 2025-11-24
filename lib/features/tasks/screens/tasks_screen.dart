import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/task_provider.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskProvider = context.watch<TaskProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Tasks')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
      body: taskProvider.tasks.isEmpty
          ? Center(
              child: Text(
                'No tasks yet. Add one!',
                style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];
                return Dismissible(
                  key: Key(task.id),
                  onDismissed: (_) {
                    context.read<TaskProvider>().deleteTask(task.id);
                  },
                  background: Container(color: Colors.red),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: task.isCompleted,
                                onChanged: (_) {
                                  context
                                      .read<TaskProvider>()
                                      .toggleTaskCompletion(task.id);
                                },
                              ),
                              Expanded(
                                child: Text(
                                  task.title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    decoration: task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color:
                                        task.isCompleted ? Colors.grey : null,
                                  ),
                                ),
                              ),
                              if (!task.isCompleted)
                                IconButton(
                                  icon: Icon(
                                    task.isRunning
                                        ? Icons.pause_circle_filled
                                        : Icons.play_circle_fill,
                                    color: task.isRunning
                                        ? Colors.orange
                                        : theme.colorScheme.primary,
                                    size: 32,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<TaskProvider>()
                                        .toggleTaskTimer(task.id);
                                  },
                                ),
                            ],
                          ),
                          if (task.durationSeconds > 0 || task.isRunning)
                            Padding(
                              padding: const EdgeInsets.only(left: 48, top: 8),
                              child: Row(
                                children: [
                                  const Icon(Icons.timer,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Text(
                                    _formatDuration(task.durationSeconds),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontFamily: 'Monospace',
                                      fontWeight: FontWeight.bold,
                                      color: task.isRunning
                                          ? theme.colorScheme.primary
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn().slideX(),
                );
              },
            ),
    );
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final h = duration.inHours;
    final m = duration.inMinutes % 60;
    final s = duration.inSeconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _showAddTaskDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Task'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'What needs to be done?'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<TaskProvider>().addTask(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
