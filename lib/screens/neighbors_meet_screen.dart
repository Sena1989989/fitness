import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'celebration_tasks_screen.dart';

class NeighborsMeetScreen extends StatefulWidget {
  const NeighborsMeetScreen({super.key});

  @override
  State<NeighborsMeetScreen> createState() => _NeighborsMeetScreenState();
}

class _NeighborsMeetScreenState extends State<NeighborsMeetScreen> {
  int _currentStep = 0;

  final List<Map<String, String>> _storySteps = [
    {
      'emoji': '🎊',
      'title': 'Bayram Zamanı!',
      'message': 'Mahallede büyük bir bayram kutlaması yapılacak! Herkes çok heyecanlı! 🎉',
    },
    {
      'emoji': '👵',
      'title': 'Fatma Teyze',
      'message': 'Merhaba tatlım! Ben Fatma Teyze. Bayramı birlikte kutlayacağız! Bize yardım eder misin? 💚',
    },
    {
      'emoji': '🎨',
      'title': 'Süsleme Zamanı',
      'message': 'Mahalleyi süsleyeceğiz, tatlılar hazırlayacağız ve hayvanlarımızı da unutmayacağız! Hazır mısın? 🌟',
    },
    {
      'emoji': '🤝',
      'title': 'Birlikte Güçlüyüz',
      'message': 'Herkes birlikte çalıştığında ne güzel şeyler oluyor! Hadi başlayalım! 😊',
    },
  ];

  void _nextStep() {
    if (_currentStep < _storySteps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      final gameProvider = Provider.of<GameProvider>(context, listen: false);
      gameProvider.markNeighborsMet();
      
      // Görevler ekranına git
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const CelebrationTasksScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStory = _storySteps[_currentStep];

    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Emoji
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Text(
                  currentStory['emoji']!,
                  style: const TextStyle(fontSize: 100),
                ),
              ),
              const SizedBox(height: 40),

              // Message bubble
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      currentStory['title']!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      currentStory['message']!,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Progress dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _storySteps.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == _currentStep
                          ? Colors.pink
                          : Colors.pink[200],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Next button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    _currentStep < _storySteps.length - 1
                        ? '👵 Dinle'
                        : '🎨 Görevlere Başla!',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
