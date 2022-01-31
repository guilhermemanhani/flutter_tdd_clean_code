import 'dart:convert';

import 'package:flutter_tdd_clean_code/core/error/server_exceptions.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpSucesso200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpFail404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Somethin went wrong', 404));
  }

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModels =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('deve chamar a url com o cabeçalho adequado', () async {
      setUpMockHttpSucesso200();

      dataSource.getRandomNumberTrivia();

      verify(mockHttpClient
          .get(Uri.parse('http://numbersapi.com/random'), headers: {
        'Content-Type': 'application/json',
      }));
    });

    test('deve retornar um numbertrivia quando a resposta for 200', () async {
      setUpMockHttpSucesso200();

      final result = await dataSource.getRandomNumberTrivia();

      expect(result, equals(tNumberTriviaModels));
    });

    test('deve lançar throw quando o server voltar 404 ou outro', () async {
      setUpMockHttpFail404();

      final call = dataSource.getRandomNumberTrivia;

      expect(() => call(), throwsA(const TypeMatcher<ServerExceptions>()));
    });
  });

  group('getCroncreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModels =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('deve chamar a url com o cabeçalho adequado', () async {
      setUpMockHttpSucesso200();

      dataSource.getConcreteNumberTrivia(tNumber);

      verify(mockHttpClient
          .get(Uri.parse('http://numbersapi.com/$tNumber'), headers: {
        'Content-Type': 'application/json',
      }));
    });

    test('deve retornar um numbertrivia quando a resposta for 200', () async {
      setUpMockHttpSucesso200();

      final result = await dataSource.getConcreteNumberTrivia(tNumber);

      expect(result, equals(tNumberTriviaModels));
    });

    test('deve lançar throw quando o server voltar 404 ou outro', () async {
      setUpMockHttpFail404();

      final call = dataSource.getConcreteNumberTrivia;

      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerExceptions>()));
    });
  });
}
