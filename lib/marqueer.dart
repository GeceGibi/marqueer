library marqueer;

import 'dart:async';
import 'dart:io';
import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

part 'controller.dart';
part 'scroll_view.dart';

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

Axis _getAxisForMarqueerDirection(MarqueerDirection direction) {
  return switch (direction) {
    MarqueerDirection.rtl || MarqueerDirection.ltr => Axis.horizontal,
    MarqueerDirection.ttb || MarqueerDirection.btt => Axis.vertical
  };
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
    this.interactionsChangesAnimationDirection = true,
    this.edgeDuration = Duration.zero,
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

            if (separatorBuilder == null) {
              return child;
            }

            final children = [child];

            if (direction == MarqueerDirection.rtl) {
              children.add(separatorBuilder(context, index));
            } else {
              children.insert(0, separatorBuilder(context, index));
            }

            return Flex(
              direction: _getAxisForMarqueerDirection(direction),
              mainAxisSize: MainAxisSize.min,
              children: children,
            );
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
    this.interactionsChangesAnimationDirection = true,
    this.edgeDuration = Duration.zero,
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

            if (separatorBuilder == null || index + 1 == itemCount) {
              return widget;
            }

            final children = [widget];

            if (direction == MarqueerDirection.rtl) {
              children.add(separatorBuilder(context, index));
            } else {
              children.insert(0, separatorBuilder(context, index));
            }

            return Flex(
              direction: _getAxisForMarqueerDirection(direction),
              children: children,
            );
          },
          childCount: itemCount,
          addAutomaticKeepAlives: itemCount != null,
        );

  final SliverChildDelegate delegate;

  /// Direction
  final MarqueerDirection direction;

  /// The amount of space by which to inset the children.
  final EdgeInsets padding;

  /// Pixel Per Second
  final double pps;

  /// Interactions
  final bool interaction;

  /// Stop when interaction
  final bool restartAfterInteraction;

  ///
  final bool interactionsChangesAnimationDirection;

  /// Restart delay
  final Duration restartAfterInteractionDuration;

  /// Controller
  final MarqueerController? controller;

  /// auto start
  ///
  /// Defaults to [false].
  final bool autoStart;

  /// Auto Start after marqueer created in widget tree.
  ///
  /// Defaults to [Duration.zero].
  final Duration autoStartAfter;

  /// Adding delay  for animation restart when reached edges.
  /// Only working when Marqueer is finite or childCount is declared
  ///
  /// Defaults to [Duration.zero].
  final Duration edgeDuration;

  /// {@macro flutter.widgets.scrollable.hitTestBehavior}
  ///
  /// Defaults to [HitTestBehavior.opaque].
  final HitTestBehavior hitTestBehavior;

  /// Scrollable Widget has default Ignore pointer.
  /// It's causing some gesture bugs, with this prob Scrollable > IgnorePointer is ignoring. :).
  ///
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

class _MarqueerState extends State<Marqueer> with WidgetsBindingObserver {
  final scrollController = ScrollController();

  var scrollDirection = ScrollDirection.reverse;
  var animating = false;

  late var isInteractionEnabled = widget.interaction;

  Timer? timerStarter;
  Timer? timerLoop;
  Timer? timerInteraction;
  Timer? timerWidowResize;

  Duration? run() {
    final position = getNextPosition();

    if (position == null) {
      return null;
    }

    var distance = (scrollController.offset - position.abs()).abs();

    if (distance <= 0) {
      distance = position.abs();
    }

    final duration = Duration(
      milliseconds: ((distance / widget.pps) * 1000).round(),
    );

    scrollController.animateTo(
      position,
      duration: duration,
      curve: Curves.linear,
    );

    if (widget.scrollablePointerIgnoring) {
      _searchIgnorePointer(context.findRenderObject());
    }

    return duration;
  }

  void start() {
    widget.onStarted?.call();
    createLoop();
  }

  ScrollDirection changeScrollDirection(ScrollDirection direction) {
    return switch (direction) {
      ScrollDirection.idle => ScrollDirection.idle,
      ScrollDirection.forward => ScrollDirection.reverse,
      ScrollDirection.reverse => ScrollDirection.forward
    };
  }

  void forward() {
    scrollDirection = changeScrollDirection(ScrollDirection.forward);

    stop();
    start();
  }

  void backward() {
    scrollDirection = changeScrollDirection(ScrollDirection.reverse);

    stop();
    start();
  }

