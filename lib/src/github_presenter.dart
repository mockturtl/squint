part of squint;

/// Wrap the core [HttpClient] types for GitHub's api.
class GithubPresenter extends HttpPresenter {
  static const _accept = 'application/vnd.github.v3+json';

  final String _userAgent; // https://developer.github.com/v3/#user-agent-required
  final String _token;

  const GithubPresenter(this._userAgent, this._token);

  /// Supply custom headers with an [HttpClientRequest].
  void head(HttpHeaders headers) {
    super.head(headers);
    headers.add(HttpHeaders.ACCEPT, _accept);
    headers.add(HttpHeaders.AUTHORIZATION, _authorization);
    headers.set(HttpHeaders.USER_AGENT, _userAgent);
  }

  /// Supply [label] as the body of [req].
  void body(HttpClientRequest req, Label label) {
    req.add(UTF8.encode(label.toJson()));
  }

  /// Send [req] after assigning the correct headers and body.
  HttpClientResponse sendWith(HttpClientRequest req, Label label) async {
    head(req.headers);
    body(req, label);
    return req.close();
  }

  /// Send [req] after assigning the correct headers.
  HttpClientResponse send(HttpClientRequest req) async {
    head(req.headers);
    return req.close();
  }

  String get _authorization => 'token $_token';
}
