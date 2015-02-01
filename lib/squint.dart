library squint;

import 'dart:io';
import 'dart:convert';
import 'package:logging/logging.dart';

part 'src/label.dart';

final log = new Logger('squint');

final env = Platform.environment;
final owner = env['owner'];
final repo = env['repo'];

final _cli = new HttpClient();

final url = 'https://api.github.com/repos/$owner/$repo/labels';
const accept = 'application/vnd.github.v3+json';
final authorization = 'token ${env['OAUTH_TOKEN']}';
final user_agent =
    'mockturtl/squint'; // https://developer.github.com/v3/#user-agent-required

/// Create a new issue label.
String create(String label, String rgb) async {
  return _cli.postUrl(_uriFor(url)).then((HttpClientRequest req) {
    _addHeaders(req);
    req.add(UTF8.encode(new Label(label, rgb).toJson()));
    return req.close();
  }).then(_decode);
}

/// Change an issue label's color.
String set(String label, String rgb) async {
  return _cli.patchUrl(_uriFor('$url/$label')).then((HttpClientRequest req) {
    _addHeaders(req);
    req.add(UTF8.encode(new Label(label, rgb).toJson()));
    return req.close();
  }).then(_decode);
}

/// Delete an issue label.  Note this method returns the empty string.
String delete(String label) async {
  return _cli.deleteUrl(_uriFor('$url/$label')).then((HttpClientRequest req) {
    _addHeaders(req);
    return req.close();
  }).then(_decode);
}

/// Fetch a single issue label.
String get(String label) async {
  return _cli.getUrl(_uriFor('$url/$label')).then((HttpClientRequest req) {
    _addHeaders(req);
    return req.close();
  }).then(_decode);
}

/// Fetch the set of all issue labels for the repository.
String getAll() async {
  return _cli.getUrl(_uriFor(url)).then((HttpClientRequest req) {
    _addHeaders(req);
    return req.close();
  }).then(_decode);
}

Uri _uriFor(String path) => Uri.parse(path);

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

void _addHeaders(HttpClientRequest req) {
  req.headers.contentType = ContentType.JSON;
  req.headers.add(HttpHeaders.ACCEPT, accept);
  req.headers.add(HttpHeaders.AUTHORIZATION, authorization);
  req.headers.set(HttpHeaders.USER_AGENT, user_agent);
  log.finest('<- ${req.headers}');
}
