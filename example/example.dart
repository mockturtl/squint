import 'dart:math';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:pico_log/pico_log.dart' as pico_log;
import 'package:squint/squint.dart' as squint;

final log = new Logger('squint.example');

squint.Client client;

/// The environment must contain certain variables. See README.
main() async {
  pico_log.setup(level: Level.FINE);
  client = squint.init();
  _checkEnv();

  var labels = await client.fetch();
  log.info('run: got ${labels.length} labels');
  labels.forEach((ob) => log.fine('\t-> $ob'));

  var g = client.gateway;
  log.info('GET-> ${await g.get('bug')}');
  log.info('PATCH-> ${await g.set('bug', _randomHexRgb)}');
  log.info('POST-> ${await g.create('tmp', _randomHexRgb)}');
  log.info('DELETE-> ${(await g.delete('tmp') as String).isEmpty}\n');

  log.fine('Have a look!  ${client.browserUrl}');
}

void _checkEnv() {
  if (!squint.hasEnv) {
    log.severe(
        'Cannot get repository url from the environment; aborting. See README.');
    exit(2);
  }
}

String get _randomHexRgb => '$_randomHexValue$_randomHexValue$_randomHexValue';
String get _randomHexValue =>
    new Random().nextInt(256).toRadixString(16).padLeft(2, '0');
