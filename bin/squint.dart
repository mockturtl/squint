import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:pico_log/pico_log.dart' as pico_log;
import 'package:squint/squint.dart';
import 'package:yaml/yaml.dart';

final log = new Logger('squint');

Filters f;
Client cli;

final ArgParser _args = new ArgParser()
  ..addFlag('help', abbr: 'h', negatable: false, help: 'Print this help text.')
  ..addFlag('quiet',
      abbr: 'q', negatable: false, help: 'Suppress logger output.')
  ..addOption('file',
      abbr: 'f',
      defaultsTo: '.squint.yml',
      help: 'Configuration file to read.\nSupported file types: .json, .yml, .yaml');

main(List<String> args) async {
  var opts = _args.parse(args);
  if (opts['help']) return _usage();

  var lvl = opts['quiet'] ? Level.SEVERE : Level.FINE;
  pico_log.setup(level: lvl, timestamps: false);

  cli = init();

  var file = _verify(opts['file']);
  var config = parse(file);
  log.info('Squinting at repo ${env['owner']}/${env['repo']}...');

  var currentLabels = await cli.fetch();
  f = new Filters(currentLabels);

  await add(config['add']);
  await remove(config['remove']);

  log.info('Done. ${cli.browserUrl}');
}

Future add(List<Map> labels) async {
  var newLabels = f.excludeByName(labels);
  await cli.add(newLabels);
}

Future change(List<Map> labels) async {
  var existingLabels = f.includeByName(labels);
  var noRepeats = f.excludeByNameAndColor(existingLabels);
  await cli.change(noRepeats);
}

Future remove(List<String> names) async {
  var included = f.include(names);
  await cli.remove(included);
}

/// Logs to [stderr] if [filename] does not exist.
File _verify(String filename) {
  var f = new File(filename);
  if (f.existsSync()) return f;

  log.severe('Load failed: file not found: $filename');
  exit(2);
}

Map parse(File f) {
  var ext = path.extension(f.path);
  var bytes = f.readAsStringSync();
  switch (ext) {
    case '.json':
      return JSON.decode(bytes);
    case '.yml':
    case '.yaml':
      return loadYaml(bytes);
    default:
      log.severe('Unrecognized file type: ${f.path}.');
      exit(3);
  }
}

void _usage() {
  _p('Create a new file and gitignore it.');
  _p('Usage: pub global run squint:squint [-f <file>]\n${_args.usage}');
}

_p(String msg) => stdout.writeln(msg);
