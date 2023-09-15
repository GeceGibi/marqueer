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

  bool get isAnimating {
    assert(hasClients, "Not found any attached marqueer widget");
    assert(_marquees.length == 1, "Multiple marqueer widget attached.");
    return _marquees.single.animating;
  }

  void start() {
    assert(hasClients, "Not found any attached marqueer widget");
    for (var state in _marquees) {
      state.start();
    }
  }

  void stop() {
    assert(hasClients, "Not found any attached marqueer widget");
    for (var state in _marquees) {
      state.stop();
    }
  }

  void forward() {
    assert(hasClients, "Not found any attached marqueer widget");
    for (var state in _marquees) {
      state.forward();
    }
  }

  void backward() {
    assert(hasClients, "Not found any attached marqueer widget");
    for (var state in _marquees) {
      state.backward();
    }
  }

  void interactionEnabled(bool enabled) {
    assert(hasClients, "Not found any attached marqueer widget");
    for (var state in _marquees) {
      state.interactionEnabled(enabled);
    }
  }
}
