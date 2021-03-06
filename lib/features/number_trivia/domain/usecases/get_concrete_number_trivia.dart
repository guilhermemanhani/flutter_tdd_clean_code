import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tdd_clean_code/core/error/failures.dart';
import 'package:flutter_tdd_clean_code/core/usecases/usecase.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements Usecase<NumberTrivia, Params> {
  // final NumberTriviaRepository repository;
  // GetConcreteNumberTrivia(this.repository);
  final NumberTriviaRepository _repository;
  GetConcreteNumberTrivia({
    required NumberTriviaRepository repository,
  }) : _repository = repository;

  @override
  Future<Either<Failures, NumberTrivia>> call(Params params) async {
    return await _repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});

  @override
  List<Object?> get props => [number];
}
