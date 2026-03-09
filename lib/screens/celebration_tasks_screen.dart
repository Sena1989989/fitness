import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'celebration_dance_screen.dart';

class CelebrationTasksScreen extends StatelessWidget {
  const CelebrationTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text('🎊 Bayram Hazırlıkları'),
        backgroundColor: Colors.pink,
        centerTitle: true,
        automaticallyImplyLeading: false,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                '👵 Fatma Teyze: Görevleri tamamla! 🎉',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: ListView(
                children: [
                  _buildTaskCard(
                    context,
                    '🎨',
                    'Mahalle Süsleme',
                    'Evleri ve sokakları süsle',
                    15,
                    gameProvider.decorationTaskCompleted,
                    () => gameProvider.completeDecorationTask(),
                  ),
                  const SizedBox(height: 16),
                  _buildTaskCard(
                    context,
                    '🍰',
                    'Tatlı Hazırlama',
                    'Lezzetli tatlılar hazırla',
                    15,
                    gameProvider.dessertTaskCompleted,
                    () => gameProvider.completeDessertTask(),
                  ),
                  const SizedBox(height: 16),
                  _buildTaskCard(
                    context,
                    '🐾',
                    'Hayvan Besleme',
                    'Hayvanlara özel yiyecek ver',
                    15,
                    gameProvider.animalFeedingCompleted,
                    () => gameProvider.completeAnimalFeedingTask(),
                  ),
                ],
              ),
            ),

            // Kutlamaya başla butonu
            if (gameProvider.allCelebrationTasksCompleted)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CelebrationDanceScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      '🎉 Kutlamaya Başla! 🎉',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(
    BuildContext context,
    String emoji,
    String title,
    String description,
    int points,
    bool isCompleted,
    VoidCallback onComplete,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isCompleted ? Colors.green[50] : Colors.white,
          border: Border.all(
            color: isCompleted ? Colors.green : Colors.pink[200]!,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Emoji
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.green[100]
                      : Colors.pink[100],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '+$points puan',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Button
              if (!isCompleted)
                ElevatedButton(
                  onPressed: () {
                    onComplete();
                    _showCompletionSnackBar(context, title, points);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
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

  void _showCompletionSnackBar(BuildContext context, String taskName, int points) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '🎉 $taskName tamamlandı! +$points puan',
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
