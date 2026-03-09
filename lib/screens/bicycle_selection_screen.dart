import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/bicycle.dart';
import 'race_screen.dart';

class BicycleSelectionScreen extends StatelessWidget {
  const BicycleSelectionScreen({super.key});

  Color _getBicycleColor(String colorName) {
    switch (colorName) {
      case 'Kırmızı':
        return Colors.red;
      case 'Mavi':
        return Colors.blue;
      case 'Yeşil':
        return Colors.green;
      case 'Sarı':
        return Colors.yellow;
      case 'Pembe':
        return Colors.pink;
      case 'Mor':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('🚲 Bisiklet Seç'),
        backgroundColor: Colors.blue,
        centerTitle: true,
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
                'Yarış için bisikletini seç! 🏁',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                itemCount: gameProvider.availableBicycles.length,
                itemBuilder: (context, index) {
                  final bicycle = gameProvider.availableBicycles[index];
                  final isSelected =
                      gameProvider.selectedBicycle?.id == bicycle.id;

                  return _buildBicycleCard(
                    context,
                    bicycle,
                    isSelected,
                    () {
                      gameProvider.selectBicycle(bicycle);
                      
                      // Yarış ekranına git
                      Future.delayed(const Duration(milliseconds: 500), () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RaceScreen(),
                          ),
                        );
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBicycleCard(
    BuildContext context,
    Bicycle bicycle,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final color = _getBicycleColor(bicycle.color);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.blue[200]!,
            width: isSelected ? 4 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Text(
                bicycle.emoji,
                style: const TextStyle(fontSize: 60),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              bicycle.color,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Bisiklet',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: 8),
              const Icon(
                Icons.check_circle,
                color: Colors.blue,
                size: 32,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
