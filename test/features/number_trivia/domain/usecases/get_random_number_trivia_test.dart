import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_code/core/usecases/usecase.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumbertriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetRandomNumberTrivia usecase;
  late MockNumbertriviaRepository mockNumbertriviaRepository;
  setUp(() {
    mockNumbertriviaRepository = MockNumbertriviaRepository();
    usecase = GetRandomNumberTrivia(repository: mockNumbertriviaRepository);
  });

  // final tNumber = 1;
  const tNumberTrivia = NumberTrivia(number: 1, text: 'test');
  test(
    'test de numero aleatorio do repositorio',
    () async {
      when(() => mockNumbertriviaRepository.getRandomNumberTrivia())
          .thenAnswer((_) async => const Right((tNumberTrivia)));
      final result = await usecase(NoParams());
      expect(result, equals(const Right(tNumberTrivia)));
      verify(() => mockNumbertriviaRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockNumbertriviaRepository);
    },
  );
}
