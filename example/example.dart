import 'dart:math';

import 'package:squint/squint.dart' as squint;
import 'package:pico_log/pico_log.dart';
import 'package:logging/logging.dart';

final _client = new squint.Client();
final _gateway = new squint.Gateway();

/// The environment must contain certain variables. See README.
void main() {
  LogInit.setup(level: Level.FINE);
  run();
}

final log = new Logger('example');

void run() async {
  squint.init();

  var labels = await _client.fetch();
  log.info('run: got ${labels.length} labels');
  labels.forEach((ob) => log.fine('\t-> $ob'));

  log.fine('GET-> ${await _gateway.get('bug')}');
  log.fine('PATCH-> ${await _gateway.set('bug', _randomHexRgb)}');

  log.fine('POST-> ${await _gateway.create('tmp', _randomHexRgb)}');
  log.fine('DELETE-> ${(await _gateway.delete('tmp') as String).isEmpty}');
}

String get _randomHexRgb => '$_randomHexValue$_randomHexValue$_randomHexValue';
String get _randomHexValue =>
    new Random().nextInt(256).toRadixString(16).padLeft(2, '0');
