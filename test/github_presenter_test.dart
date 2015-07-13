import 'dart:io';
import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:squint/squint.dart';
import 'package:test/test.dart';

import 'src/mocks.dart';

main() {
  group('[GithubPresenter]', () {
    var subj = new GithubPresenterTest();
    test('it adds the right request headers', subj.head);
    test('it adds the request body', subj.body);
  });
}

class GithubPresenterTest {
  void head() {
    var h = new GithubPresenter('anything', 'SECRET');
    var mock = new HttpHeadersMock();
    h.head(mock);
    expect(mock.contentType, equals(ContentType.JSON));
    expect(mock.persistentConnection, isFalse);
    expect(mock.accept, equals('application/vnd.github.v3+json'));
    expect(mock.authorization, equals('token SECRET'));
    expect(mock.userAgent, equals('anything'));
  }

  void body() {
    var h = new GithubPresenter('', '');
    var stub = new HttpClientRequestMock();
    var l = new Label('foo', 'aa0000');
    var bytes = UTF8.encode(l.toJson());
    h.body(stub, l);
    // FIXME https://github.com/fibulwinter/dart-mockito/issues/15#issuecomment-117515552
    verify(stub.add(argThat(equals(bytes)))).called(1);
  }
}
