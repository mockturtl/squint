library squint;

import 'dart:io';
import 'dart:convert';
import 'package:logging/logging.dart';

part 'src/label.dart';
part 'src/request_headers.dart';
part 'src/uri_builder.dart';

final log = new Logger('squint');
final _env = Platform.environment;
final _cli = new HttpClient();
final api = new ApiRequest('mockturtl/squint', _env['OAUTH_TOKEN']);
final uri = new UriBuilder(_env['owner'], _env['repo']);

/// Create a new issue label.
String create(String label, String rgb) async {
  return _cli.postUrl(uri.collection).then((HttpClientRequest req) {
    api.prepare(req.headers);
    req.add(UTF8.encode(new Label(label, rgb).toJson()));
    return req.close();
  }).then(_decode);
}

/// Change an issue label's color.
String set(String label, String rgb) async {
  return _cli.patchUrl(uri.from(label)).then((HttpClientRequest req) {
    api.prepare(req.headers);
    req.add(UTF8.encode(new Label(label, rgb).toJson()));
    return req.close();
  }).then(_decode);
}

/// Delete an issue label.  Note this method returns the empty string.
String delete(String label) async {
  return _cli.deleteUrl(uri.from(label)).then((HttpClientRequest req) {
    api.prepare(req.headers);
    return req.close();
  }).then(_decode);
}

/// Fetch a single issue label.
String get(String label) async {
  return _cli.getUrl(uri.from(label)).then((HttpClientRequest req) {
    api.prepare(req.headers);
    return req.close();
  }).then(_decode);
}

/// Fetch the set of all issue labels for the repository.
String getAll() async {
  return _cli.getUrl(uri.collection).then((HttpClientRequest req) {
    api.prepare(req.headers);
    return req.close();
  }).then(_decode);
}

String _decode(HttpClientResponse bytes) async {
  _logHead(bytes);
  return UTF8
      .decodeStream(bytes)
      .then(_logRes)
      .catchError(_logErr)
      .whenComplete(_close)
      .then((String body) => body);
}

void _logErr(e) => log.severe(e);

void _logHead(HttpClientResponse res) {
  log.info('-> ${res.statusCode} ${res.reasonPhrase}');
  log.finest(
      '-> persistent? ${res.persistentConnection}, content-length: ${res.contentLength}, headers: ${res.headers}');
}

String _logRes(String res) {
  if (res.isNotEmpty) log.finer('-> $res');
  return res;
}

void _close() {
  _cli.close();
  log.finest('_close: HttpClient connection closed');
}
