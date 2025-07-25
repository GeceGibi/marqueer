part of 'marqueer.dart';

/// Custom scroll view implementation for marquee widgets
/// Handles platform-specific behavior and scroll configuration
class _MarqueerScrollView extends BoxScrollView {
  /// Creates a new _MarqueerScrollView with the given delegate and configuration
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

  /// The delegate that provides the children for this scroll view
  final SliverChildDelegate delegate;

  /// Returns true if the current platform is web or desktop
  /// Used to determine appropriate scroll behavior
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

/// Custom scroll behavior for web and desktop platforms
/// Enables mouse drag support and hides scrollbars
class _WebAndDesktopMouseDragBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices {
    return {
      PointerDeviceKind.touch,
      PointerDeviceKind.mouse,
    };
  }

  /// Hides scrollbars for a cleaner appearance
  @override
  Widget buildScrollbar(context, child, details) {
    return child;
  }
}
