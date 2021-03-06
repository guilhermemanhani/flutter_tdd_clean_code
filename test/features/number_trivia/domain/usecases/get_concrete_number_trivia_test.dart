import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumbertriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetConcreteNumberTrivia usecase;
  late MockNumbertriviaRepository mockNumbertriviaRepository;
  setUp(() {
    mockNumbertriviaRepository = MockNumbertriviaRepository();
    usecase = GetConcreteNumberTrivia(repository: mockNumbertriviaRepository);
  });

  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(number: tNumber, text: 'test');
  test(
    'test de numero do repositorio',
    () async {
      when(() => mockNumbertriviaRepository.getConcreteNumberTrivia(tNumber))
          .thenAnswer((_) async => const Right((tNumberTrivia)));
      final result = await usecase(const Params(number: tNumber));
      expect(result, equals(const Right(tNumberTrivia)));
      verify(() => mockNumbertriviaRepository.getConcreteNumberTrivia(tNumber));
      verifyNoMoreInteractions(mockNumbertriviaRepository);
    },
  );
}
