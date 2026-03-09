import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/task.dart';
import 'first_task_completion_screen.dart';
import 'home_inventory_screen.dart';
import '../theme/app_theme.dart';

class TasksScreen extends StatelessWidget {
  final bool isFirstTask;
  
  const TasksScreen({super.key, this.isFirstTask = false});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.bgBottom,
      appBar: AppBar(
        title: const Text('📋 Görevler'),
        backgroundColor: AppTheme.appBar,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow),
                const SizedBox(width: 4),
                Text(
                  '${gameProvider.points}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: AppTheme.neonPageGradient(),
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.neonPanel(),
              child: Text(
                isFirstTask 
                    ? '👵 Ayşe Teyze: Bahçemi sular mısın? 💧'
                    : 'Görevleri tamamlayıp puan kazan! 🎯',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.neonCyan,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: isFirstTask ? 1 : gameProvider.tasks.length,
                itemBuilder: (context, index) {
                  final task = isFirstTask 
                      ? gameProvider.tasks[0] // İlk görev: bahçe sulama
                      : gameProvider.tasks[index];
                  return _buildTaskCard(context, task, gameProvider);
                },
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(
    BuildContext context,
    Task task,
    GameProvider gameProvider,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: task.isCompleted
                ? [
                    const Color(0x5534D399),
                    const Color(0x5522D3EE),
                  ]
                : [
                    const Color(0x55475599),
                    const Color(0x55312277),
                  ],
          ),
          border: Border.all(
            color: task.isCompleted ? Colors.greenAccent : Colors.cyanAccent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: (task.isCompleted ? Colors.greenAccent : Colors.cyanAccent)
                  .withValues(alpha: 0.25),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Emoji
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: task.isCompleted
                      ? Colors.greenAccent.withValues(alpha: 0.18)
                      : Colors.cyanAccent.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    task.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Task info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.isCompleted ? '✅ ${task.title}' : task.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '+${task.rewardPoints} puan',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.amberAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action button
              if (!task.isCompleted)
                ElevatedButton(
                  onPressed: () {
                    gameProvider.completeTask(task);
                    
                    // İlk görevse özel completion screen'e git
                    if (isFirstTask && task.id == '1') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FirstTaskCompletionScreen(),
                        ),
                      );
                    } else {
                      _showCompletionDialog(context, task, gameProvider);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.neonPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    '✓ Tamamla',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              else
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 48,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCompletionDialog(BuildContext context, Task task, GameProvider provider) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'reward',
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionDuration: const Duration(milliseconds: 360),
      transitionBuilder: (context, animation, _, __) {
        final scale = CurvedAnimation(parent: animation, curve: Curves.elasticOut);
        return Transform.scale(
          scale: scale.value,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              '🎉 Tebrikler!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  task.emoji,
                  style: const TextStyle(fontSize: 60),
                ),
                const SizedBox(height: 16),
                Text(
                  '"${task.title}" görevini tamamladın!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.yellow[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        '+${task.rewardPoints} puan kazandın!',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '🏠 Ödül animasyonu: Eşya evinde belirdi! (${provider.unlockedFurniture.length} eşya)',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeInventoryScreen(
                        flyInEmojis: ['🎁'],
                      ),
                    ),
                  );
                },
                child: const Text(
                  '🏠 Evimde Gör',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  '😊 Harika!',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
