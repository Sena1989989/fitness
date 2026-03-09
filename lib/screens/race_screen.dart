import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'race_completion_screen.dart';
import 'dart:async';

class RaceScreen extends StatefulWidget {
  const RaceScreen({super.key});

  @override
  State<RaceScreen> createState() => _RaceScreenState();
}

class _RaceScreenState extends State<RaceScreen> {
  double _progress = 0.0;
  int _obstaclesPassed = 0;
  final int _totalObstacles = 5;
  bool _isRacing = false;
  Timer? _timer;
  
  // Diğer yarışçılar
  final List<Map<String, dynamic>> _racers = [
    {'emoji': '👧', 'name': 'Ayşe', 'progress': 0.0},
    {'emoji': '👦', 'name': 'Mehmet', 'progress': 0.0},
    {'emoji': '🧒', 'name': 'Zeynep', 'progress': 0.0},
  ];

  @override
  void initState() {
    super.initState();
    _startRace();
  }

  void _startRace() {
    setState(() {
      _isRacing = true;
    });

    // Diğer yarışçıları otomatik ilerlet
    _timer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      setState(() {
        for (var racer in _racers) {
          if (racer['progress'] < 1.0) {
            racer['progress'] += 0.15 + (0.1 * (racer['progress'] * 0.5));
            if (racer['progress'] > 1.0) racer['progress'] = 1.0;
          }
        }
      });
    });
  }

  void _handleTap() {
    if (!_isRacing || _progress >= 1.0) return;

    setState(() {
      _progress += 0.2;
      if (_progress > 1.0) _progress = 1.0;
      
      // Engel sayısını güncelle
      int newObstacles = (_progress * _totalObstacles).floor();
      if (newObstacles > _obstaclesPassed) {
        _obstaclesPassed = newObstacles;
      }
      
      // Yarış tamamlandı
      if (_progress >= 1.0) {
        _finishRace();
      }
    });
  }

  void _finishRace() {
    _timer?.cancel();
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.completeRace();

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const RaceCompletionScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text('🏁 Bisiklet Yarışı'),
        backgroundColor: Colors.blue,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Talimat
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  'Ekrana dokun ve parkuru tamamla! 🚴',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),

              // İlerleme
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      'Geçilen Engeller: $_obstaclesPassed / $_totalObstacles',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue,
                      minHeight: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Yarış pisti
              Expanded(
                child: GestureDetector(
                  onTap: _handleTap,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green, width: 3),
                    ),
                    child: Stack(
                      children: [
                        // Parkur çizgileri
                        ...List.generate(
                          _totalObstacles + 1,
                          (index) => Positioned(
                            top: (index / _totalObstacles) * 
                                (MediaQuery.of(context).size.height * 0.5),
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 2,
                              color: Colors.green[300],
                            ),
                          ),
                        ),

                        // Oyuncunun bisikleti
                        Positioned(
                          top: _progress * (MediaQuery.of(context).size.height * 0.5) - 30,
                          left: 20,
                          child: Column(
                            children: [
                              Text(
                                gameProvider.selectedAvatar?.emoji ?? '😊',
                                style: const TextStyle(fontSize: 30),
                              ),
                              Text(
                                gameProvider.selectedBicycle?.emoji ?? '🚲',
                                style: const TextStyle(fontSize: 40),
                              ),
                            ],
                          ),
                        ),

                        // Diğer yarışçılar
                        ..._racers.asMap().entries.map((entry) {
                          int idx = entry.key;
                          var racer = entry.value;
                          return Positioned(
                            top: racer['progress'] * 
                                (MediaQuery.of(context).size.height * 0.5) - 30,
                            left: 100.0 + (idx * 80.0),
                            child: Column(
                              children: [
                                Text(
                                  racer['emoji'],
                                  style: const TextStyle(fontSize: 30),
                                ),
                                const Text(
                                  '🚲',
                                  style: TextStyle(fontSize: 40),
                                ),
                              ],
                            ),
                          );
                        }).toList(),

                        // Finish line
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.orange, width: 2),
                              ),
                              child: const Text(
                                '🏁 BİTİŞ 🏁',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tap butonu
              if (_progress < 1.0)
                SizedBox(
                  width: double.infinity,
                  height: 80,
                  child: ElevatedButton(
                    onPressed: _handleTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      '🚴 PEDAL ÇEVİR! 🚴',
                      style: TextStyle(
                        fontSize: 24,
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
