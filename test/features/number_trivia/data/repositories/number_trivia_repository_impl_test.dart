import 'package:flutter_tdd_clean_code/core/platform/network_info.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetWorkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetWorkInfo mockNetWorkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetWorkInfo = MockNetWorkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetWorkInfo,
    );
  });

  group(
    'getConcreteNumberTrivia',
    () {
      const tNumber = 1;
      const tNumberTriviaModel =
          NumberTriviaModel(text: "teste trivia", number: tNumber);
      const NumberTrivia tNumberTrivia = tNumberTriviaModel;
      test(
        'Should check internet online',
        () async {
          when(mockNetWorkInfo.isConnected).thenAnswer((_) async => true);

          repository.getConcreteNumberTrivia(tNumber);

          verify(mockNetWorkInfo.isConnected);
        },
      );
    },
  );
}
