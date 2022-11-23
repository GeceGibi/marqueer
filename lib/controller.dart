part of marqueer;

class MarqueerController {
  MarqueerController();

  final _marquees = <_MarqueerState>[];
  void _attach(_MarqueerState marqueer) {
    _marquees.add(marqueer);
  }

  void _deattach(_MarqueerState marqueer) {
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
    for (var marq in _marquees) {
      marq.start();
    }
  }

  void stop() {
    assert(hasClients, "Not found any attached marqueer widget");
    for (var marq in _marquees) {
      marq.stop();
    }
  }

  void interactionEnabled(bool enabled) {
    assert(hasClients, "Not found any attached marqueer widget");
    for (var marq in _marquees) {
      marq.interactionEnabled(enabled);
    }
  }
}
