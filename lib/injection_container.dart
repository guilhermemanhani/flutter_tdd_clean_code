import 'package:flutter_tdd_clean_code/core/util/input_converter.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void init() {
  //! Features
  sl.registerFactory(() => NumberTriviaBloc(
        getConcreteNumberTrivia: sl(),
        getRandomNumberTrivia: sl(),
        inputConverter: sl(),
      ));

  //! Use cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(repository: sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(repository: sl()));
  sl.registerLazySingleton(() => InputConverter());
  //! Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  //! Core

  //! External
}
