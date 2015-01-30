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
  //_set(label, '134134');
  //_create('qux', 'd0d0d0');
  _delete('qux');
}

void _delete(String label) {
  cli.deleteUrl(Uri.parse('$url/$label')).then((HttpClientRequest req) {
    _headers(req);
    return req.close();
  }).then((HttpClientResponse bytes) {
    print(bytes.headers);
    //UTF8.decodeStream(bytes).then((String res) {
    var sub = bytes.transform(UTF8.decoder).listen((String res) {
      print(res);
    }, onDone: () => cli.close(),
       onError: (e) => print(e),
       cancelOnError: true);
  });
}

void _create(String label, String rgb) {
  cli.postUrl(Uri.parse(url)).then((HttpClientRequest req) {
    _headers(req);
    req.add(UTF8.encode('{"name":"$label", "color":"$rgb"}'));
    return req.close();
  }).then((HttpClientResponse bytes) {
    print(bytes.headers);
    //UTF8.decodeStream(bytes).then((String res) {
    var sub = bytes.transform(UTF8.decoder).listen((String res) {
      print(res);
    }, onDone: () => cli.close(),
       onError: (e) => print(e),
       cancelOnError: true);
  });
}


void _set(String label, String rgb) {
  cli.patchUrl(Uri.parse('$url/$label')).then((HttpClientRequest req) {
    _headers(req);
    req.add(UTF8.encode('{"name":"$label", "color":"$rgb"}'));
    return req.close();
  }).then((HttpClientResponse bytes) {
    print(bytes.headers);
    //UTF8.decodeStream(bytes).then((String res) {
    var sub = bytes.transform(UTF8.decoder).listen((String res) {
      print(res);
    }, onDone: () => cli.close(),
       onError: (e) => print(e),
       cancelOnError: true);
  });
}

void _get(String label) {
  cli.getUrl(Uri.parse('$url/$label')).then((HttpClientRequest req) {
    _headers(req);
    return req.close();
  }).then((HttpClientResponse bytes) {
    print(bytes.headers);
    //UTF8.decodeStream(bytes).then((String res) {
    var sub = bytes.transform(UTF8.decoder).listen((String res) {
      print(res);
    }, onDone: () => cli.close(),
       onError: (e) => print(e),
       cancelOnError: true);
  });
}


void _getAll() {
  cli.getUrl(Uri.parse(url)).then((HttpClientRequest req) {
    _headers(req);
    return req.close();
  }).then((HttpClientResponse bytes) {
    print(bytes.headers);
    //UTF8.decodeStream(bytes).then((String res) {
    var sub = bytes.transform(UTF8.decoder).listen((String res) {
      print(res);
    }, onDone: () => cli.close(),
       onError: (e) => print(e),
       cancelOnError: true);
  });
}

void _headers(HttpClientRequest req) {
  req.headers.contentType = ContentType.JSON;
  req.headers.add(HttpHeaders.ACCEPT, accept);
  req.headers.add(HttpHeaders.AUTHORIZATION, authorization);
}
