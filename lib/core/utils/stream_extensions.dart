import 'dart:async';

extension SwitchMapStream<T> on Stream<T> {
  /// Like [asyncExpand], but when the source emits again the previous inner
  /// stream is cancelled instead of awaited. Needed when inner streams never
  /// finish (e.g. a drift `watch()`), otherwise later source events are
  /// never seen.
  Stream<R> switchMap<R>(Stream<R> Function(T value) mapper) {
    late StreamController<R> controller;
    StreamSubscription<T>? outer;
    StreamSubscription<R>? inner;
    var outerDone = false;

    controller = StreamController<R>(
      onListen: () {
        outer = listen(
          (value) {
            inner?.cancel();
            inner = mapper(value).listen(
              controller.add,
              onError: controller.addError,
              onDone: () {
                inner = null;
                if (outerDone) controller.close();
              },
            );
          },
          onError: controller.addError,
          onDone: () {
            outerDone = true;
            if (inner == null) controller.close();
          },
        );
      },
      onPause: () {
        outer?.pause();
        inner?.pause();
      },
      onResume: () {
        outer?.resume();
        inner?.resume();
      },
      onCancel: () async {
        await inner?.cancel();
        await outer?.cancel();
      },
    );
    return controller.stream;
  }
}
