part of squint;

/// CRUD interface for the remote issue labels service.
/// For batch access, see [Client].
class Gateway {
  final _cli = new HttpClient();
  final _p = new GithubPresenter('mockturtl/squint', _env['OAUTH_TOKEN']);
  final _uri = new UriBuilder(_env['owner'], _env['repo']);

  /// Create a new issue label.
  String create(String label, String rgb) async => _cli
      .postUrl(_uri.ofCollection)
      .then((HttpClientRequest req) => _p.sendWith(req, new Label(label, rgb)))
      .then(_p.decode);

  /// Change an issue label's color.
  String set(String label, String rgb) async => _cli
      .patchUrl(_uri.ofItem(label))
      .then((HttpClientRequest req) => _p.sendWith(req, new Label(label, rgb)))
      .then(_p.decode);

  /// Delete an issue label.  Note this method returns the empty string.
  String delete(String label) async =>
      _cli.deleteUrl(_uri.ofItem(label)).then(_p.send).then(_p.decode);

  /// Fetch a single issue label.
  String get(String label) async =>
      _cli.getUrl(_uri.ofItem(label)).then(_p.send).then(_p.decode);

  /// Fetch the set of all issue labels for the repository.
  String getAll() async =>
      _cli.getUrl(_uri.ofCollection).then(_p.send).then(_p.decode);
}
