import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class WelcomeStoryScreen extends StatefulWidget {
  const WelcomeStoryScreen({super.key});

  @override
  State<WelcomeStoryScreen> createState() => _WelcomeStoryScreenState();
}

class _WelcomeStoryScreenState extends State<WelcomeStoryScreen> {
  int _currentStep = 0;

  final List<Map<String, String>> _storySteps = [
    {
      'emoji': '🏘️',
      'title': 'Yeni Mahallene Hoş Geldin!',
      'message': 'Bugün büyük gün! Yeni mahallemize taşınıyoruz. Burada yeni arkadaşlar ve komşular edineceksin! 🎉',
    },
    {
      'emoji': '🏡',
      'title': 'Güzel Mahalle',
      'message': 'Burada herkes birbirine yardım eder. Sen de mahallenin bir parçası olacaksın! Hazır mısın? 😊',
    },
  ];

  void _nextStep() {
    if (_currentStep < _storySteps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      final gameProvider = Provider.of<GameProvider>(context, listen: false);
      gameProvider.markWelcomeSeen();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStory = _storySteps[_currentStep];

    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Emoji
              Text(
                currentStory['emoji']!,
                style: const TextStyle(fontSize: 120),
              ),
              const SizedBox(height: 40),

              // Title
              Container(
                padding: const EdgeInsets.all(20),
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
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      currentStory['message']!,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Progress indicator
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
                          ? Colors.blue
                          : Colors.blue[200],
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
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    _currentStep < _storySteps.length - 1
                        ? 'Devam Et ➡️'
                        : 'Başlayalım! 🎮',
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
