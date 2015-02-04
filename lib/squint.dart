/// squint is a client for GitHub's issue labels api.
library squint;

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:dotenv/dotenv.dart' as dotenv;

part 'src/http_presenter.dart';
part 'src/github_presenter.dart';
part 'src/client.dart';
part 'src/filters.dart';
part 'src/gateway.dart';
part 'src/label.dart';
part 'src/uri_builder.dart';

const _requiredEnvVars = const ['owner', 'repo'];

/// Load configuration.  Application code must call this once, early in `main()`.
Client init() {
  dotenv.load();
  return new Client();
}

/// True if all required environment variables are present; false otherwise.
/// Note [init] must be called first.
bool get hasEnv => dotenv.every(_requiredEnvVars);

/// The process environment.  See [dotenv].
Map<String, String> get _env => dotenv.env;
