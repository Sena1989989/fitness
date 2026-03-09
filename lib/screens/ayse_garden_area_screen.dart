import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'ayse_teyze_meet_screen.dart';
import 'tasks_screen.dart';

class AyseGardenAreaScreen extends StatelessWidget {
  const AyseGardenAreaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text('👵 Ayşe Teyze Bahçesi'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoCard(
              'Burada çiçek ve sebze alanı bulunur. Sulama ve dikim görevleri bu sahnede yapılır. 🌻🥕',
              Colors.green,
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
                    Text('🌷🥬💧', style: TextStyle(fontSize: 70)),
                    SizedBox(height: 10),
                    Text(
                      'Bahçe Görev Alanı',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Sulama ve dikim görevleri burada tamamlanır.',
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
                onPressed: () {
                  if (!gameProvider.hasMetAyseTeyze) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AyseTeyzeMeetScreen(),
                      ),
                    );
                  } else if (!gameProvider.firstTaskCompleted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TasksScreen(isFirstTask: true),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TasksScreen(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  !gameProvider.hasMetAyseTeyze
                      ? '👵 Ayşe Teyze ile Tanış'
                      : (!gameProvider.firstTaskCompleted
                          ? '💧 Sulama Görevine Başla'
                          : '🌱 Dikim ve Bahçe Görevleri'),
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
