part of squint;

/// Wraps the [Gateway] to provide ordered batch access.
/// Consumers should access the library through this interface.
class Client {
  final UriBuilder _uri;
  final Gateway gateway;

  /// Uses the environment `owner`, `repo` to build GitHub api urls.
  Client() : this._internal(new UriBuilder(env['owner'], env['repo']));

  /// Specify the GitHub owner and repo explicitly.
  /// Useful for testing.
  Client.from(String owner, String repo)
      : this._internal(new UriBuilder(owner, repo));

  Client._internal(UriBuilder b)
      : _uri = b,
        gateway = new Gateway(b);

  /// Retrieve all current issue labels for the repository.
  Future<List<Map<String, String>>> fetch() async {
    var res = await gateway.getAll();
    return JSON.decode(res) as List<Map>;
  }

  /// Delete the supplied issue labels.
  Future<List<String>> remove(List names) async =>
      Future.wait(names.map((n) => gateway.delete(n)));

  /// Update the color of the supplied issue labels.
  Future<List<String>> change(List maps) async =>
      Future.wait(_toLabels(maps).map((l) => gateway.set(l.name, l.hex)));

  /// Create the supplied issue labels.
  Future<List<String>> add(List maps) async =>
      Future.wait(_toLabels(maps).map((l) => gateway.create(l.name, l.hex)));

  /// A link to GitHub's labels page for the repository.
  String get browserUrl => _uri.forBrowser;

  Iterable<Label> _toLabels(List maps) => maps.map(_toLabel);

  // FIXME https://github.com/dart-lang/dart_enhancement_proposals/tree/master/Accepted/0003%20-%20Generalized%20Tear-offs
  Label _toLabel(Map<String, String> m) => new Label.from(m);
}
