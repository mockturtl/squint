part of squint;

/// Wraps the [Gateway] to provide ordered batch access.
/// Consumers should access the library through this interface.
class Client {
  final UriBuilder _uri;
  final Gateway gateway;

  /// Uses the environment `owner`, `repo` to build GitHub API urls.
  Client() : this._(new UriBuilder(env['owner'], env['repo']));

  /// Specify the GitHub owner and repo explicitly.
  Client.from(String owner, String repo) : this._(new UriBuilder(owner, repo));

  Client._(UriBuilder b)
      : _uri = b,
        gateway = new Gateway(b);

  /// Retrieve all current issue labels for the repository.
  Future<List> fetch() async {
    var res = await gateway.getAll();
    return JSON.decode(res) as List<Map>;
  }

  /// Delete the supplied issue labels.
  Future<List> remove(Iterable names) async =>
      Future.wait(names.map((n) => gateway.delete(n)));

  /// Update the color of the supplied issue labels.
  Future<List> change(Iterable maps) async =>
      Future.wait(_toLabels(maps).map((l) => gateway.set(l.name, l.hex)));

  /// Create the supplied issue labels.
  Future<List> add(Iterable maps) async =>
      Future.wait(_toLabels(maps).map((l) => gateway.create(l.name, l.hex)));

  /// A link to GitHub's labels page for the repository.
  String get browserUrl => _uri.forBrowser;

  Iterable<Label> _toLabels(Iterable maps) => maps.map(_toLabel);

  // FIXME https://github.com/dart-lang/dart_enhancement_proposals/tree/master/Accepted/0003%20-%20Generalized%20Tear-offs
  Label _toLabel(Map m) => new Label.from(m);
}
