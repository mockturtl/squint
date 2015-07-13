import 'package:squint/squint.dart';
import 'package:test/test.dart';

main() {
  group('[UriBuilder]', () {
    setUp(() {
      uri = new UriBuilder('muldoon', 'dinosaurs');
    });

    var subj = new UriBuilderTest();
    test('it knows the collection resource url', subj.ofCollection);
    test('it knows an item resource url', subj.ofItem);
    test('it provides a browser url', subj.forBrowser);
  });
}

UriBuilder uri;

class UriBuilderTest {
  void ofCollection() {
    expect(uri.ofCollection.toString(),
        equals('https://api.github.com/repos/muldoon/dinosaurs/labels'));
  }

  void ofItem() {
    expect(uri.ofItem('clever').toString(),
        equals('https://api.github.com/repos/muldoon/dinosaurs/labels/clever'));
  }

  void forBrowser() {
    expect(
        uri.forBrowser, equals('https://github.com/muldoon/dinosaurs/labels'));
  }
}
