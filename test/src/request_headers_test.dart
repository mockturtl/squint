library request_headers.test;

import 'package:squint/squint.dart';
import 'package:mock/mock.dart';
import 'package:unittest/unittest.dart';
import 'dart:io';

part 'mock/http_headers_mock.dart';

void main() => run();

void run() {
  group('[RequestHeaders]', () {
    var subj = new RequestHeadersTest();
    test('it adds the right request headers', subj.add);
  });
}

class RequestHeadersTest {
  void add() {
    var h = new ApiRequest('anything', 'SECRET');
    var mock = new HttpHeadersMock();
    h.prepare(mock);
    expect(mock.contentType, equals(ContentType.JSON));
    expect(mock.persistentConnection, equals(false));
    expect(mock.accept, equals('application/vnd.github.v3+json'));
    expect(mock.authorization, equals('token SECRET'));
    expect(mock.userAgent, equals('anything'));
  }
}
