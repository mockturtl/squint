part of squint;

/// Value object representing an issue label.
class Label {
  /// Label name.
  final String name;

  /// Label color as rrggbb, with no leading `#`.
  final String hex;

  const Label(this.name, this.hex);

  /// The supplied map must have keys `name`, `color`.
  Label.from(Map<String, String> map) : this(map['name'], map['color']);

  String toJson() => JSON.encode(this, toEncodable: _toMap);

  String toString() => toJson();

  Map<String, String> _toMap(_) => {'name': name, 'color': hex};
}
