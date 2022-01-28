import 'package:flutter_tdd_clean_code/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  /// 
  /// ! PQ QUANDO TIRO O ? O TESTE NAO PASSA???? 
  /// ! Será que é pq estou apenas verificando chamada de metodo?
  ///  ? type 'Null' is not a subtype of type 'Future<void>'
  Future<NumberTriviaModel>? getLastNumberTrivia();

  Future<void>? cacheNumberTrivia(NumberTriviaModel triviaToCache);
}
