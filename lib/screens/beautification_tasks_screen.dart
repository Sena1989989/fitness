import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'beautification_completion_screen.dart';

class BeautificationTasksScreen extends StatelessWidget {
  const BeautificationTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        title: const Text('🌿 Mahalleyi Güzelleştirme'),
        backgroundColor: Colors.teal,
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
                '🧑‍🤝‍🧑 Komşular: Çevreyi birlikte güzelleştirelim! 🌍',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
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
                    '🗑️',
                    'Çöpleri Topla',
                    'Sokaktaki çöpleri toplayıp geri dönüşüme bırak',
                    20,
                    gameProvider.trashCollectionCompleted,
                    () => gameProvider.completeTrashCollectionTask(),
                  ),
                  const SizedBox(height: 16),
                  _buildTaskCard(
                    context,
                    '🌱',
                    'Ağaç Dik',
                    'Mahalle parkına yeni fidanlar dik',
                    25,
                    gameProvider.treePlantingCompleted,
                    () => gameProvider.completeTreePlantingTask(),
                  ),
                ],
              ),
            ),
            if (gameProvider.allBeautificationTasksCompleted)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: () {
                      final provider = Provider.of<GameProvider>(context, listen: false);
                      provider.completeNeighborhoodBeautification();

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BeautificationCompletionScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      '🌟 Bölümü Tamamla! 🌟',
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
            color: isCompleted ? Colors.green : Colors.teal[200]!,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green[100] : Colors.teal[100],
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
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
              if (!isCompleted)
                ElevatedButton(
                  onPressed: () {
                    onComplete();
                    _showCompletionSnackBar(context, title, points);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
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
