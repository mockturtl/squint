part of squint;

/// CRUD interface to the remote issue labels service.
/// Prefer [Client] to calling the [Gateway] directly.
class Gateway {
  final _cli = new HttpClient();
  final _p = new GithubPresenter('mockturtl/squint', _env['OAUTH_TOKEN']);
  final UriBuilder _uri;

  Gateway(this._uri);

  /// Create a new issue label.
  Future<String> create(String label, String rgb) async => _cli
      .postUrl(_uri.ofCollection)
      .then((req) => _p.sendWith(req, new Label(label, rgb)))
      .then(_p.decode);

  /// Change an issue label's color.
  Future<String> set(String label, String rgb) async => _cli
      .patchUrl(_uri.ofItem(label))
      .then((req) => _p.sendWith(req, new Label(label, rgb)))
      .then(_p.decode);

  /// Delete an issue label.  Note this method returns the empty string.
  Future<String> delete(String label) async =>
      _cli.deleteUrl(_uri.ofItem(label)).then(_p.send).then(_p.decode);

  /// Fetch a single issue label.
  Future<String> get(String label) async =>
      _cli.getUrl(_uri.ofItem(label)).then(_p.send).then(_p.decode);

  /// Fetch the set of all issue labels for the repository.
  Future<String> getAll() async =>
      _cli.getUrl(_uri.ofCollection).then(_p.send).then(_p.decode);
}
