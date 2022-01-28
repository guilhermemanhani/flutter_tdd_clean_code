import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_code/core/error/failures.dart';
import 'package:flutter_tdd_clean_code/core/platform/network_info.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'number_trivia_repository_impl_mockito_test.mocks.dart';

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

// class MockNetworkInfo extends Mock implements NetworkInfo {}

@GenerateMocks([NetworkInfo])
// @GenerateMocks([NumberTriviaRemoteDataSource])
@GenerateMocks([
  NumberTriviaRemoteDataSource
], customMocks: [
  MockSpec<NumberTriviaRemoteDataSource>(
      as: #MockNumberTriviaRemoteDataSourceForTest,
      returnNullOnMissingStub: true),
])
void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tNumber = 1;
  const tNumberTriviaModel =
      NumberTriviaModel(text: 'test trivia', number: tNumber);
  const NumberTrivia tNumberTrivia = tNumberTriviaModel;

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  group(
    'getConcreteNumberTrivia',
    () {
      test('deve validar se o celular esta online mockito', () async {
        //arrange
        // when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        //act
        // repository.getConcreteNumberTrivia(tNumber);
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // ! Não deixa o valor any() pois pode ser null
        when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockNetworkInfo.isConnected);
      });

      runTestsOnline(
        () {
          test(
              'deve retornar dados remotos quando a chamada para da api for bem-sucedida mockito',
              () async {
            //arrange
            when(mockRemoteDataSource.getConcreteNumberTrivia(any))
                .thenAnswer((_) async => tNumberTriviaModel);
            //act
            final result = await repository.getConcreteNumberTrivia(tNumber);
            //assert
            verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
            expect(result, equals(const Right(tNumberTrivia)));
          });

          test(
            'deve armazenar em cache os dados localmente quando a chamada para api for bem-sucedida mockito',
            () async {
              // arrange
              when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
                  .thenAnswer((_) async => tNumberTriviaModel);
              // act
              await repository.getConcreteNumberTrivia(tNumber);
              // assert
              verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
              verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
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
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          //act
          final result =
              await repository.getConcreteNumberTriviaNullParam(tNumber);
          //assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(const Right(tNumberTrivia)));
        },
      );

      test(
        'deve retornar erro ao buscar dados remotos quando a chamada passa null',
        () async {
          //arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
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
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          //act
          final result =
              await repository.getConcreteNumberTriviaNullReturn(tNumber);
          //assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(const Right(tNumberTrivia)));
        },
      );
    },
  );
}
