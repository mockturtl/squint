import 'package:squint/squint.dart' as squint;
import 'package:pico_log/pico_log.dart';
import 'package:logging/logging.dart';
import 'dart:convert';
import 'dart:async';

/// The environment must contain certain variables. See README.
void main() {
  LogInit.setup(level: Level.FINE);
  run();
}

final log = new Logger('example');

void run() async {
  squint.init();
  var res = await squint.getAll();
  var labels = JSON.decode(res) as List<Map>;
  log.info('run: got ${labels.length} labels');
  labels.forEach((ob) => log.fine('-> $ob'));

  log.fine('-> ${await squint.get('bug')}');
  log.fine('-> ${await squint.set('bug', 'fc2929')}');
  log.fine('-> ${await squint.create('tmp', 'ff4081')}');
  log.fine('-> ${(await squint.delete('tmp') as String).isEmpty}');
}
