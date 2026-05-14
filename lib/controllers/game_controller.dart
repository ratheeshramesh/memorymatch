import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import '../models/memory_card.dart';

class GameController extends ChangeNotifier {
  static const List<Map<String, String>> _cardData = [
    {'emoji': '🐶', 'label': 'Dog'},
    {'emoji': '🐱', 'label': 'Cat'},
    {'emoji': '🐭', 'label': 'Mouse'},
    {'emoji': '🐹', 'label': 'Hamster'},
    {'emoji': '🐰', 'label': 'Rabbit'},
    {'emoji': '🦊', 'label': 'Fox'},
    {'emoji': '🐻', 'label': 'Bear'},
    {'emoji': '🐼', 'label': 'Panda'},
    {'emoji': '🐨', 'label': 'Koala'},
    {'emoji': '🐯', 'label': 'Tiger'},
  ];

  final List<Color> cardColors = [
    const Color(0xFFEF5350),
    const Color(0xFFAB47BC),
    const Color(0xFF42A5F5),
    const Color(0xFF26A69A),
    const Color(0xFFFFCA28),
    const Color(0xFF66BB6A),
    const Color(0xFFFF7043),
    const Color(0xFF5C6BC0),
    const Color(0xFF26C6DA),
    const Color(0xFFEC407A),
  ];

  List<MemoryCard> _cards = [];
  List<int> _flippedIndices = [];
  int _moves = 0;
  int _matches = 0;
  bool _isProcessing = false;
  bool _gameWon = false;
  int _seconds = 0;
  Timer? _timer;
  bool isPreview = false;
  int currentColorIndex = 0;

  List<MemoryCard> get cards => _cards;
  int get moves => _moves;
  int get matches => _matches;
  bool get gameWon => _gameWon;
  int get seconds => _seconds;
  int get totalPairs => _cardData.length;

  GameController() {
    startNewGame();
  }

  void startNewGame() {
    // Cancel any existing timer immediately
    _timer?.cancel();
    _timer = null;

    _seconds = 0;
    _moves = 0;
    _matches = 0;
    _flippedIndices = [];
    _isProcessing = false;
    _gameWon = false;

    // Pick a new random color for this game
    currentColorIndex = Random().nextInt(cardColors.length);

    // Create pairs and shuffle — start face UP for preview
    final List<MemoryCard> deck = [];
    for (int i = 0; i < _cardData.length; i++) {
      deck.add(MemoryCard(id: i, emoji: _cardData[i]['emoji']!, label: _cardData[i]['label']!, isFaceUp: true));
      deck.add(MemoryCard(id: i, emoji: _cardData[i]['emoji']!, label: _cardData[i]['label']!, isFaceUp: true));
    }
    deck.shuffle();
    _cards = deck;

    // Show preview
    isPreview = true;
    notifyListeners();

    // After 3 seconds flip all cards down and start timer
    Future.delayed(const Duration(seconds: 3), () {
      _cards = _cards.map((c) => c.copyWith(isFaceUp: false)).toList();
      isPreview = false;
      notifyListeners();

      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!_gameWon) {
          _seconds++;
          notifyListeners();
        }
      });
    });
  }

  void flipCard(int index) {
    if (isPreview) return;
    if (_isProcessing) return;
    if (_cards[index].isMatched) return;
    if (_cards[index].isFaceUp) return;
    if (_flippedIndices.length >= 2) return;

    _cards[index] = _cards[index].copyWith(isFaceUp: true);
    _flippedIndices.add(index);
    notifyListeners();

    if (_flippedIndices.length == 2) {
      _moves++;
      _checkMatch();
    }
  }

  void _checkMatch() {
    _isProcessing = true;
    final int first = _flippedIndices[0];
    final int second = _flippedIndices[1];

    if (_cards[first].id == _cards[second].id) {
      Future.delayed(const Duration(milliseconds: 600), () {
        _cards[first] = _cards[first].copyWith(isMatched: true);
        _cards[second] = _cards[second].copyWith(isMatched: true);
        _matches++;
        _flippedIndices = [];
        _isProcessing = false;
        if (_matches == totalPairs) {
          _gameWon = true;
          _timer?.cancel();
        }
        notifyListeners();
      });
    } else {
      Future.delayed(const Duration(milliseconds: 1000), () {
        _cards[first] = _cards[first].copyWith(isFaceUp: false);
        _cards[second] = _cards[second].copyWith(isFaceUp: false);
        _flippedIndices = [];
        _isProcessing = false;
        notifyListeners();
      });
    }
  }

  String get formattedTime {
    final minutes = _seconds ~/ 60;
    final secs = _seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
