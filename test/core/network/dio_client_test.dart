import 'package:flutter_test/flutter_test.dart';
import 'package:photo_revive_ai/core/network/api_interceptor.dart';

void main() {
  test('ApiInterceptor can be instantiated', () {
    final interceptor = ApiInterceptor();
    expect(interceptor, isNotNull);
  });
}
