library marqueer;

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

part 'controller.dart';

const _kDefaultStep = 10000.0;

/// Direction types
/// RightToLeft, LeftToRight, TopToBottom, BottomToTop
enum MarqueerDirection {
  /// Right to Left
  rtl,

  /// Left to Right
  ltr,

  /// Top to Bottom
  ttb,

  /// Bottom to Top
  btt,
}

class Marqueer extends StatefulWidget {
  Marqueer({
    required Widget child,
    Widget Function(BuildContext context, int index)? separatorBuilder,
    this.pps = 15.0,
    this.infinity = true,
    this.autoStart = true,
    this.direction = MarqueerDirection.rtl,
    this.interaction = true,
    this.restartAfterInteractionDuration = const Duration(seconds: 3),
    this.restartAfterInteraction = true,
    this.onChangeItemInViewPort,
    this.autoStartAfter = Duration.zero,
    this.onInteraction,
    this.controller,
    this.onStarted,
    this.onStopped,
    this.padding = EdgeInsets.zero,
    this.hitTestBehavior = HitTestBehavior.translucent,
    this.scrollablePointerIgnoring = false,
    super.key,
  })  : assert((() {
          if (autoStartAfter > Duration.zero) {
            return autoStart;
          }

          return true;
        })(),
            'if `autoStartAfter` duration bigger than `zero` then `autoStart` must be `true`'),
        delegate = SliverChildBuilderDelegate(
          (context, index) {
            onChangeItemInViewPort?.call(index);

            if (separatorBuilder != null) {
              final children = [child];

              if (direction == MarqueerDirection.rtl) {
                children.add(separatorBuilder(context, index));
              } else {
                children.insert(0, separatorBuilder(context, index));
              }

              return Flex(
                direction: Axis.horizontal,
                children: children,
              );
            }

            return child;
          },
          childCount: infinity ? null : 1,
          addAutomaticKeepAlives: !infinity,
        );

  Marqueer.builder({
    required Widget Function(BuildContext context, int index) itemBuilder,
    Widget Function(BuildContext context, int index)? separatorBuilder,
    int? itemCount,
    this.pps = 15.0,
    this.autoStart = true,
    this.direction = MarqueerDirection.rtl,
    this.interaction = true,
    this.restartAfterInteractionDuration = const Duration(seconds: 3),
    this.restartAfterInteraction = true,
    this.onChangeItemInViewPort,
    this.autoStartAfter = Duration.zero,
    this.onInteraction,
    this.controller,
    this.onStarted,
    this.onStopped,
    this.padding = EdgeInsets.zero,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.scrollablePointerIgnoring = false,
    super.key,
  })  : assert((() {
          if (autoStartAfter > Duration.zero) {
            return autoStart;
          }

          return true;
        })(),
            'if `autoStartAfter` duration bigger than `zero` then `autoStart` must be `true`'),
        infinity = itemCount == null,
        delegate = SliverChildBuilderDelegate(
          (context, index) {
            onChangeItemInViewPort?.call(index);

            final widget = itemBuilder(context, index);

            if (separatorBuilder != null && index + 1 != itemCount) {
              final children = [widget];

              if (direction == MarqueerDirection.rtl) {
                children.add(separatorBuilder(context, index));
              } else {
                children.insert(0, separatorBuilder(context, index));
              }

              return Flex(
                direction: Axis.horizontal,
                children: children,
              );
            }

            return widget;
          },
          childCount: itemCount,
          addAutomaticKeepAlives: itemCount != null,
        );

  final SliverChildDelegate delegate;

  /// Direction
  final MarqueerDirection direction;

  /// List View Padding
  final EdgeInsets padding;

  /// Pixel Per Second
  final double pps;

  /// Interactions
  final bool interaction;

  /// Stop when interaction
  final bool restartAfterInteraction;

  /// Restart delay
  final Duration restartAfterInteractionDuration;

  /// Controller
  final MarqueerController? controller;

  /// auto start
  final bool autoStart;

  /// Auto Start after duration
  final Duration autoStartAfter;

  final HitTestBehavior hitTestBehavior;

  /// Scrollable Widget has default Ignore pointer.
  /// It's causing some gesture bugs, with this prob Scrollable > IgnorePointer is ignoring. :).
  /// - https://github.com/flutter/flutter/blob/stable/packages/flutter/lib/src/widgets/scrollable.dart#L998
  /// - https://github.com/flutter/flutter/blob/stable/packages/flutter/lib/src/widgets/scrollable.dart#L813
  /// - https://github.com/flutter/flutter/blob/stable/packages/flutter/lib/src/widgets/scroll_context.dart#L60
  final bool scrollablePointerIgnoring;

  ///
  final bool infinity;

  /// callbacks
  final void Function()? onStarted;
  final void Function()? onStopped;
  final void Function()? onInteraction;
  final void Function(int index)? onChangeItemInViewPort;

  @override
  State<Marqueer> createState() => _MarqueerState();
}

class _MarqueerState extends State<Marqueer> {
  final scrollController = ScrollController();

  final isWebOrDesktop = kIsWeb || (!Platform.isAndroid && !Platform.isIOS);

  late var isReverse = widget.direction == MarqueerDirection.ltr ||
      widget.direction == MarqueerDirection.btt;

  late var isVertical = widget.direction == MarqueerDirection.btt ||
      widget.direction == MarqueerDirection.ttb;

  var step = 0.0;
  var offset = 0.0;
  var animating = false;
  var interactionDirection = ScrollDirection.idle;

  late var interaction = widget.interaction;

