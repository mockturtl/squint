part of squint;

/// Wraps the [Gateway] to provide ordered batch access.
/// Consumers should access the library through this interface.
class Client {
  static final _log = new Logger('Client');

  UriBuilder _uri;
  Gateway _g;

  /// Uses the environment `owner`, `repo` to build GitHub api urls.
  Client() {
    _uri = new UriBuilder(_env['owner'], _env['repo']);
    _g = new Gateway(_uri);
  }

  /// Specify the GitHub owner and repo explicitly.
  /// Useful for testing.
  Client.from(String owner, String repo) {
    _uri = new UriBuilder(owner, repo);
    _g = new Gateway(_uri);
  }

  /// Retrieve all current issue labels for the repository.
  List<Map<String, String>> fetch() async {
    var res = await _g.getAll();
    var out = JSON.decode(res) as List<Map>;
    _log.fine('fetch: ${out.length}');
    return out;
  }

  /// Delete the supplied issue labels.
  remove(List labels) async {
    _log.fine('remove: ${labels.length}');
    return Future.forEach(labels, (name) async {
      _log.info('remove: $name');
      await _g.delete(name);
    });
  }

  /// Update the color of the supplied issue labels.
  change(List labels) async {
    _log.fine('change: ${labels.length}');
    return Future.forEach(labels, (obj) async {
      var l = new Label.from(obj);
      _log.info('change: $l');
      await _g.set(l.name, l.hex);
    });
  }

  /// Create the supplied issue labels.
  add(List labels) async {
    _log.fine('add: ${labels.length}');
    return Future.forEach(labels, (obj) async {
      var l = new Label.from(obj);
      _log.info('add: $l');
      await _g.create(l.name, l.hex);
    });
  }

  /// A link to GitHub's labels page for the repository.
  String get browserUrl => _uri.forBrowser;

  /// The [Gateway] is exposed for the sake of example.
  /// You should not need it.
  Gateway get gateway => _g;
}
