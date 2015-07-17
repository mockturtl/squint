import 'package:squint/squint.dart';
import 'package:test/test.dart';

main() {
  group('[Client]', () {
    setUp(() {
      cli = new Client.from('billyjean', 'kids');
    });

    var subj = new ClientTest();
    test('it returns a URL for web browsers', subj.browserUrl);
  });
}

Client cli;

class ClientTest {
  browserUrl() {
    expect(cli.browserUrl, equals('https://github.com/billyjean/kids/labels'));
  }
}
