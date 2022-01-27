
import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_code/core/platform/network_info.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource {}
class MockNumberTriviaLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}
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
      remoteDataSource : mockRemoteDataSource,
      localDataSource : mockLocalDataSource,
      networkInfo : mockNetworkInfo
    );
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(text: 'test trivia', number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    //This fails!!
    test('should check if the device is online mocktail', () async {
      //arrange
      // when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      // repository.getConcreteNumberTrivia(tNumber);

      // ? arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
          .thenAnswer((_) async => NumberTriviaModel(text: 'test', number: tNumber));
      
      // ? act
      repository.getConcreteNumberTrivia(tNumber);
      // ? assert
      verify(() => mockNetworkInfo.isConnected);
    });
    
    //This works correctly
    // group('device is online', () {
    //   setUp(() {
    //     when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    //   });

    //   test('should return remote data when the call to remote data source is successful', () async {
    //     //arrange
    //     when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber)).thenAnswer((_) async => tNumberTriviaModel);
    //     //act
    //     final result = await repository.getConcreteNumberTrivia(tNumber);
    //     //asert
    //     verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
    //     expect(result, Right(tNumberTrivia));
    //   });
    // });
  });
  }