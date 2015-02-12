import 'dart:convert';
import 'dart:io';

import 'package:dotenv/dotenv.dart' as dotenv;
import 'package:logging/logging.dart';
import 'package:pico_log/pico_log.dart';
import 'package:squint/squint.dart' as squint;

const configFile = '.squintrc.json';
final path = Platform.script.resolve('..');
final config = path.resolve(configFile).toFilePath();
final f = new File(config);

final log = new Logger('squint');
const _f = const squint.Filters();

get _env => dotenv.env;

squint.Client _cli;
List<Map> _currentLabels;

void main() async {
  LogInit.setup(level: Level.FINE, timestamps: false);
  _cli = squint.init();

  _checkConfig(f);
  var config = JSON.decode(f.readAsStringSync());

  log.info('Squinting at repo ${_env['owner']}/${_env['repo']}...');

  _currentLabels = await _cli.fetch();

  await _add(config['add']);
  await _change(config['change']);
  await _remove(config['remove']);

  log.info('...Done: ${_cli.browserUrl}');
}

void _add(List<Map> labels) async {
  _f.blacklist(labels, _currentLabels);
  await _cli.add(labels);
}

void _change(List<Map> labels) async {
  _f.whitelist(labels, _currentLabels);
  _f.blacklist2(labels, _currentLabels);
  await _cli.change(labels);
}

void _remove(List<String> names) async {
  _f.whitelist2(names, _currentLabels);
  await _cli.remove(names);
}

void _checkConfig(File f) {
  if (!f.existsSync()) {
    log.severe('Cannot find ${configFile}; aborting.');
    log.finer('path: ${path.toFilePath()}');
    exit(2);
  }
}
