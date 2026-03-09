import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/furniture.dart';
import '../theme/app_theme.dart';

class HomeInventoryScreen extends StatefulWidget {
  final List<String> flyInEmojis;

  const HomeInventoryScreen({
    super.key,
    this.flyInEmojis = const [],
  });

  @override
  State<HomeInventoryScreen> createState() => _HomeInventoryScreenState();
}

class _HomeInventoryScreenState extends State<HomeInventoryScreen>
    with SingleTickerProviderStateMixin {
  final Map<int, Furniture> _placedFurniture = {};
  final List<int> _specialRewardIds = [9, 10, 12, 16, 20, 21, 22, 23];
  late final AnimationController _flyController;
  bool _showFlyAnimation = false;
  List<Furniture> _resolvedFlyRewards = [];

  @override
  void initState() {
    super.initState();
    _flyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    if (widget.flyInEmojis.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final gameProvider = Provider.of<GameProvider>(context, listen: false);
        _resolvedFlyRewards = _resolveFlyRewards(gameProvider, widget.flyInEmojis);

        setState(() {
          _showFlyAnimation = true;
        });

        _flyController.forward().whenComplete(() {
          if (!mounted) return;
          setState(() {
            _showFlyAnimation = false;
            _autoPlaceFlyRewards();
          });
        });
      });
    }
  }

  @override
  void dispose() {
    _flyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final specials = gameProvider.unlockedFurniture.where((f) {
      final id = int.tryParse(f.id);
      return id != null && _specialRewardIds.contains(id);
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.bgBottom,
      appBar: AppBar(
        title: const Text('🏠 Evim'),
        backgroundColor: AppTheme.appBar,
        centerTitle: true,
        actions: [
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
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: AppTheme.neonPanel(),
              child: const Text(
                '🎨 Eşyaları sürükle ve evine bırak!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.neonCyan,
                ),
              ),
            ),
            const SizedBox(height: 12),

            _buildRoomArea(),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.neonPanel(borderColor: AppTheme.neonPink, borderWidth: 1.2),
              child: Column(
                children: [
                  const Text(
                    '🎁 Eşyalarım',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.neonPink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: gameProvider.unlockedFurniture.isEmpty
                        ? const Center(
                            child: Text(
                              'Henüz eşyan yok.\nGörev tamamla ve buraya eşya ekle! 😊',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: gameProvider.unlockedFurniture.length,
                            itemBuilder: (context, index) {
                              final furniture =
                                  gameProvider.unlockedFurniture[index];
                              return _buildUnlockedFurnitureCard(furniture, true);
                            },
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            if (specials.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.purple.shade200),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: specials
                      .map((f) => Chip(
                            label: Text('${f.emoji} ${f.name}'),
                            backgroundColor: Colors.white,
                          ))
                      .toList(),
                ),
              ),
            if (specials.isNotEmpty) const SizedBox(height: 16),

            // Mağaza başlığı
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.neonPanel(borderWidth: 1.2),
              child: const Text(
                '🛒 Eşya Mağazası',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.neonCyan,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),

            // Satın alınabilir eşyalar
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: gameProvider.furniture.length,
                itemBuilder: (context, index) {
                  final furniture = gameProvider.furniture[index];
                  return _buildFurnitureCard(
                    context,
                    furniture,
                    gameProvider,
                  );
                },
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildRoomArea() {
    return Container(
      height: 220,
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.neonCyan, width: 2),
      ),
      child: Column(
        children: [
          const Text(
            '🏡 Ev İçi Dekor Alanı',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.neonCyan),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    GridView.builder(
                      itemCount: 6,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (context, slot) {
                        return DragTarget<Furniture>(
                          onAcceptWithDetails: (details) {
                            setState(() {
                              _placedFurniture[slot] = details.data;
                            });
                          },
                          builder: (context, _, __) {
                            final item = _placedFurniture[slot];
                            return Container(
                              decoration: BoxDecoration(
                                color: item == null
                                    ? Colors.cyanAccent.withValues(alpha: 0.08)
                                    : Colors.greenAccent.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: item == null ? Colors.cyanAccent : Colors.greenAccent,
                                ),
                              ),
                              child: Center(
                                child: item == null
                                    ? const Text('➕', style: TextStyle(fontSize: 20))
                                    : Text(item.emoji, style: const TextStyle(fontSize: 34)),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    if (_showFlyAnimation)
                      ..._buildFlyingRewards(constraints.maxWidth, constraints.maxHeight),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFlyingRewards(double width, double height) {
    final rewards = widget.flyInEmojis.take(4).toList();
    final targets = <Offset>[
      Offset(width * 0.18, height * 0.24),
      Offset(width * 0.50, height * 0.24),
      Offset(width * 0.82, height * 0.24),
      Offset(width * 0.50, height * 0.68),
    ];

    return List.generate(rewards.length, (i) {
      final start = Offset(width * 0.5 + (i - 1.5) * 24, -20);
      final end = targets[i];
      return AnimatedBuilder(
        animation: _flyController,
        builder: (context, child) {
          final localT = ((_flyController.value - i * 0.08) / 0.85).clamp(0.0, 1.0);
          final curved = Curves.easeOutBack.transform(localT);
          final x = start.dx + (end.dx - start.dx) * curved;
          final y = start.dy + (end.dy - start.dy) * curved;

          return Positioned(
            left: x - 16,
            top: y - 16,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withValues(alpha: 0.45),
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Opacity(
                opacity: 1 - (_flyController.value * 0.2),
                child: Transform.scale(
                  scale: 1.3 - (_flyController.value * 0.3),
                  child: Text(
                    rewards[i],
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  List<Furniture> _resolveFlyRewards(
    GameProvider provider,
    List<String> emojis,
  ) {
    final pool = List<Furniture>.from(provider.unlockedFurniture);
    final resolved = <Furniture>[];

    for (final emoji in emojis) {
      final index = pool.indexWhere((item) => item.emoji == emoji);
      if (index != -1) {
        resolved.add(pool.removeAt(index));
      }
    }

    return resolved;
  }

  void _autoPlaceFlyRewards() {
    if (_resolvedFlyRewards.isEmpty) return;

    for (final reward in _resolvedFlyRewards) {
      final slot = _pickBestSlotForReward(reward);
      if (slot == null) break;
      _placedFurniture[slot] = reward;
    }
  }

  int? _pickBestSlotForReward(Furniture reward) {
    final emptySlots = List<int>.generate(6, (i) => i)
        .where((slot) => !_placedFurniture.containsKey(slot))
        .toList();
    if (emptySlots.isEmpty) return null;

    final preferred = _preferredSlotsForReward(reward)
        .where((slot) => emptySlots.contains(slot))
        .toList();

    if (preferred.isNotEmpty) {
      return preferred.first;
    }

    return emptySlots.first;
  }

  List<int> _preferredSlotsForReward(Furniture reward) {
    // Slot düzeni: [0,1,2] üst sıra, [3,4,5] alt sıra
    // Akıllı yerleşim: duvar/süs üstte, mobilya altta, kupalar merkezde.
    switch (reward.emoji) {
      case '🏮': // Bayram lambası
      case '✨': // Festival takı
      case '🎏': // Meydan bayrakları
      case '💡': // Lamba
      case '🎈': // Balon
        return [1, 0, 2, 4, 3, 5];

      case '🏆': // Kupa
      case '🏅': // Altın hatıra
      case '🍬': // Şekerlik
        return [4, 1, 3, 5, 0, 2];

      case '🪴': // Özel bitki
      case '🌺': // Bahçe dekoru
      case '🌸': // Bahçe çiçeği
      case '🌳': // Fidan köşesi
        return [3, 5, 4, 0, 2, 1];

      case '🪑': // Sandalye
      case '🛋️': // Koltuk
      case '🛏️': // Yatak
      case '🧸': // Oyuncak kutusu
        return [3, 4, 5, 1, 0, 2];

      default:
        return [4, 3, 5, 1, 0, 2];
    }
  }

  Widget _buildUnlockedFurnitureCard(Furniture furniture, bool draggable) {
    final card = Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(furniture.emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 4),
          Text(
            furniture.name,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

    if (!draggable) return card;

    return Draggable<Furniture>(
      data: furniture,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(width: 90, child: card),
      ),
      childWhenDragging: Opacity(opacity: 0.4, child: card),
      child: card,
    );
  }

  Widget _buildFurnitureCard(
    BuildContext context,
    Furniture furniture,
    GameProvider gameProvider,
  ) {
    final canAfford = gameProvider.points >= furniture.cost;
    final isUnlocked = furniture.isUnlocked;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isUnlocked ? Colors.green[50] : Colors.white,
          border: Border.all(
            color: isUnlocked ? Colors.green : Colors.blue[200]!,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Emoji
              Opacity(
                opacity: isUnlocked ? 0.5 : 1.0,
                child: Text(
                  furniture.emoji,
                  style: const TextStyle(fontSize: 50),
                ),
              ),
              const SizedBox(height: 8),

              // Name
              Text(
                furniture.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  decoration: isUnlocked ? TextDecoration.lineThrough : null,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Price
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${furniture.cost}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Buy button
              if (!isUnlocked)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: canAfford
                        ? () {
                            final success =
                                gameProvider.buyFurniture(furniture);
                            if (success) {
                              _showPurchaseDialog(context, furniture);
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          canAfford ? Colors.blue : Colors.grey[300],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: Text(
                      canAfford ? '🛒 Al' : '❌ Yetersiz',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              else
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 32,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context, Furniture furniture) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          '🎉 Satın Alındı!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              furniture.emoji,
              style: const TextStyle(fontSize: 60),
            ),
            const SizedBox(height: 16),
            Text(
              '${furniture.name} evinize eklendi!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Text(
              'Harika! Evine yeni eşya ekledin! 🏡',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '😊 Süper!',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
