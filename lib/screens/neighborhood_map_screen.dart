import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'player_home_area_screen.dart';
import 'ayse_garden_area_screen.dart';
import 'bike_repair_shop_area_screen.dart';
import 'town_square_area_screen.dart';
import 'park_playground_area_screen.dart';
import 'nature_area_screen.dart';
import '../theme/app_theme.dart';

class NeighborhoodMapScreen extends StatefulWidget {
  const NeighborhoodMapScreen({super.key});

  @override
  State<NeighborhoodMapScreen> createState() => _NeighborhoodMapScreenState();
}

class _NeighborhoodMapScreenState extends State<NeighborhoodMapScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _cloudController;
  late final AnimationController _roadGlowController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _roadGlowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _cloudController.dispose();
    _roadGlowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.bgBottom,
      appBar: AppBar(
        title: const Text('🗺️ Mahalle Haritası'),
        backgroundColor: AppTheme.appBar,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'Bulutlar hareket ediyor, yollar parlıyor! Alanlara dokunarak geçiş yap. ☁️✨',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return AnimatedBuilder(
                    animation: Listenable.merge([
                      _pulseController,
                      _cloudController,
                      _roadGlowController,
                    ]),
                    builder: (context, _) {
                      final pulseScale = 1 + (_pulseController.value * 0.06);
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF0B1E3B), Color(0xFF23124E)],
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _RoadPainter(glow: _roadGlowController.value),
                              ),
                            ),
                            _buildMovingCloud(constraints.maxWidth, 26, 0.0),
                            _buildMovingCloud(constraints.maxWidth, 58, 0.45),

                            _buildAreaNode(
                              context,
                              title: 'Oyuncunun Evi',
                              emoji: '🏠',
                              color: Colors.blue,
                              isLocked: false,
                              top: 28,
                              left: 18,
                              pulseScale: pulseScale,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PlayerHomeAreaScreen(),
                                ),
                              ),
                            ),
                            _buildAreaNode(
                              context,
                              title: 'Ayşe Bahçesi',
                              emoji: '👵🌻',
                              color: Colors.green,
                              isLocked: false,
                              top: 28,
                              right: 18,
                              pulseScale: pulseScale,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AyseGardenAreaScreen(),
                                ),
                              ),
                            ),
                            _buildAreaNode(
                              context,
                              title: 'Tamirhane',
                              emoji: '👨🚲',
                              color: Colors.indigo,
                              isLocked: !gameProvider.firstTaskCompleted,
                              top: 162,
                              left: 18,
                              pulseScale: pulseScale,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BikeRepairShopAreaScreen(),
                                ),
                              ),
                            ),
                            _buildAreaNode(
                              context,
                              title: 'Meydan',
                              emoji: '🎊🏟️',
                              color: Colors.pink,
                              isLocked: !gameProvider.raceCompleted,
                              top: 162,
                              right: 18,
                              pulseScale: pulseScale,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TownSquareAreaScreen(),
                                ),
                              ),
                            ),
                            _buildAreaNode(
                              context,
                              title: 'Park',
                              emoji: '🛝🌳',
                              color: Colors.orange,
                              isLocked: false,
                              bottom: 24,
                              left: 18,
                              pulseScale: pulseScale,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ParkPlaygroundAreaScreen(),
                                ),
                              ),
                            ),
                            _buildAreaNode(
                              context,
                              title: 'Doğa Alanı',
                              emoji: '🌲🌍',
                              color: Colors.teal,
                              isLocked: !gameProvider.celebrationCompleted,
                              bottom: 24,
                              right: 18,
                              pulseScale: pulseScale,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NatureAreaScreen(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
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

  Widget _buildMovingCloud(double width, double top, double phase) {
    final t = (_cloudController.value + phase) % 1;
    final x = (width + 80) * t - 80;
    return Positioned(
      top: top,
      left: x,
      child: const Opacity(
        opacity: 0.9,
        child: Text('☁️', style: TextStyle(fontSize: 28)),
      ),
    );
  }

  Widget _buildAreaNode(
    BuildContext context, {
    required String title,
    required String emoji,
    required Color color,
    required bool isLocked,
    double? top,
    double? left,
    double? right,
    double? bottom,
    required double pulseScale,
    required VoidCallback onTap,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Transform.scale(
        scale: isLocked ? 1.0 : pulseScale,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isLocked ? null : onTap,
          child: Container(
            width: 150,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xCC101A3A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isLocked ? Colors.grey : color,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: isLocked
                      ? Colors.black.withValues(alpha: 0.08)
                      : color.withValues(alpha: 0.60),
                  blurRadius: 18,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 30)),
                const SizedBox(height: 6),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isLocked ? Colors.grey : Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isLocked ? '🔒 Kilitli' : 'Dokun ve git',
                  style: TextStyle(
                    fontSize: 12,
                    color: isLocked ? Colors.grey : color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoadPainter extends CustomPainter {
  final double glow;

  _RoadPainter({required this.glow});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    final roadBase = Paint()
      ..color = Colors.white.withOpacity(0.55)
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(centerX, 40), Offset(centerX, size.height - 40), roadBase);
    canvas.drawLine(Offset(30, centerY), Offset(size.width - 30, centerY), roadBase);

    final glowPaint = Paint()
      ..color = Colors.yellow.withOpacity(0.25 + (glow * 0.25))
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(centerX, 40), Offset(centerX, size.height - 40), glowPaint);
    canvas.drawLine(Offset(30, centerY), Offset(size.width - 30, centerY), glowPaint);

    final square = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(centerX, centerY), 54, square);
    canvas.drawCircle(
      Offset(centerX, centerY),
      42,
      Paint()..color = Colors.orange.withOpacity(0.2 + glow * 0.2),
    );
  }

  @override
  bool shouldRepaint(covariant _RoadPainter oldDelegate) {
    return oldDelegate.glow != glow;
  }
}
