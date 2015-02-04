part of squint;

/// Verify input before sending.
/// Don't try to add labels that already exist, or update/remove labels that do not exist.
class Filters {
  static const _key = 'name';

  static final _log = new Logger('Filters');

  const Filters();

  /// Mutates [input], removing elements that do not match any item in the [whitelist].
  void whitelist(List<Map<String, dynamic>> input,
      Iterable<Map<String, dynamic>> whitelist) {
    input.removeWhere((map) {
      var val = map[_key];
      var exists = whitelist.any((l) => l[_key] == val);
      if (!exists) _log
          .warning('whitelist: label "$val" does not exist; skipping');
      return !exists;
    });
  }

  /// Mutates [input], removing elements that do not match any item in the [whitelist].
  void whitelist2(
      List<String> input, Iterable<Map<String, dynamic>> whitelist) {
    input.removeWhere((str) {
      var exists = whitelist.any((l) => l[_key] == str);
      if (!exists) _log
          .warning('whitelist2: label "$str" does not exist; skipping');
      return !exists;
    });
  }

  /// Mutates [input], removing elements that match any item in the [blacklist].
  void blacklist(List<Map<String, dynamic>> input,
      Iterable<Map<String, dynamic>> blacklist) {
    input.removeWhere((map) {
      var val = map[_key];
      var exists = blacklist.any((l) => l[_key] == val);
      if (exists) _log.warning('blacklist: label "$val" exists; skipping');
      return exists;
    });
  }
}
