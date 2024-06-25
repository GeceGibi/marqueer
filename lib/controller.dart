part of marqueer;

class MarqueerController {
  MarqueerController();

  final _marquees = <_MarqueerState>[];
  void _attach(_MarqueerState marqueer) {
    _marquees.add(marqueer);
  }

  void _detach(_MarqueerState marqueer) {
    _marquees.remove(marqueer);
  }

  bool get hasClients => _marquees.isNotEmpty;

  /// Get animate status of Marqueer widget
  bool get isAnimating {
    assert(hasClients, 'Not found any attached marqueer widget');
    assert(_marquees.length == 1, 'Multiple marqueer widget attached.');
    return _marquees.single.animating;
  }

  /// Start movement for attached Marqueer widget
  void start() {
    assert(hasClients, 'Not found any attached marqueer widget');
    for (final state in _marquees) {
      state.start();
    }
  }

  /// Stop movement for attached Marqueer widget
  void stop() {
    assert(hasClients, 'Not found any attached marqueer widget');
    for (final state in _marquees) {
      state.stop();
    }
  }

  /// Move to forward attached Marqueer widget
  void forward() {
    assert(hasClients, 'Not found any attached marqueer widget');
    for (final state in _marquees) {
      state.forward();
    }
  }

  /// Move to backward attached Marqueer widget
  void backward() {
    assert(hasClients, 'Not found any attached marqueer widget');
    for (final state in _marquees) {
      state.backward();
    }
  }

  /// Change interaction status attached Marqueer widget
  void interactionEnabled(bool enabled) {
    assert(hasClients, 'Not found any attached marqueer widget');
    for (final state in _marquees) {
      state.interactionEnabled(enabled);
    }
  }
}
