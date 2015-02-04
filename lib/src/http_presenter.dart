part of squint;

/// Wrap the core [HttpClient] types for convenience.
abstract class HttpPresenter {
  static _nil() => {};

  static final _log = new Logger('HttpPresenter');

  final Function _whenComplete;

  const HttpPresenter([this._whenComplete = _nil]);

  void head(HttpHeaders headers) {
    headers.contentType = ContentType.JSON;
    headers.persistentConnection = false;
  }

  String decode(HttpClientResponse bytes) async {
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
