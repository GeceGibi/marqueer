library marqueer;

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

part 'controller.dart';
part 'scroll_view.dart';

const _kDefaultStep = 10000.0;

/// Direction types for marquee animation
/// RightToLeft, LeftToRight, TopToBottom, BottomToTop
enum MarqueerDirection {
  /// Right to Left animation direction
  rtl,

  /// Left to Right animation direction
  ltr,

  /// Top to Bottom animation direction
  ttb,

  /// Bottom to Top animation direction
  btt,
}

Axis _getAxisForMarqueerDirection(MarqueerDirection direction) {
  return switch (direction) {
    MarqueerDirection.rtl || MarqueerDirection.ltr => Axis.horizontal,
    MarqueerDirection.ttb || MarqueerDirection.btt => Axis.vertical
  };
}

class Marqueer extends StatefulWidget {
  /// Creates a marquee widget with a single child
  ///
  /// [child] - The widget to animate
  /// [separatorBuilder] - Optional builder for separator widgets between items
  /// [pps] - Pixels per second for animation speed (default: 15.0)
  /// [infinity] - Whether to loop infinitely (default: true)
  /// [autoStart] - Whether to start animation automatically (default: true)
  /// [direction] - Animation direction (default: MarqueerDirection.rtl)
  /// [interaction] - Whether to allow user interaction (default: true)
  /// [restartAfterInteractionDuration] - Delay before restarting after interaction (default: 3 seconds)
  /// [restartAfterInteraction] - Whether to restart after user interaction (default: true)
  /// [onChangeItemInViewPort] - Callback when item changes in viewport
  /// [autoStartAfter] - Delay before auto-starting (default: Duration.zero)
  /// [onInteraction] - Callback when user interacts
  /// [controller] - Optional controller for programmatic control
  /// [onStarted] - Callback when animation starts
  /// [onStopped] - Callback when animation stops
  /// [padding] - Padding around the marquee (default: EdgeInsets.zero)
  /// [hitTestBehavior] - Hit test behavior (default: HitTestBehavior.translucent)
  /// [scrollablePointerIgnoring] - Whether to ignore pointer events on scrollable (default: false)
  /// [interactionsChangesAnimationDirection] - Whether interactions change animation direction (default: true)
  /// [edgeDuration] - Duration delay at edges for finite marquees (default: Duration.zero)
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

  /// Creates a marquee widget with multiple items using a builder
  ///
  /// [itemBuilder] - Builder function for creating items
  /// [separatorBuilder] - Optional builder for separator widgets between items
  /// [itemCount] - Number of items to display (null for infinite)
  /// [pps] - Pixels per second for animation speed (default: 15.0)
  /// [autoStart] - Whether to start animation automatically (default: true)
  /// [direction] - Animation direction (default: MarqueerDirection.rtl)
  /// [interaction] - Whether to allow user interaction (default: true)
  /// [restartAfterInteractionDuration] - Delay before restarting after interaction (default: 3 seconds)
  /// [restartAfterInteraction] - Whether to restart after user interaction (default: true)
  /// [onChangeItemInViewPort] - Callback when item changes in viewport
  /// [autoStartAfter] - Delay before auto-starting (default: Duration.zero)
  /// [onInteraction] - Callback when user interacts
  /// [controller] - Optional controller for programmatic control
  /// [onStarted] - Callback when animation starts
  /// [onStopped] - Callback when animation stops
  /// [padding] - Padding around the marquee (default: EdgeInsets.zero)
  /// [hitTestBehavior] - Hit test behavior (default: HitTestBehavior.opaque)
  /// [scrollablePointerIgnoring] - Whether to ignore pointer events on scrollable (default: false)
  /// [interactionsChangesAnimationDirection] - Whether interactions change animation direction (default: true)
  /// [edgeDuration] - Duration delay at edges for finite marquees (default: Duration.zero)
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

  /// Animation direction for the marquee
  final MarqueerDirection direction;

  /// Padding around the marquee content
  final EdgeInsets padding;

  /// Animation speed in pixels per second
  final double pps;

  /// Whether user interaction is enabled
  final bool interaction;

  /// Whether to restart animation after user interaction
  final bool restartAfterInteraction;

  /// Whether user interactions change the animation direction
  final bool interactionsChangesAnimationDirection;

  /// Delay before restarting animation after user interaction
  final Duration restartAfterInteractionDuration;

  /// Controller for programmatic control of the marquee
  final MarqueerController? controller;

