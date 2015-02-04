library api_request.test;

import 'package:squint/squint.dart';
import 'package:mock/mock.dart';
import 'package:unittest/unittest.dart';
import 'dart:io';
import 'dart:convert';

part 'mock/http_headers_mock.dart';
part 'mock/http_client_request_mock.dart';

void main() => run();

void run() {
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
    expect(mock.persistentConnection, equals(false));
    expect(mock.accept, equals('application/vnd.github.v3+json'));
    expect(mock.authorization, equals('token SECRET'));
    expect(mock.userAgent, equals('anything'));
  }

  void body() {
    var h = new GithubPresenter('', '');
    var mock = new HttpClientRequestMock();
    h.body(mock, new Label('foo', 'aa0000'));
    expect(UTF8.decode(mock.bytes), equals('{"name":"foo","color":"aa0000"}'));
  }
}
