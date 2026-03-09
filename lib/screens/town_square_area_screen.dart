import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'neighbors_meet_screen.dart';
import 'celebration_tasks_screen.dart';
import 'final_festival_screen.dart';

class TownSquareAreaScreen extends StatelessWidget {
  const TownSquareAreaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text('🏟️ Mahalle Meydanı'),
        backgroundColor: Colors.pink,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoCard(
              'Bayram kutlamaları ve final festival etkinlikleri bu meydanda yapılır. 🎊🎆',
              Colors.pink,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🎉🏟️🎆', style: TextStyle(fontSize: 70)),
                    const SizedBox(height: 10),
                    const Text(
                      'Etkinlik Meydanı',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Bayram görevleri ve Büyük Mahalle Festivali burada.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: gameProvider.communitySquareDecorUnlocked
                            ? Colors.green[50]
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        gameProvider.communitySquareDecorUnlocked
                            ? '🎏 Meydan süsleri açıldı: Bayraklar ve festival takıları aktif!'
                            : '🔒 Topluluk ödülü için mahalle görevlerini tamamla.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: gameProvider.communitySquareDecorUnlocked
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: gameProvider.raceCompleted
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => gameProvider.hasMetNeighbors
                                ? const CelebrationTasksScreen()
                                : const NeighborsMeetScreen(),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  gameProvider.raceCompleted
                      ? (gameProvider.hasMetNeighbors
                          ? '🎨 Bayram Görevlerine Git'
                          : '🎊 Bayram Kutlamasını Başlat')
                      : '🔒 Önce Bisiklet Bölümü',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: gameProvider.canStartFinalChapter
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FinalFestivalScreen(),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  gameProvider.canStartFinalChapter
                      ? '🎆 Büyük Mahalle Festivali'
                      : '🔒 Final Henüz Kilitli',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String text, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
