part of 'marqueer.dart';

/// A widget that measures the size of its child and reports it through a callback.
///
/// This widget uses [RenderProxyBox] to efficiently measure the child's size
/// after layout. The [onChange] callback is triggered whenever the child's
/// size changes.
///
/// Example:
/// ```dart
/// MeasureSize(
///   onChange: (size) {
///     print('Widget size: ${size.width} x ${size.height}');
///   },
///   child: Text('Hello World'),
/// )
/// ```
class MeasureSize extends SingleChildRenderObjectWidget {
  /// Creates a widget that measures its child's size.
  ///
  /// The [onChange] callback is called with the new size whenever the child's
  /// size changes during layout.
  const MeasureSize({
    required this.onChange,
    required Widget super.child,
    super.key,
  });

  /// Callback that is called with the measured size of the child.
  final ValueChanged<Size> onChange;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChange);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    MeasureSizeRenderObject renderObject,
  ) {
    renderObject.onChange = onChange;
  }
}

/// Custom render object that tracks size changes of its child.
class MeasureSizeRenderObject extends RenderProxyBox {
  /// Creates a render object that reports size changes.
  MeasureSizeRenderObject(this.onChange);

  /// Callback to report size changes.
  ValueChanged<Size> onChange;

  /// Tracks the previous size to detect changes.
  Size? _oldSize;

  @override
  void performLayout() {
    super.performLayout();

    // Only trigger callback if size actually changed
    if (_oldSize != size) {
      _oldSize = size;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onChange(size);
      });
    }
  }
}
