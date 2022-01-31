import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_code/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('StringToUnsignedInt', () {
    test('deve retornar um interger quando uma string representar um inteiro',
        () async {
      const str = '123';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, const Right(123));
    });

    test('deve retornar um erro quando uma string nao representar um inteiro',
        () async {
      const str = 'abc';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });

    test('deve retornar um erro quando uma string é um inteiro negativo',
        () async {
      const str = '-123';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
