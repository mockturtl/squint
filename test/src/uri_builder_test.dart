library uri_builder.test;

import 'package:squint/squint.dart';
import 'package:unittest/unittest.dart';

void main() => run();

void run() {
  group('[UriBuilder]', () {
    var subj = new UriBuilderTest();
    test('it knows the collection resource url', subj.ofCollection);
    test('it knows an item resource url', subj.ofItem);
  });
}

class UriBuilderTest {
  void ofCollection() {
    var uri = new UriBuilder('ash', 'necronomicon');
    expect(uri.ofCollection.toString(),
        equals('https://api.github.com/repos/ash/necronomicon/labels'));
  }

  void ofItem() {
    var uri = new UriBuilder('muldoon', 'dinosaurs');
    expect(uri.ofItem('clever').toString(),
        equals('https://api.github.com/repos/muldoon/dinosaurs/labels/clever'));
  }
}
