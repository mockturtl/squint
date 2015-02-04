library client.test;

import 'package:squint/squint.dart';
import 'package:unittest/unittest.dart';

void main() => run();

void run() {
  group('[Client]', () {
    var subj = new ClientTest();
    test('it returns a URL for web browsers', subj.browserUrl);
  });
}

class ClientTest {
  void browserUrl() {
    var cli = new Client.from('billyjean', 'kids');
    expect(cli.browserUrl, equals('https://github.com/billyjean/kids/labels'));
  }
}
