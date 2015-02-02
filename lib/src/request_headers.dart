part of squint;

class ApiRequest {
  static const _accept = 'application/vnd.github.v3+json';

  final String _userAgent; // https://developer.github.com/v3/#user-agent-required
  final String _token;

  const ApiRequest(this._userAgent, this._token);

  void prepare(HttpHeaders headers) {
    headers.contentType = ContentType.JSON;
    headers.persistentConnection = false;
    headers.add(HttpHeaders.ACCEPT, _accept);
    headers.add(HttpHeaders.AUTHORIZATION, _authorization);
    headers.set(HttpHeaders.USER_AGENT, _userAgent);
  }

  String get _authorization => 'token $_token';
}
