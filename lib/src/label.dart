part of squint;

/// Value object representing an issue label.
class Label {
  final String name;
  final String rgb;

  const Label(this.name, this.rgb);

  Label.from(Map<String, String> map) : this(map['name'], map['color']);

  Map<String, String> _toMap(_) => {'name': name, 'color': rgb};

  String toJson() => JSON.encode(this, toEncodable: _toMap);

  String toString() => toJson();
}
