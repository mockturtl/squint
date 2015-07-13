part of squint;

/// Wraps the core [HttpClient] types.
abstract class HttpPresenter {
  // FIXME: https://code.google.com/p/dart/issues/detail?id=4596
  static _nil() => {};

  static final _log = new Logger('HttpPresenter');

  final Function _whenComplete;

  const HttpPresenter([this._whenComplete = _nil]);

  /// Supply custom headers with an [HttpClientRequest].
  void head(HttpHeaders headers) {
    headers.contentType = ContentType.JSON;
    headers.persistentConnection = false;
  }

  /// Transform the response byte stream to a [String].
  Future<String> decode(HttpClientResponse bytes) async {
    _logHead(bytes);
    return UTF8
        .decodeStream(bytes)
        .then(_logRes)
        .catchError(_logErr)
        .whenComplete(_whenComplete)
        .then((String body) => body);
  }

  void _logErr(e) => _log.severe(e);

  void _logHead(HttpClientResponse res) {
    _log.finer('-> ${res.statusCode} ${res.reasonPhrase}');
    _log.finest(
        '-> persistent? ${res.persistentConnection}, content-length: ${res.contentLength}, headers:\n${res.headers}');
  }

  String _logRes(String res) {
    if (res.isNotEmpty) _log.finer('-> $res');
    return res;
  }
}
