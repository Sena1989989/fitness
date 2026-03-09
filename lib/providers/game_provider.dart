import 'package:flutter/foundation.dart';
import '../models/avatar.dart';
import '../models/task.dart';
import '../models/furniture.dart';
import '../models/bicycle.dart';

class AvatarAccessory {
  final String id;
  final String name;
  final String emoji;
  final String type;
  bool isUnlocked;

  AvatarAccessory({
    required this.id,
    required this.name,
    required this.emoji,
    required this.type,
    this.isUnlocked = false,
  });
}

class GameProvider with ChangeNotifier {
  Avatar? _selectedAvatar;
  int _points = 0;
  final List<Task> _tasks = [];
  final List<Furniture> _furniture = [];
  final List<Avatar> _availableAvatars = [];
  final List<Bicycle> _availableBicycles = [];
  final List<AvatarAccessory> _avatarAccessories = [];
  String? _selectedAccessoryId;
  
  // Hikaye durumu - Bölüm 1
  bool _hasSeenWelcome = false;
  bool _hasMetAyseTeyze = false;
  bool _firstTaskCompleted = false;
  
  // Hikaye durumu - Bölüm 2
  bool _hasMetAliAbi = false;
  Bicycle? _selectedBicycle;
  bool _raceCompleted = false;
  
  // Hikaye durumu - Bölüm 3
  bool _hasMetNeighbors = false;
  bool _decorationTaskCompleted = false;
  bool _dessertTaskCompleted = false;
  bool _animalFeedingCompleted = false;
  bool _celebrationCompleted = false;
  
  // Hikaye durumu - Bölüm 4
  bool _hasMetCleaningTeam = false;
  bool _trashCollectionCompleted = false;
  bool _treePlantingCompleted = false;
  bool _neighborhoodBeautificationCompleted = false;
  
  // Hikaye durumu - Final Bölüm
  bool _festivalStarted = false;
  bool _finalRewardClaimed = false;
  bool _communitySquareDecorUnlocked = false;
  
  int _currentStoryStep = 0;

  GameProvider() {
    _initializeAvatars();
    _initializeTasks();
    _initializeFurniture();
    _initializeBicycles();
    _initializeAccessories();
  }

  Avatar? get selectedAvatar => _selectedAvatar;
  AvatarAccessory? get selectedAccessory {
    if (_selectedAccessoryId == null) return null;
    for (final accessory in _avatarAccessories) {
      if (accessory.id == _selectedAccessoryId) return accessory;
    }
    return null;
  }
  int get points => _points;
  List<Task> get tasks => _tasks;
  List<Furniture> get furniture => _furniture;
  List<Avatar> get availableAvatars => _availableAvatars;
  List<AvatarAccessory> get avatarAccessories => _avatarAccessories;
  List<AvatarAccessory> get unlockedAccessories =>
      _avatarAccessories.where((a) => a.isUnlocked).toList();
  List<Furniture> get unlockedFurniture =>
      _furniture.where((f) => f.isUnlocked).toList();
  List<Bicycle> get availableBicycles => _availableBicycles;
  
  // Hikaye getters - Bölüm 1
  bool get hasSeenWelcome => _hasSeenWelcome;
  bool get hasMetAyseTeyze => _hasMetAyseTeyze;
  bool get firstTaskCompleted => _firstTaskCompleted;
  int get currentStoryStep => _currentStoryStep;
  bool get isInStoryMode => !_firstTaskCompleted;
  
  // Hikaye getters - Bölüm 2
  bool get hasMetAliAbi => _hasMetAliAbi;
  Bicycle? get selectedBicycle => _selectedBicycle;
  bool get raceCompleted => _raceCompleted;
  bool get canStartChapter2 => _firstTaskCompleted && !_raceCompleted;
  
