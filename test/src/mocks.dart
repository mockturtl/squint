import 'dart:io';

import 'package:mockito/mockito.dart';

class HttpClientRequestMock extends Mock implements HttpClientRequest {}

class HttpHeadersMock extends Mock implements HttpHeaders {
  final _map = {};

  bool persistentConnection = true;
  ContentType contentType = ContentType.TEXT;

  // wrong semantics for multi-valued headers
  add(String k, String v) => set(k, v);

  set(String k, String v) => _map[k] = v;

  String get accept => _map[HttpHeaders.ACCEPT];
  String get authorization => _map[HttpHeaders.AUTHORIZATION];
  String get userAgent => _map[HttpHeaders.USER_AGENT];
}

HttpClientRequest buildStubRequest() {
  var out = new HttpClientRequestMock();
  when(out.add(any));
  return out;
}

HttpHeaders buildStubHeaders() => new HttpHeadersMock();
