part of squint;

/// Value object representing an issue label.
class Label {
  static String _sanitize(String hex) =>
      hex.replaceFirst('#', '').replaceFirst('0x', '');

  /// Label name.
  final String name;

  /// Label color as RRGGBB, with no leading `#` or '0x'.
  final String hex;

  Label(this.name, String hex) : this.hex = _sanitize(hex);

  /// The supplied map must have keys `name`, `color`.
  Label.from(Map<String, String> map) : this(map['name'], map['color']);

  String toJson() => JSON.encode(this, toEncodable: _toMap);

  String toString() => toJson();

  Map<String, String> _toMap(_) => {'name': name, 'color': hex};
}
