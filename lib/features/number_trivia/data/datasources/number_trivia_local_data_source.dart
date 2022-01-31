import 'dart:convert';
import 'package:flutter_tdd_clean_code/core/error/server_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  ///

  Future<NumberTriviaModel>? getLastNumberTrivia();

  Future<void>? cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const cachedNumberTriviaString = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences _sharedPreferences;

  NumberTriviaLocalDataSourceImpl({
    required sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  @override
  Future<NumberTriviaModel>? getLastNumberTrivia() {
    final jsonString = _sharedPreferences.getString(cachedNumberTriviaString);
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheExceptions();
    }
  }

  @override
  Future<bool> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    return _sharedPreferences.setString(
        cachedNumberTriviaString, json.encode(triviaToCache.toJson()));
  }
}
