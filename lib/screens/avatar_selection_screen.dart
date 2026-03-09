import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/avatar.dart';
import 'ayse_teyze_meet_screen.dart';
import '../theme/app_theme.dart';

class AvatarSelectionScreen extends StatefulWidget {
  const AvatarSelectionScreen({super.key});

  @override
  State<AvatarSelectionScreen> createState() => _AvatarSelectionScreenState();
}

class _AvatarSelectionScreenState extends State<AvatarSelectionScreen> {
  Avatar? _pendingAvatar;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    _pendingAvatar ??= gameProvider.selectedAvatar;
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.bgBottom,
      appBar: AppBar(
        title: const Text('👤 Avatar Seç'),
        backgroundColor: AppTheme.appBar,
        centerTitle: true,
      ),
      body: Container(
        decoration: AppTheme.neonPageGradient(),
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.neonPanel(),
              child: const Text(
                'Karakterini seç! 😊',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.neonCyan,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 330,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                itemCount: gameProvider.availableAvatars.length,
                itemBuilder: (context, index) {
                  final avatar = gameProvider.availableAvatars[index];
                  final isSelected = _pendingAvatar?.id == avatar.id;

                  return _buildAvatarCard(
                    context,
                    avatar,
                    isSelected,
                    () {
                      setState(() {
                        _pendingAvatar = avatar;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: _pendingAvatar == null
                    ? null
                    : () {
                        gameProvider.selectAvatar(_pendingAvatar!);
                        if (gameProvider.isInStoryMode && !gameProvider.hasMetAyseTeyze) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AyseTeyzeMeetScreen(),
                            ),
                          );
                          return;
                        }
                        Navigator.pop(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.neonPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  '✅ Onayla',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: AppTheme.neonPanel(borderColor: AppTheme.neonPink, borderWidth: 1.2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🎒 Avatar Aksesuarları',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.neonPink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: gameProvider.avatarAccessories.map((accessory) {
                      final isSelected = gameProvider.selectedAccessory?.id == accessory.id;
                      return ChoiceChip(
                        label: Text('${accessory.emoji} ${accessory.name}'),
                        selected: isSelected,
                        onSelected: accessory.isUnlocked
                            ? (_) => gameProvider.equipAccessory(accessory.id)
                            : null,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildAvatarCard(
    BuildContext context,
    Avatar avatar,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected
                ? [
                    const Color(0x66A7FFEB),
                    const Color(0x667EA3FF),
                    const Color(0x66FF80AB),
                  ]
                : [
                    Colors.white.withValues(alpha: 0.12),
                    Colors.white.withValues(alpha: 0.06),
                  ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.cyanAccent : Colors.purple[200]!,
            width: isSelected ? 4 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Colors.cyanAccent.withValues(alpha: 0.6)
                  : Colors.black.withValues(alpha: 0.2),
              blurRadius: isSelected ? 20 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              avatar.emoji,
              style: const TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 8),
            Text(
              avatar.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            if (isSelected) ...[
              const SizedBox(height: 8),
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 32,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
