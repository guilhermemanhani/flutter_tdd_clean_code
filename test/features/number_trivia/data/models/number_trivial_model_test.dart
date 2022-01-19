import 'dart:convert';

import 'package:flutter_tdd_clean_code/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test text');

  test(
    'É um subclass de NumberTrivial entity',
    () async {
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group(
    'fromJson',
    () {
      test(
        'deve retornar um model valido quando o JSON for integer',
        () async {
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('trivia.json'));

          final result = NumberTriviaModel.fromJson(jsonMap);

          expect(result, tNumberTriviaModel);
        },
      );

      test(
        'deve retornar um model valido quando o JSON for double',
        () async {
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('trivia_double.json'));

          final result = NumberTriviaModel.fromJson(jsonMap);

          expect(result, tNumberTriviaModel);
        },
      );
    },
  );

  group(
    'toJson',
    () {
      test(
        'deve retorna um JSON map de dados esperado',
        () async {
          final result = tNumberTriviaModel.toJson();

          final expectedMap = {
            "text": "Test text",
            "number": 1,
          };
          expect(result, expectedMap);
        },
      );
    },
  );
}
