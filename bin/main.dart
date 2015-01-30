import 'dart:io';
import 'dart:convert';
import 'package:squint/squint.dart' as squint;

final env = Platform.environment;
final cli = new HttpClient();
final owner = env['owner'];
final repo = env['repo'];
final label = env['label'];

final url = 'https://api.github.com/repos/$owner/$repo/labels';
const accept = 'application/vnd.github.v3+json';
final authorization = 'token ${env['OAUTH_TOKEN']}';

void main() {
  //_getAll();
  //_get(label);
  _set(label, '134134');
  //_create('qux', 'd0d0d0');
  //_delete('qux');
}

void _delete(String label) {
  cli.deleteUrl(Uri.parse('$url/$label')).then((HttpClientRequest req) {
    _headers(req);
    return req.close();
  }).then(_logHandler);
}

void _create(String label, String rgb) {
  cli.postUrl(Uri.parse(url)).then((HttpClientRequest req) {
    _headers(req);
    req.add(UTF8.encode(_json(label, rgb)));
    return req.close();
  }).then(_logHandler);
}

void _set(String label, String rgb) {
  cli.patchUrl(Uri.parse('$url/$label')).then((HttpClientRequest req) {
    _headers(req);
    req.add(UTF8.encode(_json(label, rgb)));
    return req.close();
  }).then(_logHandler);
}

void _get(String label) {
  cli.getUrl(Uri.parse('$url/$label')).then((HttpClientRequest req) {
    _headers(req);
    return req.close();
  }).then(_logHandler);
}

void _getAll() {
  cli.getUrl(Uri.parse(url)).then((HttpClientRequest req) {
    _headers(req);
    return req.close();
  }).then(_logHandler);
}

_logHandler(HttpClientResponse bytes) {
  _logResHead(bytes);
  UTF8.decodeStream(bytes).then((String res) {
    _logRes(res);
  }).catchError(_logErr)..whenComplete(_close);
}

void _logErr(e) => print(e);
void _logResHead(HttpClientResponse res) => print(res.statusCode);//print(bytes.headers);
void _logRes(String res) {
  if (res.isNotEmpty) print(res);
}
void _close() => cli.close();

Map<String, String> _label(String name, String rgb) => {'name': name, 'color': rgb};
String _json(String name, String rgb) => JSON.encode(_label(name, rgb));

void _headers(HttpClientRequest req) {
  req.headers.contentType = ContentType.JSON;
  req.headers.add(HttpHeaders.ACCEPT, accept);
  req.headers.add(HttpHeaders.AUTHORIZATION, authorization);
}
