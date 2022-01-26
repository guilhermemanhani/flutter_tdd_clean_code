import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_code/core/error/failures.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failures, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failures, NumberTrivia>> getRandomNumberTrivia();

  //  ! fazer mais casos de teste com retornos e parametros diferentes
  Future<Either<Failures, NumberTrivia>> getRandomNumbeTrivia(int?  number);
  Future<Either<Failures, NumberTrivia?>> getRandomNumbTrivia(int number);
  
}
