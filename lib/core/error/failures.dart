import 'package:equatable/equatable.dart';

abstract class Failures extends Equatable {
  const Failures([List properties = const <dynamic>[]]) : super();

  List<Object> get props => [];
}

class ServerFailures extends Failures {}

class CacheFailures extends Failures {}
