part of api_request.test;

class HttpClientRequestMock extends Mock implements HttpClientRequest {
  final List<int> _bytes = [];

  add(List<int> v) => _bytes.addAll(v);

  List<int> get bytes => _bytes;
}
