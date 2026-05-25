import 'package:flutter_test/flutter_test.dart';
import 'package:profile_app/utils/validators.dart';

void main() {
  test('email validator accepts valid email', () {
    expect(Validators.email('test@example.com'), isNull);
  });

  test('email validator rejects invalid email', () {
    expect(Validators.email('not-an-email'), isNotNull);
  });

  test('password validator requires 6 characters', () {
    expect(Validators.password('12345'), isNotNull);
    expect(Validators.password('123456'), isNull);
  });
}
