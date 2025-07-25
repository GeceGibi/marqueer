part of 'marqueer.dart';

/// Controller for programmatically controlling Marqueer widgets
/// Provides methods to start, stop, and control marquee animations
class MarqueerController {
  /// Creates a new MarqueerController
  MarqueerController();

  final _marquees = <_MarqueerState>[];

  /// Attaches a marquee state to this controller
  void _attach(_MarqueerState marqueer) {
    _marquees.add(marqueer);
  }

  /// Detaches a marquee state from this controller
  void _detach(_MarqueerState marqueer) {
    _marquees.remove(marqueer);
  }

  /// Returns true if any marquee widgets are attached to this controller
  bool get hasClients => _marquees.isNotEmpty;

  /// Returns the animation status of the attached marquee widget
  /// Throws an assertion error if no widgets are attached or multiple widgets are attached
  bool get isAnimating {
    assert(hasClients, 'Not found any attached marqueer widget');
    assert(_marquees.length == 1, 'Multiple marqueer widget attached.');
    return _marquees.single.animating;
  }

  /// Starts animation for all attached marquee widgets
  /// Throws an assertion error if no widgets are attached
  void start() {
    assert(hasClients, 'Not found any attached marqueer widget');
    for (final state in _marquees) {
      state.start();
    }
  }

  /// Stops animation for all attached marquee widgets
  /// Throws an assertion error if no widgets are attached
  void stop() {
    assert(hasClients, 'Not found any attached marqueer widget');
    for (final state in _marquees) {
      state.stop();
    }
  }

  /// Starts forward animation for all attached marquee widgets
  /// Throws an assertion error if no widgets are attached
  void forward() {
    assert(hasClients, 'Not found any attached marqueer widget');
    for (final state in _marquees) {
      state.forward();
    }
  }

  /// Starts backward animation for all attached marquee widgets
  /// Throws an assertion error if no widgets are attached
  void backward() {
    assert(hasClients, 'Not found any attached marqueer widget');
    for (final state in _marquees) {
      state.backward();
    }
  }

  /// Enables or disables user interaction for all attached marquee widgets
  /// Throws an assertion error if no widgets are attached
  void interactionEnabled(bool enabled) {
    assert(hasClients, 'Not found any attached marqueer widget');
    for (final state in _marquees) {
      state.interactionEnabled(enabled);
    }
  }
}
