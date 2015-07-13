import 'dart:math';
import 'dart:io';
import 'dart:async';

import 'package:squint/squint.dart' as squint;
import 'package:pico_log/pico_log.dart';
import 'package:logging/logging.dart';

final log = new Logger('squint.example');

squint.Client _client;

/// The environment must contain certain variables. See README.
void main() {
  LogInit.setup(level: Level.FINE);
  _client = squint.init();
  _checkEnv();
  run();
}

Future run() async {
  var labels = await _client.fetch();
  log.info('run: got ${labels.length} labels');
  labels.forEach((ob) => log.fine('\t-> $ob'));

  var _gateway = _client.gateway;
  log.fine('GET-> ${await _gateway.get('bug')}');
  log.fine('PATCH-> ${await _gateway.set('bug', _randomHexRgb)}');

  log.fine('POST-> ${await _gateway.create('tmp', _randomHexRgb)}');
  log.fine('DELETE-> ${(await _gateway.delete('tmp') as String).isEmpty}\n');

  log.info('Have a look!  ${_client.browserUrl}');
}

void _checkEnv() {
  if (!squint.hasEnv) {
    log.severe(
        'Cannot get repository url from the environment; aborting.  See README.');
    exit(2);
  }
}

String get _randomHexRgb => '$_randomHexValue$_randomHexValue$_randomHexValue';
String get _randomHexValue =>
    new Random().nextInt(256).toRadixString(16).padLeft(2, '0');
