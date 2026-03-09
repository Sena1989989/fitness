import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'bicycle_selection_screen.dart';

class AliAbiMeetScreen extends StatefulWidget {
  const AliAbiMeetScreen({super.key});

  @override
  State<AliAbiMeetScreen> createState() => _AliAbiMeetScreenState();
}

class _AliAbiMeetScreenState extends State<AliAbiMeetScreen> {
  int _currentStep = 0;

  final List<Map<String, String>> _storySteps = [
    {
      'emoji': '👨',
      'title': 'Ali Abi ile Tanış',
      'message': 'Selam dostum! Ben Ali Abi. Mahallede spor etkinlikleri düzenliyorum. Bisiklete binmeyi sever misin? 🚲',
    },
    {
      'emoji': '🏁',
      'title': 'Bisiklet Yarışı',
      'message': 'Bugün eğlenceli bir bisiklet yarışı yapacağız! Parkurda engelleri geçeceğiz. Katılmak ister misin? 🎯',
    },
    {
      'emoji': '🤝',
      'title': 'Herkes Kazanır',
      'message': 'Bu yarışta herkes birlikte eğlenir! Önemli olan kazanmak değil, birlikte vakit geçirmek. Arkadaşlarınla tanış! 😊',
    },
  ];

  void _nextStep() {
    if (_currentStep < _storySteps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      final gameProvider = Provider.of<GameProvider>(context, listen: false);
      gameProvider.markAliAbiMet();
      
      // Bisiklet seçim ekranına git
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BicycleSelectionScreen(),
        ),
      );
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
              // Ali Abi Emoji
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
                        color: Colors.blue,
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
                        ? '👨 Dinle'
                        : '🚲 Bisiklet Seç!',
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