  // Hikaye getters - Bölüm 3
  bool get hasMetNeighbors => _hasMetNeighbors;
  bool get decorationTaskCompleted => _decorationTaskCompleted;
  bool get dessertTaskCompleted => _dessertTaskCompleted;
  bool get animalFeedingCompleted => _animalFeedingCompleted;
  bool get celebrationCompleted => _celebrationCompleted;
  bool get canStartChapter3 => _raceCompleted && !_celebrationCompleted;
  bool get allCelebrationTasksCompleted => 
      _decorationTaskCompleted && _dessertTaskCompleted && _animalFeedingCompleted;
  
    // Hikaye getters - Bölüm 4
    bool get hasMetCleaningTeam => _hasMetCleaningTeam;
    bool get trashCollectionCompleted => _trashCollectionCompleted;
    bool get treePlantingCompleted => _treePlantingCompleted;
    bool get neighborhoodBeautificationCompleted => _neighborhoodBeautificationCompleted;
    bool get canStartChapter4 => _celebrationCompleted && !_neighborhoodBeautificationCompleted;
    bool get allBeautificationTasksCompleted =>
      _trashCollectionCompleted && _treePlantingCompleted;
  
    // Hikaye getters - Final Bölüm
    bool get festivalStarted => _festivalStarted;
    bool get finalRewardClaimed => _finalRewardClaimed;
    bool get communitySquareDecorUnlocked => _communitySquareDecorUnlocked;
    bool get canStartFinalChapter =>
        _neighborhoodBeautificationCompleted && !_finalRewardClaimed;

  void _initializeAvatars() {
    _availableAvatars.addAll([
      Avatar(id: '1', emoji: '👦', name: 'Erkek Çocuk'),
      Avatar(id: '2', emoji: '👧', name: 'Kız Çocuk'),
      Avatar(id: '3', emoji: '🧒', name: 'Çocuk 1'),
      Avatar(id: '4', emoji: '👶', name: 'Bebek'),
      Avatar(id: '5', emoji: '🧑', name: 'Çocuk 2'),
      Avatar(id: '6', emoji: '👨‍🦱', name: 'Erkek 1'),
    ]);
  }

  void _initializeTasks() {
    _tasks.addAll([
      Task(
        id: '1',
        title: 'Bahçeyi Sula',
        emoji: '💧',
        description: 'Bahçedeki çiçekleri sula',
        rewardPoints: 10,
      ),
      Task(
        id: '2',
        title: 'Hayvanları Besle',
        emoji: '🐕',
        description: 'Köpeği ve kediyi besle',
        rewardPoints: 15,
      ),
      Task(
        id: '3',
        title: 'Çöp At',
        emoji: '🗑️',
        description: 'Çöpleri çöp kutusuna at',
        rewardPoints: 8,
      ),
      Task(
        id: '4',
        title: 'Ağaç Dik',
        emoji: '🌱',
        description: 'Bahçeye yeni ağaç dik',
        rewardPoints: 20,
      ),
      Task(
        id: '5',
        title: 'Kuş Evine Yem Koy',
        emoji: '🐦',
        description: 'Kuşlara yem bırak',
        rewardPoints: 12,
      ),
    ]);
  }

