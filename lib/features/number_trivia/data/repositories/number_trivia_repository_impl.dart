import 'package:dartz/dartz.dart';

import 'package:flutter_tdd_clean_code/core/error/failures.dart';
import 'package:flutter_tdd_clean_code/core/platform/network_info.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource _remoteDataSource;
  final NumberTriviaLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  NumberTriviaRepositoryImpl({
    required remoteDataSource,
    required localDataSource,
    required networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failures, NumberTrivia>> getConcreteNumberTrivia(int number) {
    _networkInfo.isConnected;
    throw UnimplementedError();
  }

  @override
  Future<Either<Failures, NumberTrivia>> getRandomNumberTrivia() {
    throw UnimplementedError();
  }
}
