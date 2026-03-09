import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'tasks_screen.dart';

class AyseTeyzeMeetScreen extends StatefulWidget {
  const AyseTeyzeMeetScreen({super.key});

  @override
  State<AyseTeyzeMeetScreen> createState() => _AyseTeyzeMeetScreenState();
}

class _AyseTeyzeMeetScreenState extends State<AyseTeyzeMeetScreen> {
  int _currentStep = 0;

  final List<Map<String, String>> _storySteps = [
    {
      'emoji': '👵',
      'title': 'Ayşe Teyze ile Tanış',
      'message': 'Merhaba tatlım! Ben Ayşe Teyze. Bu mahallede yıllardır yaşıyorum. Sana yardımcı olacağım! 💚',
    },
    {
      'emoji': '🌻',
      'title': 'İlk Görevin',
      'message': 'Bak, bahçem biraz susuz kalmış. Bana yardım eder misin? Çiçekleri sulamak onları çok mutlu eder! 💧',
    },
    {
      'emoji': '🎁',
      'title': 'Ödül Kazanacaksın',
      'message': 'Yardımların karşılığında sana güzel hediyeler vereceğim. Evinizi süslemek için eşyalar! Hadi başlayalım! ✨',
    },
  ];

  void _nextStep() {
    if (_currentStep < _storySteps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      final gameProvider = Provider.of<GameProvider>(context, listen: false);
      gameProvider.markAyseTeyzeMet();
      
      // Görevler ekranına git
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const TasksScreen(isFirstTask: true),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStory = _storySteps[_currentStep];

    return Scaffold(
      backgroundColor: Colors.green[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ayşe Teyze Emoji
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
                        color: Colors.green,
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
                          ? Colors.green
                          : Colors.green[200],
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
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    _currentStep < _storySteps.length - 1
                        ? '👵 Dinle'
                        : '💪 Göreve Başla!',
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