  void createLoop() {
    final duration = run();
    if (duration == null) {
      return;
    }

    const gap = Duration(milliseconds: 50);

    timerLoop?.cancel();
    timerLoop = Timer(
      duration + gap + widget.edgeDuration,
      createLoop,
    );
  }

  void stop() {
    if (!mounted) {
      return;
    }

    scrollController.jumpTo(scrollController.offset);

    timerLoop?.cancel();
    timerStarter?.cancel();
    timerInteraction?.cancel();
    timerWidowResize?.cancel();

    widget.onStopped?.call();
  }

  double? getNextPosition() {
    final ScrollController(:offset, :position) = scrollController;
    final ScrollPosition(:maxScrollExtent, :viewportDimension) = position;

    if (maxScrollExtent == 0) {
      return null;
    }

    if (offset == 0) {
      if (!widget.infinity && _kDefaultStep >= maxScrollExtent) {
        return maxScrollExtent;
      }

      return _kDefaultStep;
    }

    ///
    else if (offset >= maxScrollExtent) {
      if (!widget.infinity && _kDefaultStep >= maxScrollExtent) {
        return 0;
      }

      return _kDefaultStep;
    }

    switch (scrollDirection) {
      case ScrollDirection.idle:
        return _kDefaultStep;

      case ScrollDirection.forward:
        final next = offset - _kDefaultStep;

        if (next <= 0) {
          return 0;
        }

        return next;

      case ScrollDirection.reverse:
        final next = offset + _kDefaultStep;

        if (next >= maxScrollExtent) {
          return maxScrollExtent;
        }

        return next;
    }
  }

  void interactionEnabled(bool enabled) {
    if (isInteractionEnabled == enabled) {
      return;
    }

    timerInteraction?.cancel();
    isInteractionEnabled = enabled;
    setState(() {});
  }

  void onPointerUpHandler(PointerUpEvent event) {
    if (!widget.restartAfterInteraction || !widget.interaction) {
      return;
    }

    /// Wait for scroll animation end
    timerInteraction = Timer(widget.restartAfterInteractionDuration, start);
  }

  void onPointerDownHandler(PointerDownEvent event) {
    widget.onInteraction?.call();

    timerInteraction?.cancel();
    timerLoop?.cancel();
  }

  void _searchIgnorePointer(RenderObject? renderObject) {
    if (renderObject == null) {
      return;
    }

    renderObject.visitChildren((child) {
      if (child is RenderIgnorePointer) {
        child.ignoring = false;
      } else {
        _searchIgnorePointer(child);
      }
    });
  }

  void scrollListener() {
    final ScrollPosition(
      :userScrollDirection,
      :isScrollingNotifier,
    ) = scrollController.position;

    isScrollingNotifier.addListener(() {
      if (animating == isScrollingNotifier.value) {
        return;
      }

      animating = isScrollingNotifier.value;
    });

    if (widget.interactionsChangesAnimationDirection) {
      if (scrollDirection == userScrollDirection ||
          userScrollDirection == ScrollDirection.idle) {
        return;
      }

      scrollDirection = userScrollDirection;
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) {
      return;
    }

    super.setState(fn);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    if (animating) {
      stop();
      timerWidowResize?.cancel();
      timerWidowResize = Timer(const Duration(milliseconds: 100), start);
    }
  }

  @override
  void initState() {
    super.initState();

    widget.controller?._attach(this);
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.autoStart) {
        timerStarter = Timer(widget.autoStartAfter, start);
      }

      scrollController.addListener(scrollListener);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    widget.controller?._detach(this);

    WidgetsBinding.instance.removeObserver(this);

    timerLoop?.cancel();
    timerStarter?.cancel();
    timerInteraction?.cancel();
    timerWidowResize?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isVertical = widget.direction == MarqueerDirection.btt ||
        widget.direction == MarqueerDirection.ttb;

    final isReverse = widget.direction == MarqueerDirection.ltr ||
        widget.direction == MarqueerDirection.btt;

    final physics = isInteractionEnabled
        ? const BouncingScrollPhysics()
        : const NeverScrollableScrollPhysics();

    return Listener(
      behavior: widget.hitTestBehavior,
      onPointerDown: onPointerDownHandler,
      onPointerUp: onPointerUpHandler,
      child: _MarqueerScrollView(
        widget.delegate,
        physics: physics,
        reverse: isReverse,
        padding: widget.padding,
        controller: scrollController,
        scrollDirection: isVertical ? Axis.vertical : Axis.horizontal,
        semanticChildCount: widget.delegate.estimatedChildCount,
        hitTestBehavior: widget.hitTestBehavior,
      ),
    );
  }
}
