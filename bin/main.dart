import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:logging/logging.dart';
import 'package:pico_log/pico_log.dart' as pico_log;
import 'package:squint/squint.dart';

const configFile = '.squintrc.json';
final path = Platform.script.resolve('..');
final config = path.resolve(configFile).toFilePath();
final file = new File(config);

final log = new Logger('squint');
const f = const Filters();

Client cli;
List<Map> currentLabels;

Future main() async {
  pico_log.setup(level: Level.FINE, timestamps: false);
  cli = init();

  _checkConfig(file);
  var config = JSON.decode(file.readAsStringSync());

  log.info('Squinting at repo ${env['owner']}/${env['repo']}...');

  currentLabels = await cli.fetch();

  await add(config['add']);
  await change(config['change']);
  await remove(config['remove']);

  log.info('...Done: ${cli.browserUrl}');
}

Future add(List<Map> labels) async {
  f.blacklist(labels, currentLabels);
  await cli.add(labels);
}

Future change(List<Map> labels) async {
  f.whitelist(labels, currentLabels);
  f.blacklist2(labels, currentLabels);
  await cli.change(labels);
}

Future remove(List<String> names) async {
  f.whitelist2(names, currentLabels);
  await cli.remove(names);
}

void _checkConfig(File f) {
  if (!f.existsSync()) {
    log.severe('Cannot find ${configFile}; aborting.');
    log.finer('path: ${path.toFilePath()}');
    exit(2);
  }
}
