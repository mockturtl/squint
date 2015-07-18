part of squint.bin;

/// Verify label data is a JSON array of `{"name": _, "color": _}` objects.
class DataValidation {
  static const _requiredKeys = const ['name', 'color'];

  static final _log = pico_log.buildLogger(DataValidation);

  const DataValidation();

  void call(Iterable<Map<String, String>> items) {
    items.forEach((i) {
      if (i == null) _fail(i); // FIXME [1]
      var ok = _requiredKeys.every((k) => i.containsKey(k));
      if (!ok) _fail(i);
    });
  }

  // FIXME [1]
  void nonnull(Iterable<String> items) {
    items.forEach((i) {
      if (i == null) _fail(i);
    });
  }

  void _fail(dynamic i) {
    _log.severe('Unexpected data format: $i.  Aborting.');
    exit(Errors.INVALID_DATA_FORMAT);
  }

// [1]: https://github.com/dart-lang/dart_enhancement_proposals/tree/master/Accepted/0009%20-%20Null-aware%20Operators
}

/// Verify the config file is a nonempty dictionary with certain keys.
class ConfigFileValidation {
  static const _allowedKeys = const ['add', 'remove', 'change'];

  static final _log = pico_log.buildLogger(ConfigFileValidation);

  static const validateData = const DataValidation();

  const ConfigFileValidation();

  void call(Map<String, List> map) {
    if (map == null || map.isEmpty) {
      _log.severe('File empty. Aborting.');
      exit(Errors.CFG_INVALID_FORMAT);
    }

    var sections = map.keys;
    var ok = sections.every((s) => _allowedKeys.contains(s));
    if (!ok) {
      _log.severe('Unexpected key in $sections. Aborting.');
      exit(Errors.CFG_INVALID_FORMAT);
    }
  }
}
