import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'home_screen.dart';

class FinalFestivalScreen extends StatefulWidget {
  const FinalFestivalScreen({super.key});

  @override
  State<FinalFestivalScreen> createState() => _FinalFestivalScreenState();
}

class _FinalFestivalScreenState extends State<FinalFestivalScreen> {
  bool _festivalLaunched = false;

  void _launchFestival() {
    final provider = Provider.of<GameProvider>(context, listen: false);

    if (!_festivalLaunched) {
      provider.startFestival();
      provider.claimFinalReward();
      provider.grantRewardFurniture(['16']);
    }

    setState(() {
      _festivalLaunched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.amber[50],
      appBar: AppBar(
        title: const Text('🎆 Büyük Mahalle Festivali'),
        backgroundColor: Colors.amber,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🎉🎊🎉',
                style: TextStyle(fontSize: 56),
              ),
              const SizedBox(height: 12),
              const Text(
                '🏮✨👵 👨 👧 👦 🧒✨🏮',
                style: TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 24),
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
                      _festivalLaunched
                          ? '🏅 Festival Tamamlandı!'
                          : '✨ Son Bölüme Hoş Geldin!',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _festivalLaunched
                          ? 'Tüm görevleri tamamladın ve Büyük Mahalle Festivali başladı! Harika bir komşu oldun!'
                          : 'Tüm bölümleri bitirdin. Mahallede herkes seninle gurur duyuyor. Festivali başlatmaya hazır mısın?',
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '💡 Işıklarla süslenen meydanda dayanışma kutlanıyor!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.yellow[50],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.orange, width: 2),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '🎁 Final Ödülün',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text('🏅', style: TextStyle(fontSize: 60)),
                          const SizedBox(height: 4),
                          Text(
                            'Altın Mahalle Hatırası',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.star, color: Colors.orange, size: 22),
                              const SizedBox(width: 6),
                              Text(
                                '+40 puan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '💬 Hazır Mesajlar: "Harika iş!" "Birlikte başardık!" "Mahallemiz çok güzel!"',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.brown,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _festivalLaunched
                      ? () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      : _launchFestival,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    _festivalLaunched ? '🏠 Ana Ekrana Dön' : '🎆 Festivali Başlat',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (_festivalLaunched)
                Text(
                  'Toplam puan: ${provider.points}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
