part of squint;

/// Provide resource [Uri]s to a [HttpClient].
class UriBuilder {
  final String owner;
  final String repo;

  const UriBuilder(this.owner, this.repo);

  Uri get ofCollection => _from(_url);

  Uri ofItem(String label) => _from('$_url/$label');

  String get forBrowser => 'https://github.com/$owner/$repo/labels';

  Uri _from(String path) => Uri.parse(path);

  String get _url => 'https://api.github.com/repos/$owner/$repo/labels';
}
