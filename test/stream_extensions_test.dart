import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_mitra/core/utils/stream_extensions.dart';

void main() {
  test('switchMap drops the previous never-ending inner stream on a new source event', () async {
    final source = StreamController<String>();
    final inners = <String, StreamController<String>>{};
    final seen = <String>[];

    final sub = source.stream.switchMap((key) {
      final inner = StreamController<String>();
      inners[key] = inner;
      return inner.stream;
    }).listen(seen.add);

    source.add('a');
    await Future<void>.delayed(Duration.zero);
    inners['a']!.add('a1');
    await Future<void>.delayed(Duration.zero);

    source.add('b');
    await Future<void>.delayed(Duration.zero);
    inners['a']!.add('a2'); // stale: must be ignored
    inners['b']!.add('b1');
    await Future<void>.delayed(Duration.zero);

    expect(seen, ['a1', 'b1']);
    await sub.cancel();
    await source.close();
  });
}