  void _initializeFurniture() {
    _furniture.addAll([
      Furniture(id: '1', name: 'Koltuk', emoji: '🛋️', cost: 30),
      Furniture(id: '2', name: 'Yatak', emoji: '🛏️', cost: 50),
      Furniture(id: '3', name: 'Masa', emoji: '🪑', cost: 25),
      Furniture(id: '4', name: 'Lamba', emoji: '💡', cost: 15),
      Furniture(id: '5', name: 'TV', emoji: '📺', cost: 60),
      Furniture(id: '6', name: 'Kitaplık', emoji: '📚', cost: 40),
      Furniture(id: '7', name: 'Oyuncak Kutusu', emoji: '🧸', cost: 20),
      Furniture(id: '8', name: 'Saat', emoji: '🕐', cost: 18),
      Furniture(id: '9', name: 'Kupa', emoji: '🏆', cost: 100), // Yarış ödülü
      Furniture(id: '10', name: 'Bisiklet Dekoru', emoji: '🚴', cost: 100), // Yarış ödülü
      Furniture(id: '11', name: 'Bayram Süsü', emoji: '🎊', cost: 100), // Bayram ödülü
      Furniture(id: '12', name: 'Balon', emoji: '🎈', cost: 100), // Bayram ödülü
      Furniture(id: '13', name: 'Tatlı Tabağı', emoji: '🍰', cost: 100), // Bayram ödülü
      Furniture(id: '14', name: 'Bahçe Çiçeği', emoji: '🌸', cost: 100), // 4. bölüm ödülü
      Furniture(id: '15', name: 'Fidan Köşesi', emoji: '🌳', cost: 100), // 4. bölüm ödülü
      Furniture(id: '16', name: 'Altın Mahalle Hatırası', emoji: '🏅', cost: 200), // Final ödülü
      Furniture(id: '17', name: 'Meydan Bayrakları', emoji: '🎏', cost: 120), // Topluluk ödülü
      Furniture(id: '18', name: 'Festival Takı', emoji: '✨', cost: 150), // Topluluk ödülü
      Furniture(id: '19', name: 'Sandalye', emoji: '🪑', cost: 30), // Sorumluluk ödülü
      Furniture(id: '20', name: 'Bayram Lambası', emoji: '🏮', cost: 120), // Bayram ödülü
      Furniture(id: '21', name: 'Şekerlik', emoji: '🍬', cost: 120), // Bayram ödülü
      Furniture(id: '22', name: 'Özel Bitki', emoji: '🪴', cost: 130), // Doğa ödülü
      Furniture(id: '23', name: 'Bahçe Dekoru', emoji: '🌺', cost: 130), // Doğa ödülü
    ]);
  }

  void _initializeBicycles() {
    _availableBicycles.addAll([
      Bicycle(id: '1', name: 'Kırmızı Bisiklet', emoji: '🚲', color: 'Kırmızı'),
      Bicycle(id: '2', name: 'Mavi Bisiklet', emoji: '🚲', color: 'Mavi'),
      Bicycle(id: '3', name: 'Yeşil Bisiklet', emoji: '🚲', color: 'Yeşil'),
      Bicycle(id: '4', name: 'Sarı Bisiklet', emoji: '🚲', color: 'Sarı'),
      Bicycle(id: '5', name: 'Pembe Bisiklet', emoji: '🚲', color: 'Pembe'),
      Bicycle(id: '6', name: 'Mor Bisiklet', emoji: '🚲', color: 'Mor'),
    ]);
  }

  void _initializeAccessories() {
    _avatarAccessories.addAll([
      AvatarAccessory(id: 'a1', name: 'Bahçıvan Şapkası', emoji: '🧢', type: 'sapka'),
      AvatarAccessory(id: 'a2', name: 'Yarış Forması', emoji: '🦺', type: 'kiyafet'),
      AvatarAccessory(id: 'a3', name: 'Bayram Rozeti', emoji: '🎖️', type: 'rozet'),
      AvatarAccessory(id: 'a4', name: 'Doğa Tacı', emoji: '🌿', type: 'sapka'),
      AvatarAccessory(id: 'a5', name: 'Kutlama Emojisi', emoji: '🥳', type: 'ozel_emoji'),
    ]);
  }

  void selectAvatar(Avatar avatar) {
    _selectedAvatar = avatar;
    notifyListeners();
  }

  void equipAccessory(String accessoryId) {
    final hasAccessory = _avatarAccessories.any(
      (a) => a.id == accessoryId && a.isUnlocked,
    );
    if (!hasAccessory) return;
    _selectedAccessoryId = accessoryId;
    notifyListeners();
  }

  void _unlockAccessory(String accessoryId) {
    for (final accessory in _avatarAccessories) {
      if (accessory.id == accessoryId) {
        accessory.isUnlocked = true;
      }
    }
  }

  void grantRewardFurniture(List<String> furnitureIds) {
    for (final furnitureId in furnitureIds) {
      for (final item in _furniture) {
        if (item.id == furnitureId) {
          item.unlock();
        }
      }
    }
    notifyListeners();
  }

