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

final log = new Logger('squint');

/// Load configuration.  Application code must call this once, early in [main].
void init() => dotenv.load();

get _env => dotenv.env;
