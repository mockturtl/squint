library squint;

import 'dart:io';
import 'dart:convert';

part 'src/label.dart';

final env = Platform.environment;
final owner = env['owner'];
final repo = env['repo'];

final _cli = new HttpClient();

final url = 'https://api.github.com/repos/$owner/$repo/labels';
const accept = 'application/vnd.github.v3+json';
final authorization = 'token ${env['OAUTH_TOKEN']}';

void delete(String label) {
  _cli.deleteUrl(Uri.parse('$url/$label')).then((HttpClientRequest req) {
    _addHeaders(req);
    return req.close();
  }).then(_logHandler);
}

void create(String label, String rgb) {
  _cli.postUrl(Uri.parse(url)).then((HttpClientRequest req) {
    _addHeaders(req);
    req.add(UTF8.encode(new Label(label, rgb).toJson()));
    return req.close();
  }).then(_logHandler);
}

void set(String label, String rgb) {
  _cli.patchUrl(Uri.parse('$url/$label')).then((HttpClientRequest req) {
    _addHeaders(req);
    req.add(UTF8.encode(new Label(label, rgb).toJson()));
    return req.close();
  }).then(_logHandler);
}

void get(String label) {
  _cli.getUrl(Uri.parse('$url/$label')).then((HttpClientRequest req) {
    _addHeaders(req);
    return req.close();
  }).then(_logHandler);
}

void getAll() {
  _cli.getUrl(Uri.parse(url)).then((HttpClientRequest req) {
    _addHeaders(req);
    return req.close();
  }).then(_logHandler);
}

void _logHandler(HttpClientResponse bytes) {
  _logResHead(bytes);
  UTF8.decodeStream(bytes).then((String res) {
    _logRes(res);
  }).catchError(_logErr)..whenComplete(_close);
}

void _logErr(e) => print(e);
void _logResHead(HttpClientResponse res) =>
    print(res.statusCode); //print(bytes.headers);
void _logRes(String res) {
  if (res.isNotEmpty) print(res);
}
void _close() => _cli.close();

void _addHeaders(HttpClientRequest req) {
  req.headers.contentType = ContentType.JSON;
  req.headers.add(HttpHeaders.ACCEPT, accept);
  req.headers.add(HttpHeaders.AUTHORIZATION, authorization);
}
