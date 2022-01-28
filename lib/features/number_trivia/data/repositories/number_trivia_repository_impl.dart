import 'package:dartz/dartz.dart';

import 'package:flutter_tdd_clean_code/core/error/failures.dart';
import 'package:flutter_tdd_clean_code/core/error/server_exceptions.dart';
import 'package:flutter_tdd_clean_code/core/platform/network_info.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
// import 'package:flutter_tdd_clean_code/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/domain/repositories/number_trivia_repository.dart';

// typedef Future<NumberTriviaModel> _ConcreteOrRandomChooser();

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
  Future<Either<Failures, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    
    await _networkInfo.isConnected;
    final remoteTrivia = await _remoteDataSource.getConcreteNumberTrivia(number);
    _localDataSource.cacheNumberTrivia(remoteTrivia);
    // return Right(await _remoteDataSource.getConcreteNumberTrivia(number));
    return Right(remoteTrivia);
    // return await _getTrivia(() {
    //   return _remoteDataSource.getConcreteNumberTrivia(number);
    // });
  }

  @override
  Future<Either<Failures, NumberTrivia>> getRandomNumberTrivia() {
    throw UnimplementedError();
  }

  // Future<Either<Failures, NumberTrivia>> _getTrivia(
  //     _ConcreteOrRandomChooser getConcreteOrRandom) async {
  //   if (await _networkInfo.isConnected) {
  //     try {
  //       final remoteTrivia = await getConcreteOrRandom();
  //       _localDataSource.cacheNumberTrivia(remoteTrivia);
  //       return Right(remoteTrivia);
  //     } on ServerExceptions {
  //       return Left(ServerFailures());
  //     }
  //   } else {
  //     try {
  //       final localTrivia = await _localDataSource.getLastNumberTrivia();
  //       return Right(localTrivia);
  //     } on CacheExceptions {
  //       return Left(CacheFailures());
  //     }
  //   }
  // }

  @override
  Future<Either<Failures, NumberTrivia>> getConcreteNumberTriviaNullParam(int? number) async {
    if(number != null) {
      return Right(await _remoteDataSource.getConcreteNumberTrivia(number));
    } else {
      return Left(ServerFailures());
    }
    
  }

  @override
  Future<Either<Failures, NumberTrivia?>> getConcreteNumberTriviaNullReturn(int number) async {
    return Right(await _remoteDataSource.getConcreteNumberTrivia(number)); 
  }
}
