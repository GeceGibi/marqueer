part of 'marqueer.dart';

/// Controller for programmatically controlling Marqueer widgets
class MarqueerController {
  /// Creates a new controller
  MarqueerController();

  final _marquees = <_MarqueerState>[];

  /// Attaches marquee state to controller
  void _attach(_MarqueerState marqueer) {
    _marquees.add(marqueer);
  }

  /// Detaches marquee state from controller
  void _detach(_MarqueerState marqueer) {
    _marquees.remove(marqueer);
  }

  /// Returns true if any marquee widgets are attached
  bool get hasClients => _marquees.isNotEmpty;

  /// Returns animation status
  /// Throws if no widgets attached or multiple widgets attached
  bool get isAnimating {
    assert(hasClients, 'Not found any attached marqueer widget');
    assert(_marquees.length == 1, 'Multiple marqueer widget attached.');
    return _marquees.single.animating;
  }

  /// Starts animation for all attached widgets
  /// Throws if no widgets attached
  void start() {
    assert(hasClients, 'Not found any attached marqueer widget');
    for (final state in _marquees) {
      state.start();
    }
  }

  /// Stops animation for all attached widgets
  /// Throws if no widgets attached
  void stop() {
    assert(hasClients, 'Not found any attached marqueer widget');
    for (final state in _marquees) {
      state.stop();
    }
  }

  /// Starts forward animation for all attached widgets
  /// Throws if no widgets attached
  void forward() {
    assert(hasClients, 'Not found any attached marqueer widget');
    for (final state in _marquees) {
      state.forward();
    }
  }

  /// Starts backward animation for all attached widgets
  /// Throws if no widgets attached
  void backward() {
    assert(hasClients, 'Not found any attached marqueer widget');
    for (final state in _marquees) {
      state.backward();
    }
  }

  /// Animates all attached widgets to the specified position
  /// Throws if no widgets attached
  ///
  /// [position] - Target scroll position
  /// [duration] - Animation duration (default: 100ms)
  /// [curve] - Animation curve (default: linear)
  Future<void> animateTo(
    double position, {
    Duration duration = const Duration(milliseconds: 100),
    Curve curve = Curves.linear,
  }) async {
    assert(hasClients, 'Not found any attached marqueer widget');

    await Future.wait(
      _marquees.map((state) {
        return state.animateTo(position, duration: duration, curve: curve);
      }),
    );
  }

  /// Enables or disables user interaction for all attached widgets
  /// Throws if no widgets attached
  void interactionEnabled(bool enabled) {
    assert(hasClients, 'Not found any attached marqueer widget');
    for (final state in _marquees) {
      state.interactionEnabled(enabled);
    }
  }

  /// Returns current scroll offset
  /// Throws if no widgets attached or multiple widgets attached
  double get offset {
    assert(hasClients, 'Not found any attached marqueer widget');
    assert(_marquees.length == 1, 'Multiple marqueer widget attached.');
    return _marquees.single.scrollController.offset;
  }

  /// Recalculates intrinsic size for all attached widgets
  /// Use this when child content changes and intrinsicCrossAxisSize is enabled
  /// Throws if no widgets attached
  void recalculateIntrinsicSize() {
    assert(hasClients, 'Not found any attached marqueer widget');
    for (final state in _marquees) {
      state._recalculateIntrinsicSize();
    }
  }
}
