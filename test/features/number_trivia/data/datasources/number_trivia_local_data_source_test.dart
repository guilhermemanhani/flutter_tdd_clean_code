import 'dart:convert';

import 'package:flutter_tdd_clean_code/core/error/server_exceptions.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateMocks([
  SharedPreferences
], customMocks: [
  MockSpec<SharedPreferences>(
      as: #MockSharedPreferencesForTest, returnNullOnMissingStub: true),
])
void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
        'deve retonar Numbertrivia do SharedPreference quando existir um salvo',
        () async {
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cached.json'));

      final result = await dataSource.getLastNumberTrivia();

      verify(mockSharedPreferences.getString(cachedNumberTriviaString));

      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'deve lançar um throw quando nao tiver nada dentro do SharedPreference',
        () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      final call = dataSource.getLastNumberTrivia;

      expect(() => call(), throwsA(const TypeMatcher<CacheExceptions>()));
    });
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: 'test trivia');

    test('should call SharedPreferences to cache the data', () async {
      //arrangev
      const tHasSetStringFuture = true;
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      when(mockSharedPreferences.setString(
              cachedNumberTriviaString, expectedJsonString))
          .thenAnswer((_) async => tHasSetStringFuture);
      //act
      final result = await dataSource.cacheNumberTrivia(tNumberTriviaModel);
      //assert

      // verify(mockSharedPreferences.setString(
      //     cachedNumberTriviaString, expectedJsonString));
      expect(result, equals(tHasSetStringFuture));
    });
  });
}
