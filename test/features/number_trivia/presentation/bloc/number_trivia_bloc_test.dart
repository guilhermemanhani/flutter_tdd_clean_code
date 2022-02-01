import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_code/core/error/failures.dart';
import 'package:flutter_tdd_clean_code/core/usecases/usecase.dart';
import 'package:flutter_tdd_clean_code/core/util/input_converter.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetConcreteNumberTrivia])
@GenerateMocks([GetRandomNumberTrivia])
@GenerateMocks([InputConverter])
void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('estado inicial deve ser vazio', () {
    expect(bloc.initialState, equals(Empty()));
  });

  group('getTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(const Right(tNumberParsed));
    test('''deve chamar o InputConverter 
    para validar e converter a string 
    em um inteiro sem sinal''', () async* {
      //arrange
      setUpMockInputConverterSuccess();
      //act
      bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      //assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('deve dar erro quando a entrada nao for valida', () async* {
      //arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));

      final expected = [
        Empty(),
        const Error(message: invalidInputFailureMessage),
      ];
      //assert later
      expectLater(bloc, emitsInOrder(expected));

      //act
      bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
    });

    test('deve obter dados do caso de uso concreto', () async* {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      //act
      bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      //assert
      verify(mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
    });

    test('dever emitir [loading, loaded] e os dados se for sucesso', () async* {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      final expected = [
        Empty(),
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      //act

      bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
    });

    test('dever emitir [loading, erro] e os dados devem retornar falha',
        () async* {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailures()));
      final expected = [
        Empty(),
        Loading(),
        const Error(message: serverFailureMessage),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      //act

      bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
    });

    test(
        'dever emitir [loading, erro] e os dados devem retornar falha de cache',
        () async* {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailures()));
      final expected = [
        Empty(),
        Loading(),
        const Error(message: cacheFailureMessage),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      //act

      bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
    });
  });

  group('getTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test('deve obter dados do caso de uso concreto', () async* {
      //arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      //act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetConcreteNumberTrivia(any));
      //assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('dever emitir [loading, loaded] e os dados se for sucesso', () async* {
      //arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      final expected = [
        Empty(),
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      //act

      bloc.add(GetTriviaForRandomNumber());
    });

    test('dever emitir [loading, erro] e os dados devem retornar falha',
        () async* {
      //arrange
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailures()));
      final expected = [
        Empty(),
        Loading(),
        const Error(message: serverFailureMessage),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      //act

      bloc.add(GetTriviaForRandomNumber());
    });

    test(
        'dever emitir [loading, erro] e os dados devem retornar falha de cache',
        () async* {
      //arrange
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailures()));
      final expected = [
        Empty(),
        Loading(),
        const Error(message: cacheFailureMessage),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      //act

      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