  /// Whether to start animation automatically
  final bool autoStart;

  /// Delay before auto-starting the animation
  final Duration autoStartAfter;

  /// Duration delay at edges for finite marquees
  final Duration edgeDuration;

  /// Hit test behavior for pointer events
  final HitTestBehavior hitTestBehavior;

  /// Whether to ignore pointer events on scrollable widgets
  final bool scrollablePointerIgnoring;

  /// Whether the marquee loops infinitely
  final bool infinity;

  /// Callback when animation starts
  final void Function()? onStarted;

  /// Callback when animation stops
  final void Function()? onStopped;

  /// Callback when user interacts with the marquee
  final void Function()? onInteraction;

  /// Callback when item changes in viewport
  final void Function(int index)? onChangeItemInViewPort;

  @override
  State<Marqueer> createState() => _MarqueerState();
}

class _MarqueerState extends State<Marqueer> with WidgetsBindingObserver {
  final scrollController = ScrollController();

  ScrollDirection scrollDirection = ScrollDirection.reverse;
  var animating = false;

  late bool interaction = widget.interaction;

  Size? viewSize;

  Timer? timerStarter;
  Timer? timerLoop;
  Timer? timerInteraction;
  Timer? timerWidowResize;

  /// Calculates and executes the next animation step
  /// Returns the duration of the animation or null if no animation is possible
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

    try {
      scrollController.animateTo(
        position,
        duration: duration,
        curve: Curves.linear,
      );
    } catch (e) {
      // no-op
    }

    if (widget.scrollablePointerIgnoring) {
      _searchIgnorePointer(context.findRenderObject());
    }

    return duration;
  }

  /// Starts the marquee animation
  void start() {
    widget.onStarted?.call();
    createLoop();
  }

  /// Starts forward animation (left to right or bottom to top)
  void forward() {
    scrollDirection = ScrollDirection.reverse;

    stop();
    start();
  }

  /// Starts backward animation (right to left or top to bottom)
  void backward() {
    scrollDirection = ScrollDirection.forward;

    stop();
    start();
  }

  /// Creates a continuous animation loop
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

  /// Stops the marquee animation and cancels all timers
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

  /// Calculates the next scroll position based on current direction and bounds
  /// Returns null if no valid position can be calculated
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

  /// Enables or disables user interaction with the marquee
  void interactionEnabled(bool enabled) {
    if (interaction == enabled) {
      return;
    }

    timerInteraction?.cancel();
    interaction = enabled;
    setState(() {});
  }

  /// Handles pointer up events and restarts animation if configured
  void onPointerUpHandler(PointerUpEvent event) {
    if (!widget.restartAfterInteraction || !widget.interaction) {
      return;
    }

    /// Wait for scroll animation end
    timerInteraction = Timer(widget.restartAfterInteractionDuration, start);
  }

  /// Handles pointer down events and stops animation
  void onPointerDownHandler(PointerDownEvent event) {
    widget.onInteraction?.call();

    timerInteraction?.cancel();
    timerLoop?.cancel();
  }

  /// Searches for and disables IgnorePointer widgets in the render tree
  /// This is used to fix gesture handling issues on scrollable widgets
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

  /// Listens to scroll events and updates animation state
  /// Handles user scroll direction changes and animation state tracking
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

    if (!mounted) return;

    final size = MediaQuery.sizeOf(context);

    if (viewSize == size || !animating) {
      return;
    }

    viewSize = size;

    stop();
    timerWidowResize?.cancel();
    timerWidowResize = Timer(const Duration(milliseconds: 100), start);
  }

  @override
  void initState() {
    super.initState();

    widget.controller?._attach(this);
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewSize = MediaQuery.sizeOf(context);

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
  void didUpdateWidget(covariant Marqueer oldWidget) {
    super.didUpdateWidget(oldWidget);

    final needsRestart = oldWidget.pps != widget.pps ||
        oldWidget.direction != widget.direction ||
        oldWidget.edgeDuration != widget.edgeDuration ||
        oldWidget.infinity != widget.infinity;

    if (needsRestart) {
      // kill any in-flight animation/timers and restart the loop
      stop();
      // keep current offset, just cancel the animation cleanly
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.offset);
      }
      if (widget.autoStart) start();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isVertical = widget.direction == MarqueerDirection.btt ||
        widget.direction == MarqueerDirection.ttb;

    final isReverse = widget.direction == MarqueerDirection.ltr ||
        widget.direction == MarqueerDirection.btt;

    final physics = interaction
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
