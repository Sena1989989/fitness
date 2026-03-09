import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'beautification_tasks_screen.dart';

class CleaningTeamMeetScreen extends StatefulWidget {
  const CleaningTeamMeetScreen({super.key});

  @override
  State<CleaningTeamMeetScreen> createState() => _CleaningTeamMeetScreenState();
}

class _CleaningTeamMeetScreenState extends State<CleaningTeamMeetScreen> {
  int _currentStep = 0;

  final List<Map<String, String>> _storySteps = [
    {
      'emoji': '🌍',
      'title': 'Mahalleyi Güzelleştirelim',
      'message': 'Bayramdan sonra mahallemizi daha da güzel yapma zamanı! Hep birlikte çevre ekibi kurduk! 💚',
    },
    {
      'emoji': '🧹',
      'title': 'Temizlik Görevi',
      'message': 'Komşularla birlikte çöpleri toplayalım. Temiz sokaklar herkes için mutluluk demek! 😊',
    },
    {
      'emoji': '🌱',
      'title': 'Ağaç Dikme Görevi',
      'message': 'Yeni fidanlar dikelim. Daha çok ağaç, daha temiz hava! Hazırsan görevler başlıyor! 🌳',
    },
  ];

  void _nextStep() {
    if (_currentStep < _storySteps.length - 1) {
      setState(() {
        _currentStep++;
      });
      return;
    }

    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.markCleaningTeamMet();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const BeautificationTasksScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentStory = _storySteps[_currentStep];

    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                        color: Colors.teal,
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
                      color: index == _currentStep ? Colors.teal : Colors.teal[200],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    _currentStep < _storySteps.length - 1 ? '🤝 Dinle' : '🧹 Görevlere Başla!',
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
