part of squint;

/// Wraps the [Gateway] to provide ordered batch access.
/// Consumers should access the library through this interface.
class Client {
  static final log = new Logger('Client');

  final Gateway _g = new Gateway();

  List<Map<String, String>> fetch() async {
    var res = await _g.getAll();
    var out = JSON.decode(res) as List<Map>;
    log.fine('fetch: ${out.length}');
    return out;
  }

  remove(List labels) async {
    log.fine('remove: ${labels.length}');
    return Future.forEach(labels, (name) async {
      log.info('remove: $name');
      await _g.delete(name);
    });
  }

  change(List labels) async {
    log.fine('change: ${labels.length}');
    return Future.forEach(labels, (obj) async {
      var l = new Label.from(obj);
      log.info('change: $l');
      await _g.set(l.name, l.rgb);
    });
  }

  add(List labels) async {
    log.fine('add: ${labels.length}');
    return Future.forEach(labels, (obj) async {
      var l = new Label.from(obj);
      log.info('add: $l');
      await _g.create(l.name, l.rgb);
    });
  }
}
