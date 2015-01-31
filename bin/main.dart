import 'package:squint/squint.dart' as squint;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

final path = Platform.script.resolve('..');
final config = path.resolve('.squintrc.json').toFilePath();
final f = new File(config);

void main() {
  //squint.getAll();
  //squint.get('bug');
  //squint.set('bug', 'fc2929');
  //squint.create('qux', 'ff4081');
  //squint.delete('qux');

  _checkConfig(f);

  var str = f.readAsStringSync();
  var map = JSON.decode(str);

  //TODO: enforce running in series

  var toAdd = map['add'] as List<Map<String, String>>;
  print('add: $toAdd');
  //add(toAdd);

  var toChange = map['change'] as List<Map<String, String>>;
  print('change: $toChange');
  //change(toChange);

  var toRemove = map['remove'] as List<String>;
  print('remove: $toRemove');
  //remove(toRemove);
}

void remove(List labels) {
  Future.forEach(labels, (name) {
    print('removing: $name');
    squint.delete(name);
  });
}

void change(List labels) {
  Future.forEach(labels, (obj) {
    var l = new squint.Label.from(obj);
    print('changing: $l');
    squint.set(l.name, l.rgb);
  });
}

void add(List labels) {
  Future.forEach(labels, (obj) {
    var l = new squint.Label.from(obj);
    print('adding: $l');
    squint.create(l.name, l.rgb);
  });
}

void _checkConfig(File f) {
  if (!f.existsSync()) {
    print('Cannot find .squintrc.json; aborting.');
    print('path: ${path.toFilePath()}');
    exit(11);
  }
}
