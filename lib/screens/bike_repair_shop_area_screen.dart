import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'ali_abi_meet_screen.dart';
import 'bicycle_selection_screen.dart';

class BikeRepairShopAreaScreen extends StatelessWidget {
  const BikeRepairShopAreaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
        title: const Text('👨 Ali Abi Tamirhanesi'),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoCard(
              'Bisiklet yarışları ve parkur etkinlikleri bu sahnede gerçekleşir. 🚲🏁',
              Colors.indigo,
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
                    Text('🧰🚲🏁', style: TextStyle(fontSize: 70)),
                    SizedBox(height: 10),
                    Text(
                      'Yarış Parkuru',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Ali Abi ile tanış, bisiklet seç ve yarışa katıl.',
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
                onPressed: gameProvider.firstTaskCompleted
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => gameProvider.hasMetAliAbi
                                ? const BicycleSelectionScreen()
                                : const AliAbiMeetScreen(),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  gameProvider.firstTaskCompleted
                      ? (gameProvider.hasMetAliAbi
                          ? '🏁 Yarışa Devam Et'
                          : '👨 Ali Abi ile Başla')
                      : '🔒 Önce Bahçe Görevi',
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
