import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_code/core/error/failures.dart';
import 'package:flutter_tdd_clean_code/core/usecases/usecase.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements Usecase<NumberTrivia, NoParams> {
  final NumberTriviaRepository _repository;

  GetRandomNumberTrivia({
    required NumberTriviaRepository repository,
  }) : _repository = repository;
  @override
  Future<Either<Failures, NumberTrivia>> call(NoParams params) async {
    return await _repository.getRandomNumberTrivia();
  }
}
