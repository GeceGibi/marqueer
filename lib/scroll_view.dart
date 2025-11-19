part of 'marqueer.dart';

/// Custom scroll view for marquee widgets
class _MarqueerScrollView extends BoxScrollView {
  /// Creates a new scroll view
  const _MarqueerScrollView(
    this.delegate, {
    super.controller,
    super.physics,
    super.reverse,
    super.padding,
    super.scrollDirection,
    super.semanticChildCount,
    super.hitTestBehavior,
  });

  /// Delegate that provides children
  final SliverChildDelegate delegate;

  /// Returns true if platform is web or desktop
  bool get isWebOrDesktop {
    if (kIsWeb) return true;
    if (Platform.isAndroid || Platform.isIOS) return false;
    return true; // Desktop platforms
  }

  @override
  Widget buildChildLayout(BuildContext context) {
    return SliverList(delegate: delegate);
  }

  @override
  Widget build(BuildContext context) {
    if (isWebOrDesktop) {
      return ScrollConfiguration(
        behavior: _WebAndDesktopMouseDragBehavior(),
        child: super.build(context),
      );
    }

    return super.build(context);
  }
}

/// Custom scroll behavior for web and desktop
class _WebAndDesktopMouseDragBehavior extends ScrollBehavior {
  /// Returns supported drag device types
  @override
  Set<PointerDeviceKind> get dragDevices {
    return {.touch, .mouse};
  }

  /// Hides scrollbars
  @override
  Widget buildScrollbar(context, child, details) {
    return child;
  }
}