  void completeTask(Task task) {
    if (!task.isCompleted) {
      task.complete();
      _points += task.rewardPoints;
      
      // İlk görev (bahçe sulama) tamamlandıysa hikaye ilerler
      if (task.id == '1' && !_firstTaskCompleted) {
        _firstTaskCompleted = true;
        _unlockAccessory('a1');
      }
      
      notifyListeners();
    }
  }

  bool buyFurniture(Furniture furniture) {
    if (_points >= furniture.cost && !furniture.isUnlocked) {
      _points -= furniture.cost;
      furniture.unlock();
      notifyListeners();
      return true;
    }
    return false;
  }

  void resetTask(Task task) {
    task.isCompleted = false;
    notifyListeners();
  }
  
  // Hikaye metodları
  void markWelcomeSeen() {
    _hasSeenWelcome = true;
    notifyListeners();
  }
  
  void markAyseTeyzeMet() {
    _hasMetAyseTeyze = true;
    notifyListeners();
  }
  
  void advanceStoryStep() {
    _currentStoryStep++;
    notifyListeners();
  }
  
  // Bölüm 2 metodları
  void markAliAbiMet() {
    _hasMetAliAbi = true;
    notifyListeners();
  }
  
  void selectBicycle(Bicycle bicycle) {
    _selectedBicycle = bicycle;
    notifyListeners();
  }
  
  void completeRace() {
    _raceCompleted = true;
    // Yarış tamamlandığında puan ver
    _points += 25;
    _unlockAccessory('a2');
    notifyListeners();
  }
  
  // Bölüm 3 metodları
  void markNeighborsMet() {
    _hasMetNeighbors = true;
    notifyListeners();
  }
  
  void completeDecorationTask() {
    _decorationTaskCompleted = true;
    _points += 15;
    notifyListeners();
  }
  
  void completeDessertTask() {
    _dessertTaskCompleted = true;
    _points += 15;
    notifyListeners();
  }
  
  void completeAnimalFeedingTask() {
    _animalFeedingCompleted = true;
    _points += 15;
    notifyListeners();
  }
  
  void completeCelebration() {
    _celebrationCompleted = true;
    _points += 30;
    _unlockAccessory('a3');
    _unlockAccessory('a5');
    _communitySquareDecorUnlocked = true;
    notifyListeners();
  }
  
  // Bölüm 4 metodları
  void markCleaningTeamMet() {
    _hasMetCleaningTeam = true;
    notifyListeners();
  }
  
  void completeTrashCollectionTask() {
    _trashCollectionCompleted = true;
    _points += 20;
    notifyListeners();
  }
  
  void completeTreePlantingTask() {
    _treePlantingCompleted = true;
    _points += 25;
    notifyListeners();
  }
  
  void completeNeighborhoodBeautification() {
    _neighborhoodBeautificationCompleted = true;
    _points += 30;
    _unlockAccessory('a4');
    notifyListeners();
  }
  
  // Final bölüm metodları
  void startFestival() {
    _festivalStarted = true;
    _points += 40;
    notifyListeners();
  }
  
  void claimFinalReward() {
    _finalRewardClaimed = true;
    notifyListeners();
  }
  
  void resetStory() {
    _hasSeenWelcome = false;
    _hasMetAyseTeyze = false;
    _firstTaskCompleted = false;
    _hasMetAliAbi = false;
    _selectedBicycle = null;
    _raceCompleted = false;
    _hasMetNeighbors = false;
    _decorationTaskCompleted = false;
    _dessertTaskCompleted = false;
    _animalFeedingCompleted = false;
    _celebrationCompleted = false;
    _hasMetCleaningTeam = false;
    _trashCollectionCompleted = false;
    _treePlantingCompleted = false;
    _neighborhoodBeautificationCompleted = false;
    _festivalStarted = false;
    _finalRewardClaimed = false;
    _communitySquareDecorUnlocked = false;
    _selectedAccessoryId = null;
    for (final accessory in _avatarAccessories) {
      accessory.isUnlocked = false;
    }
    _currentStoryStep = 0;
    notifyListeners();
  }
}
