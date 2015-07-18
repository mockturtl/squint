/// squint is a client for GitHub's issue labels API.
library squint;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dotenv/dotenv.dart' as dotenv;
import 'package:pico_log/pico_log.dart';

part 'src/client.dart';
part 'src/filters.dart';
part 'src/gateway.dart';
part 'src/label.dart';
part 'src/presenter.dart';
part 'src/uri_builder.dart';

const _requiredEnvVars = const ['owner', 'repo'];

/// Load configuration.  Application code must call this once, early in `main()`.
Client init() {
  dotenv.load();
  return new Client();
}

bool get hasEnv => dotenv.isEveryDefined(_requiredEnvVars);

Map<String, String> get env => dotenv.env;
