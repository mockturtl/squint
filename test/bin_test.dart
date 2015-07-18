library squint.bin.test;

import 'package:squint/squint.dart' as squint;
import 'package:test/test.dart';

import '../bin/squint.dart';

main() {
  group('[bin/squint]', () {
    setUp(() {
      cli = squint.init();
      filt = new squint.Filters.clean();
    });
    test('it handles missing sections in the config file', () {
      expect(() async => await add([]), returnsNormally);
      expect(() async => await change([]), returnsNormally);
      expect(() async => await remove([]), returnsNormally);
    });
  });
}
