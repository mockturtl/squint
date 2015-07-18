part of squint;

/// Validate input before sending.
/// Don't try to add labels that already exist, or update/remove labels that do not exist.
class Filters {
  static final _log = buildLogger(Filters);

  final List<Map> _items;

  const Filters(this._items);
  const Filters.clean() : this(const []);

  /// Returns those elements of [input] whose name occurs in [_currentLabels].
  Iterable<Map> includeByName(Iterable<Map> src) =>
      src.where((el) => _items.any((i) => el['name'] == i['name']));

  /// Mutates [input], removing elements that do not match any item in the [whitelist].
  Iterable<String> include(Iterable<String> src) =>
      src.where((str) => _items.any((i) => str == i['name']));

  /// Returns those elements of [input] whose name does not occur in [_currentLabels].
  Iterable<Map> excludeByName(Iterable<Map> src) =>
      src.where((el) => !_items.any((i) => i['name'] == el['name']));

  /// Returns those elements of [input] whose name and color do not occur in [_currentLabels].
  Iterable<Map> excludeByNameAndColor(Iterable<Map> src) => src.where(
      (el) => !_items
          .any((i) => i['name'] == el['name'] && i['color'] == el['color']));
}
