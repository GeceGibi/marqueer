part of 'marqueer.dart';

class _MarqueerScrollView extends BoxScrollView {
  const _MarqueerScrollView(
    this.delegate, {
    super.controller,
    super.physics,
    super.reverse,
    super.padding,
    super.scrollDirection,
    super.semanticChildCount,
    super.hitTestBehavior,
    // super.clipBehavior,
    // super.cacheExtent,
    // super.keyboardDismissBehavior,
    // super.dragStartBehavior,
  });

  final SliverChildDelegate delegate;

  bool get isWebOrDesktop => kIsWeb || (!Platform.isAndroid && !Platform.isIOS);

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

class _WebAndDesktopMouseDragBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices {
    return {
      PointerDeviceKind.touch,
      PointerDeviceKind.mouse,
    };
  }

  /// Hide Scrollbar
  @override
  Widget buildScrollbar(context, child, details) {
    return child;
  }
}
