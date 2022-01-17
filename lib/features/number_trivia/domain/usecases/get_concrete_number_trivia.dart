import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_code/core/error/failures.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia {
  // final NumberTriviaRepository repository;
  // GetConcreteNumberTrivia(this.repository);
  final NumberTriviaRepository _repository;
  GetConcreteNumberTrivia({
    required NumberTriviaRepository repository,
  }) : _repository = repository;

  Future<Either<Failures, NumberTrivia>> execute(int number) async =>
      await _repository.getConcreteNumberTrivia(number);
}
