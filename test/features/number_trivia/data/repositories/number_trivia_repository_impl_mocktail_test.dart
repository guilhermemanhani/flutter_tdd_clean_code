import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_code/core/error/failures.dart';
import 'package:flutter_tdd_clean_code/core/platform/network_info.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockNumberTriviaLocalDataSource extends Mock
    implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  late MockNumberTriviaLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  const tNumber = 1;
  const tNumberTriviaModel =
      NumberTriviaModel(text: 'test trivia', number: tNumber);
  const NumberTrivia tNumberTrivia = tNumberTriviaModel;
  void runTestsOnline(Function body) {
    group(
      'device is online',
      () {
        setUp(() {
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        });
        body();
      },
    );
  }

  group(
    'getConcreteNumberTrivia',
    () {
      //This fails!!
      test('should check if the device is online mocktail', () async {
        //arrange
        // when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        // repository.getConcreteNumberTrivia(tNumber);

        // ? arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => tNumberTriviaModel);

        // ? act
        repository.getConcreteNumberTrivia(tNumber);
        // ? assert
        verify(() => mockNetworkInfo.isConnected);
      });

      // This works correctly
      runTestsOnline(
        () {
          test(
              'deve retornar dados remotos quando a chamada para da api for bem-sucedida mocktail',
              () async {
            //arrange
            when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
                .thenAnswer((_) async => tNumberTriviaModel);
            //act
            final result = await repository.getConcreteNumberTrivia(tNumber);
            //asert
            verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
            expect(result, const Right(tNumberTrivia));
          });
          test(
            'deve armazenar em cache os dados localmente quando a chamada para api for bem-sucedida mocktail',
            () async {
              // arrange
              when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
                  .thenAnswer((_) async => tNumberTriviaModel);
              // act
              await repository.getConcreteNumberTrivia(tNumber);
              // assert
              verify(
                  () => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
              verify(() =>
                  mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
            },
          );
        },
      );
    },
  );
  group(
    'getConcreteNumberTriviaNullParam',
    () {
      test(
        'deve retornar dados remotos quando a chamada para da api for bem-sucedida parametro not-null',
        () async {
          //arrange
          when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
              .thenAnswer((_) async => tNumberTriviaModel);
          //act
          final result =
              await repository.getConcreteNumberTriviaNullParam(tNumber);
          //assert
          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(const Right(tNumberTrivia)));
        },
      );

      test(
        'deve retornar erro ao buscar dados remotos quando a chamada passa null',
        () async {
          //arrange
          when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
              .thenAnswer((_) async => tNumberTriviaModel);
          //act
          final result =
              await repository.getConcreteNumberTriviaNullParam(null);
          //assert
          // verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(Left(ServerFailures())));
        },
      );
    },
  );

  group(
    'getConcreteNumberTriviaNullReturn',
    () {
      test(
        'deve retornar dados remotos quando a chamada para da api for bem-sucedida',
        () async {
          //arrange
          when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
              .thenAnswer((_) async => tNumberTriviaModel);
          //act
          final result =
              await repository.getConcreteNumberTriviaNullReturn(tNumber);
          //assert
          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(const Right(tNumberTrivia)));
        },
      );
    },
  );
}
