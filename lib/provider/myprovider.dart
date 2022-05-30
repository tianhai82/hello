import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WordPairRepo extends StateNotifier<Set<WordPair>> {
  WordPairRepo() : super(<WordPair>{});

  void add(WordPair wp) {
    state.add(wp);
    state = state;
  }

  void remove(WordPair wp) {
    state.remove(wp);
    state = state;
  }

  bool contains(WordPair wp) => state.contains(wp);

  List<WordPair> all() {
    return state.toList();
  }
}

final wordPairProvider =
    StateNotifierProvider<WordPairRepo, Set<WordPair>>((ref) {
  return WordPairRepo();
});

final bigFontProvider = Provider((ref) => const TextStyle(fontSize: 18));
