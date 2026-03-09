import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'cleaning_team_meet_screen.dart';
import 'beautification_tasks_screen.dart';

class NatureAreaScreen extends StatelessWidget {
  const NatureAreaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        title: const Text('🌲 Doğa Alanı'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoCard(
              'İlerleyen bölümlerde açılır. Ağaç dikme ve çevre görevleri bu sahnede gerçekleşir. 🌍🌱',
              Colors.teal,
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
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('🌲🌳🌼', style: TextStyle(fontSize: 72)),
                    SizedBox(height: 10),
                    Text(
                      'Doğa Görevleri',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Çevreyi temizle, fidan dik ve mahalleyi güzelleştir.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: gameProvider.celebrationCompleted
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => gameProvider.hasMetCleaningTeam
                                ? const BeautificationTasksScreen()
                                : const CleaningTeamMeetScreen(),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  gameProvider.celebrationCompleted
                      ? (gameProvider.hasMetCleaningTeam
                          ? '🧹 Çevre Görevlerine Devam'
                          : '🌿 Doğa Görevlerini Başlat')
                      : '🔒 Önce Bayram Bölümü',
                  style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
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
