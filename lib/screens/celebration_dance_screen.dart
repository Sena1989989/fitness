import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'celebration_completion_screen.dart';
import 'dart:async';

class CelebrationDanceScreen extends StatefulWidget {
  const CelebrationDanceScreen({super.key});

  @override
  State<CelebrationDanceScreen> createState() => _CelebrationDanceScreenState();
}

class _CelebrationDanceScreenState extends State<CelebrationDanceScreen>
    with TickerProviderStateMixin {
  int _danceCount = 0;
  final int _targetDances = 10;
  Timer? _timer;
  List<String> _dancers = [];
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  final List<String> _dancerEmojis = [
    '👵', // Fatma Teyze
    '👨', // Ali Abi
    '👧',
    '👦',
    '🧒',
    '👶',
  ];

  @override
  void initState() {
    super.initState();
    _initializeDancers();
    _startMusic();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _initializeDancers() {
    setState(() {
      _dancers = List.from(_dancerEmojis)..shuffle();
    });
  }

  void _startMusic() {
    // Otomatik dans animasyonu
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _dancers.shuffle();
      });
    });
  }

  void _performDance() {
    if (_danceCount >= _targetDances) return;

    setState(() {
      _danceCount++;
    });

    _controller.forward().then((_) => _controller.reverse());

    if (_danceCount >= _targetDances) {
      _finishCelebration();
    }
  }

  void _finishCelebration() {
    _timer?.cancel();
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.completeCelebration();

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const CelebrationCompletionScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final progress = _danceCount / _targetDances;

    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: const Text('🎵 Bayram Kutlaması'),
        backgroundColor: Colors.purple,
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
                  'Müzikle dans et! 🎶\nEkrana dokun ve eğlen! 💃',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
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
                      'Dans Sayısı: $_danceCount / $_targetDances',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300],
                      color: Colors.purple,
                      minHeight: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Dans alanı
              Expanded(
                child: GestureDetector(
                  onTap: _performDance,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.pink[100]!,
                          Colors.purple[100]!,
                          Colors.blue[100]!,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.purple, width: 3),
                    ),
                    child: Stack(
                      children: [
                        // Müzik notaları
                        ...List.generate(
                          5,
                          (index) => Positioned(
                            top: (index * 80.0) + 20,
                            left: (index % 2 == 0) ? 20.0 : null,
                            right: (index % 2 == 1) ? 20.0 : null,
                            child: const Text(
                              '🎵',
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                        ),

                        // Dansçılar
                        Center(
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              alignment: WrapAlignment.center,
                              children: _dancers.map((emoji) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      emoji,
                                      style: const TextStyle(fontSize: 50),
                                    ),
                                    const Text(
                                      '💃',
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),

                        // Oyuncunun karakteri (ortada, büyük)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                gameProvider.selectedAvatar?.emoji ?? '😊',
                                style: const TextStyle(fontSize: 80),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'SEN! 🎉',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Dans butonu
              if (_danceCount < _targetDances)
                SizedBox(
                  width: double.infinity,
                  height: 80,
                  child: ElevatedButton(
                    onPressed: _performDance,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      '💃 DANS ET! 🕺',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      '🎊 Harika Dans Ettin! 🎊',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
