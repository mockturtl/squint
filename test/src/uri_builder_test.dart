library uri_builder.test;

import 'package:squint/squint.dart';
import 'package:unittest/unittest.dart';

void main() => run();

void run() {
  group('[UriBuilder]', () {
    var subj = new UriBuilderTest();
    test('it knows the base collection resource url', subj.collection);
    test('it knows an item resource url', subj.from);
  });
}

class UriBuilderTest {
  void collection() {
    var b = new UriBuilder('bozo', 'necronomicon');
    expect(b.collection.toString(),
        equals('https://api.github.com/repos/bozo/necronomicon/labels'));
  }

  void from() {
    var b = new UriBuilder('pratt', 'dinosaurs');
    expect(b.from('delicious').toString(), equals(
        'https://api.github.com/repos/pratt/dinosaurs/labels/delicious'));
  }
}
