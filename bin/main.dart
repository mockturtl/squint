import 'package:squint/squint.dart' as squint;
import 'package:log_init/log_init.dart';
import 'package:logging/logging.dart';

import 'dart:io';
import 'dart:convert';
import 'dart:async';

const configFile = '.squintrc.json';
final path = Platform.script.resolve('..');
final config = path.resolve(configFile).toFilePath();
final f = new File(config);

final log = new Logger('main');

void main() async {
  LogInit.setup(level: Level.FINE, timestamps: false);
  log.info(
      'Squinting at repo ${Platform.environment['owner']}/${Platform.environment['repo']}...');

  var labels = await fetch() as List<Map>;

  _checkConfig(f);

  var config = JSON.decode(f.readAsStringSync());

  var toAdd = config['add'] as List<Map>;
  log.fine('main: adding ${toAdd.length} labels');
  toAdd.removeWhere((el) {
    var name = el['name'];
    var exists = labels.any((l) => l['name'] == name);
    if (exists) log.warning('main: label "$name" exists; skipping');
    return exists;
  });
  await add(toAdd);

  var toChange = config['change'] as List<Map>;
  log.fine('main: changing ${toChange.length} labels');
  toChange.removeWhere((el) {
    var name = el['name'];
    var exists = labels.any((l) => l['name'] == name);
    if (!exists) log.warning('main: label "$name" does not exist; skipping');
    return !exists;
  });
  await change(toChange);

  var toRemove = config['remove'] as List<String>;
  log.fine('main: removing ${toRemove.length} labels');
  toRemove.removeWhere((name) {
    var exists = labels.any((l) => l['name'] == name);
    if (!exists) log.warning('main: label "$name" does not exist; skipping');
    return !exists;
  });
  await remove(toRemove);

  log.info('...done!');
}

List<Map<String, String>> fetch() async {
  var res = await squint.getAll();
  var out = JSON.decode(res) as List<Map>;
  log.fine('fetch: got ${out.length} labels');
  return out;
}

remove(List labels) async {
  return Future.forEach(labels, (name) async {
    log.fine('remove: $name');
    await squint.delete(name);
  });
}

change(List labels) async {
  return Future.forEach(labels, (obj) async {
    var l = new squint.Label.from(obj);
    log.fine('change: $l');
    await squint.set(l.name, l.rgb);
  });
}

add(List labels) async {
  return Future.forEach(labels, (obj) async {
    var l = new squint.Label.from(obj);
    log.fine('add: $l');
    await squint.create(l.name, l.rgb);
  });
}

void _checkConfig(File f) {
  if (!f.existsSync()) {
    log.severe('Cannot find ${configFile}; aborting.');
    log.finer('path: ${path.toFilePath()}');
    exit(11);
  }
}
