library squint.bin;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:pico_log/pico_log.dart' as pico_log;
import 'package:squint/squint.dart';
import 'package:yaml/yaml.dart' as yaml;

part 'src/errors.dart';
part 'src/validation.dart';

const validateApi = const DataValidation();
const validateConfig = const ConfigFileValidation();

final log = new Logger('squint');
final _args = _buildArgParser();

Filters filt;
Client cli;

main(List<String> args) async {
  var opts = _args.parse(args);
  if (opts['help']) return _usage();

  pico_log.setup(opts: opts, timestamps: false);

  cli = init();

  var file = _verify(opts['file']);
  var config = _parse(file);
  validateConfig(config);

  log.info('Squinting at repo ${env['owner']}/${env['repo']}...');

  var currentLabels = await cli.fetch();
  validateApi(currentLabels);
  filt = new Filters(currentLabels);

  await add(config['add']);
  await change(config['change']);
  await remove(config['remove']);

  log.info('Done. ${cli.browserUrl}');
}

Future add(List<Map> labels) async {
  if (labels == null || labels.isEmpty) return;
  validateApi(labels);
  var newLabels = filt.excludeByName(labels);
  await cli.add(newLabels);
}

Future change(List<Map> labels) async {
  if (labels == null || labels.isEmpty) return;
  validateApi(labels);
  var existingLabels = filt.includeByName(labels);
  var noRepeats = filt.excludeByNameAndColor(existingLabels);
  await cli.change(noRepeats);
}

Future remove(List<String> names) async {
  if (names == null || names.isEmpty) return;
  validateApi.nonnull(names);
  var included = filt.include(names);
  await cli.remove(included);
}

/// Logs to [stderr] if [filename] does not exist.
File _verify(String filename) {
  var f = new File(filename);
  if (f.existsSync()) return f;

  log.severe('Load failed: file not found: $filename');
  exit(Errors.CFG_FILE_NOT_FOUND);
}

Map _parse(File f) {
  var ext = path.extension(f.path);
  var bytes = f.readAsStringSync();
  switch (ext) {
    case '.json':
      return JSON.decode(bytes);
    case '.yml':
    case '.yaml':
      return yaml.loadYaml(bytes);
    default:
      log.severe('Unrecognized file type: ${f.path}.');
      exit(Errors.CFG_UNKNOWN_FILE_TYPE);
  }
}

ArgParser _buildArgParser() => pico_log.buildArgParser()
  ..addFlag('help', abbr: 'h', negatable: false, help: 'Print this help text.')
  ..addOption('file',
      abbr: 'f',
      defaultsTo: '.squint.yml',
      help: 'Configuration file to read. Supported file types: .json, .yml, .yaml');

void _usage() {
  _p('Add, remove or change a GitHub repo\'s issue labels.');
  _p('Usage: pub global run squint [options]\n${_args.usage}');
}

_p(String msg) => stdout.writeln(msg);
