import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'avatar_selection_screen.dart';
import 'tasks_screen.dart';
import 'home_inventory_screen.dart';
import 'welcome_story_screen.dart';
import 'ayse_teyze_meet_screen.dart';
import 'ali_abi_meet_screen.dart';
import 'bicycle_selection_screen.dart';
import 'neighbors_meet_screen.dart';
import 'celebration_tasks_screen.dart';
import 'cleaning_team_meet_screen.dart';
import 'beautification_tasks_screen.dart';
import 'final_festival_screen.dart';
import 'neighborhood_map_screen.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // İlk açılışta hoş geldin hikayesini göster
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gameProvider = Provider.of<GameProvider>(context, listen: false);
      if (!gameProvider.hasSeenWelcome) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const WelcomeStoryScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final hasAvatar = gameProvider.selectedAvatar != null;

    return Scaffold(
      backgroundColor: AppTheme.bgBottom,
      appBar: AppBar(
        title: const Text('🏘️ Sanal Mahalle'),
        backgroundColor: AppTheme.appBar,
        centerTitle: true,
        actions: [
          if (hasAvatar)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.yellow),
                  const SizedBox(width: 4),
                  Text(
                    '${gameProvider.points}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
        ],
      ),
      body: Container(
        decoration: AppTheme.neonPageGradient(),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hoş geldin mesajı
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: AppTheme.neonPanel(borderWidth: 2),
                  child: Column(
                    children: [
                      const Text(
                        '🏡',
                        style: TextStyle(fontSize: 80),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        hasAvatar
                            ? 'Mahallene Hoş Geldin!'
                            : 'Mahallene Hoş Geldin!',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.neonCyan,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      if (hasAvatar)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              gameProvider.selectedAvatar!.emoji,
                              style: const TextStyle(fontSize: 60),
                            ),
                            if (gameProvider.selectedAccessory != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                gameProvider.selectedAccessory!.emoji,
                                style: const TextStyle(fontSize: 34),
                              ),
                            ],
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                if (hasAvatar)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: AppTheme.neonPanel(
                      borderColor: AppTheme.neonPink,
                      borderWidth: 2,
                    ),
                    child: const Text(
                      '🔁 Döngü: Görev → Sosyal Etkileşim → Ödül → Ev Geliştirme',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.neonPink,
                      ),
                    ),
                  ),
                if (hasAvatar) const SizedBox(height: 16),

                _buildMenuButton(
                  context,
                  hasAvatar ? '👤 Avatar Seç / Değiştir' : '👤 Avatar Seç',
                  Colors.purple,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AvatarSelectionScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                if (hasAvatar) ...[
                  _buildMenuButton(
                    context,
                    '📋 Görevler',
                    Colors.orange,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TasksScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildMenuButton(
                    context,
                    '🗺️ Mahalle Haritası',
                    Colors.cyan,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NeighborhoodMapScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildMenuButton(
                    context,
                    '🏠 Evim',
                    Colors.blue,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeInventoryScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 18),

                  const Divider(thickness: 2),
                  const SizedBox(height: 10),

                  // İkinci bölüm butonu (ilk bölüm tamamlandıysa)
                  if (gameProvider.canStartChapter2)
                    _buildMenuButton(
                      context,
                      gameProvider.hasMetAliAbi
                          ? '🏁 Bisiklet Yarışına Devam'
                          : '🚲 Ali Abi ile Tanış',
                      Colors.blue,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => gameProvider.hasMetAliAbi
                                ? const BicycleSelectionScreen()
                                : const AliAbiMeetScreen(),
                          ),
                        );
                      },
                    ),
                  if (gameProvider.canStartChapter2) const SizedBox(height: 16),
                  
                  // Üçüncü bölüm butonu (ikinci bölüm tamamlandıysa)
                  if (gameProvider.canStartChapter3)
                    _buildMenuButton(
                      context,
                      gameProvider.hasMetNeighbors
                          ? '🎨 Bayram Görevlerine Devam'
                          : '🎊 Bayram Kutlaması',
                      Colors.pink,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => gameProvider.hasMetNeighbors
                                ? const CelebrationTasksScreen()
                                : const NeighborsMeetScreen(),
                          ),
                        );
                      },
                    ),
                  if (gameProvider.canStartChapter3) const SizedBox(height: 16),

                  // Dördüncü bölüm butonu (üçüncü bölüm tamamlandıysa)
                  if (gameProvider.canStartChapter4)
                    _buildMenuButton(
                      context,
                      gameProvider.hasMetCleaningTeam
                          ? '🧹 Güzelleştirme Görevlerine Devam'
                          : '🌿 Mahalleyi Güzelleştir',
                      Colors.teal,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => gameProvider.hasMetCleaningTeam
                                ? const BeautificationTasksScreen()
                                : const CleaningTeamMeetScreen(),
                          ),
                        );
                      },
                    ),
                  if (gameProvider.canStartChapter4) const SizedBox(height: 16),

                  // Final bölüm butonu (4. bölüm tamamlandıysa)
                  if (gameProvider.canStartFinalChapter)
                    _buildMenuButton(
                      context,
                      '🎆 Büyük Mahalle Festivali',
                      Colors.deepOrange,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FinalFestivalScreen(),
                          ),
                        );
                      },
                    ),
                  if (gameProvider.canStartFinalChapter) const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String text,
    Color color,
    VoidCallback onPressed,
  ) {
    final neon = color;
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              neon.withValues(alpha: 0.95),
              neon.withValues(alpha: 0.65),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: neon.withValues(alpha: 0.45),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
            const BoxShadow(
              color: Colors.black54,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
          border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.3),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
