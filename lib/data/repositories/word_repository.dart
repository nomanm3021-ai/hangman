import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/word_category.dart';

/// Repository for loading and managing word lists from JSON assets.
class WordRepository {
  /// Cache of loaded words to avoid multiple asset reads.
  final Map<String, List<WordEntry>> _categoryCache = {};

  /// Loads words for a given [categoryId]. Returns empty list if not found.
  Future<List<WordEntry>> getWordsForCategory(String categoryId) async {
    if (_categoryCache.containsKey(categoryId)) {
      return _categoryCache[categoryId]!;
    }

    try {
      final String jsonString =
          await rootBundle.loadString('assets/words/$categoryId.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      
      final List<WordEntry> words = jsonList
          .map((json) => WordEntry.fromJson(json as Map<String, dynamic>))
          .toList();
      
      _categoryCache[categoryId] = words;
      return words;
    } catch (e) {
      debugPrint('Error loading words for category $categoryId: $e');
      return [];
    }
  }

  /// Filters a list of [words] by the criteria of the given [difficulty].
  List<WordEntry> filterWordsByDifficulty(List<WordEntry> words, Difficulty difficulty) {
    return words.where((entry) {
      // Strip spaces to get the real length of the word for difficulty check
      final pureLength = entry.word.replaceAll(' ', '').length;
      return pureLength >= difficulty.minWordLength &&
             pureLength <= difficulty.maxWordLength;
    }).toList();
  }
}