  Timer? timerLoop;
  Timer? timerInteraction;

  /// Default delay added (1000ms).
  /// Because sometimes not matching timer callback and end of scroll animation callback
  Duration get duration {
    return Duration(milliseconds: ((step.abs() / widget.pps) * 1000).round());
  }

  void animate() {
    scrollController.animateTo(
      offset + step,
      duration: duration,
      curve: Curves.linear,
    );

    if (widget.scrollablePointerIgnoring) {
      _searchIgnorePointer(context.findRenderObject());
    }
  }

  void start({double forStep = _kDefaultStep}) {
    if (animating || !mounted) {
      return;
    }

    if (calculateDistance(forStep: forStep)) {
      animating = true;
      animate();
      createLoop();
      widget.onStarted?.call();
    }
  }

  void forward() {
    stop();
    start();
  }

  void backward() {
    stop();
    start(forStep: -scrollController.offset);
  }

  ///! Note:
  ///! Duration calculating after every interaction
  ///! so Timer.periodic is not a good solution
  void createLoop() {
    final delay = Duration(milliseconds: widget.infinity ? 0 : 50);

    timerLoop?.cancel();
    timerLoop = Timer(duration + delay, () {
      if (calculateDistance()) {
        createLoop();
        animate();
      }
    });
  }

  void stop() {
    if (!animating || !mounted) {
      return;
    }

    animating = false;

    timerLoop?.cancel();
    timerInteraction?.cancel();

    scrollController.jumpTo(scrollController.offset);
    offset = scrollController.offset;

    widget.onStopped?.call();
  }

  bool calculateDistance({double forStep = _kDefaultStep}) {
    final currentPos = scrollController.offset;
    final maxPos = scrollController.position.maxScrollExtent;

    if (widget.infinity) {
      offset = currentPos;
      step = forStep;
      return true;
    }

    final random = Random();

    // Has scrollable content
    if (maxPos > 0 && maxPos.isFinite) {
      switch (interactionDirection) {
        case ScrollDirection.idle:

          /// just pick random direction and move on
          interactionDirection = random.nextBool()
              ? ScrollDirection.forward
              : ScrollDirection.reverse;
          return calculateDistance();

        case ScrollDirection.forward:
          final isStart = currentPos == 0;
          step = isStart ? maxPos : maxPos - (maxPos - currentPos);
          offset = isStart ? 0 : -step;

        case ScrollDirection.reverse:
          final isEnd = maxPos == currentPos;
          step = isEnd ? maxPos : maxPos - currentPos;
          offset = isEnd ? -maxPos : maxPos - step;
      }

      return step.isFinite;
    }

    return false;
  }

  void interactionEnabled(bool enabled) {
    if (interaction != enabled) {
      offset = scrollController.offset;
      timerInteraction?.cancel();

      setState(() {
        interaction = enabled;
      });
    }
  }

  void onPointerUpHandler(PointerUpEvent event) {
    if (widget.restartAfterInteraction) {
      /// Wait for scroll animation end
      timerInteraction = Timer(widget.restartAfterInteractionDuration, () {
        if (calculateDistance()) {
          start();
        }
      });
    }
  }

  void onPointerDownHandler(PointerDownEvent event) {
    animating = false;
    widget.onInteraction?.call();

    /// Clear prev timer if defined
    timerInteraction?.cancel();
    timerLoop?.cancel();
  }

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);

    /// Wait for the rendering end
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.autoStart) {
        Future.delayed(widget.autoStartAfter, start);
      }

      if (!widget.infinity) {
        scrollController.addListener(() {
          final direction = scrollController.position.userScrollDirection;

          if (interactionDirection != direction) {
            interactionDirection = direction;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    timerLoop?.cancel();
    timerInteraction?.cancel();
    widget.controller?._detach(this);
    super.dispose();
  }

  var key = GlobalKey();

  void _searchIgnorePointer(RenderObject? renderObject) {
    if (renderObject != null) {
      renderObject.visitChildren((child) {
        if (child is RenderIgnorePointer) {
          child.ignoring = false;
        } else {
          _searchIgnorePointer(child);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final physics = interaction
        ? const BouncingScrollPhysics()
        : const NeverScrollableScrollPhysics();

    Widget body = _MarqueerScrollView(
      key: key,
      widget.delegate,
      physics: physics,
      reverse: isReverse,
      controller: scrollController,
      padding: widget.padding,
      scrollDirection: isVertical ? Axis.vertical : Axis.horizontal,
      semanticChildCount: widget.delegate.estimatedChildCount,
      hitTestBehavior: widget.hitTestBehavior,
    );

    if (isWebOrDesktop) {
      body = ScrollConfiguration(
        behavior: _WebAndDesktopMouseDragBehavior(),
        child: body,
      );
    }

    return Listener(
      behavior: widget.hitTestBehavior,
      onPointerDown: onPointerDownHandler,
      onPointerUp: onPointerUpHandler,
      child: body,
    );
  }
}

class _WebAndDesktopMouseDragBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices {
    return {PointerDeviceKind.touch, PointerDeviceKind.mouse};
  }
}

class _MarqueerScrollView extends BoxScrollView {
  const _MarqueerScrollView(
    this.delegate, {
    super.controller,
    super.hitTestBehavior,
    super.physics,
    super.reverse,
    super.padding,
    super.scrollDirection,
    super.semanticChildCount,
    super.key,
  });

  final SliverChildDelegate delegate;

  @override
  Widget buildChildLayout(BuildContext context) {
    return SliverList(delegate: delegate);
  }
}
