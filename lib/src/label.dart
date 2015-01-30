part of squint;

class Label {
  final String name;
  final String rgb;

  const Label(this.name, this.rgb);

  Map<String, String> _toMap(_) => {'name': name, 'color': rgb};

  String toJson() => JSON.encode(this, toEncodable: _toMap);
}
