library;

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

/// Returns the scroll axis for the given marquee direction
Axis _getAxisForMarqueerDirection(MarqueerDirection direction) {
  return switch (direction) {
    .rtl || .ltr => .horizontal,
    .ttb || .btt => .vertical,
  };
}

/// A widget that animates its children in a continuous scrolling marquee
/// Supports horizontal and vertical directions with customizable speed and interaction
class Marqueer extends StatefulWidget {
  /// Creates a marquee widget with a single child
  ///
  /// [child] - The widget to animate
  /// [separatorBuilder] - Optional separator between items
  /// [pps] - Animation speed in pixels per second (default: 15.0)
  /// [infinity] - Loop infinitely (default: true)
  /// [autoStart] - Start automatically (default: true)
  /// [direction] - Animation direction (default: rtl)
  /// [interaction] - Allow user interaction (default: true)
  /// [restartAfterInteractionDuration] - Delay before restart after interaction (default: 3s)
  /// [restartAfterInteraction] - Restart after interaction (default: true)
  /// [onChangeItemInViewPort] - Callback when item changes in viewport
  /// [autoStartAfter] - Delay before auto-start (default: zero)
  /// [onInteraction] - Callback on user interaction
  /// [controller] - Optional controller for programmatic control
  /// [onStarted] - Callback when animation starts
  /// [onStopped] - Callback when animation stops
  /// [padding] - Padding around marquee (default: zero)
  /// [hitTestBehavior] - Hit test behavior (default: translucent)
  /// [scrollablePointerIgnoring] - Ignore pointer events on scrollable (default: false)
  /// [interactionsChangesAnimationDirection] - Interactions change direction (default: true)
  /// [edgeDuration] - Delay at edges for finite marquees (default: zero)
  Marqueer({
    required Widget child,
    Widget Function(BuildContext context, int index)? separatorBuilder,
    this.pps = 15.0,
    this.infinity = true,
    this.autoStart = true,
    this.direction = .rtl,
    this.interaction = true,
    this.restartAfterInteractionDuration = const Duration(seconds: 3),
    this.restartAfterInteraction = true,
    this.onChangeItemInViewPort,
    this.autoStartAfter = .zero,
    this.onInteraction,
    this.controller,
    this.onStarted,
    this.onStopped,
    this.padding = .zero,
    this.hitTestBehavior = .translucent,
    this.scrollablePointerIgnoring = false,
    this.interactionsChangesAnimationDirection = true,
    this.edgeDuration = .zero,
    super.key,
  }) : assert(
         (() {
           if (autoStartAfter > .zero) {
             return autoStart;
           }

           return true;
         })(),
         'if `autoStartAfter` duration bigger than `zero` then `autoStart` must be `true`',
       ),
       delegate = SliverChildBuilderDelegate(
         (context, index) {
           onChangeItemInViewPort?.call(index);

           if (separatorBuilder == null) {
             return child;
           }

           final children = [child];

           if (direction == .rtl) {
             children.add(separatorBuilder(context, index));
           } else {
             children.insert(0, separatorBuilder(context, index));
           }

           return Flex(
             direction: _getAxisForMarqueerDirection(direction),
             mainAxisSize: .min,
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
    this.direction = .rtl,
    this.interaction = true,
    this.restartAfterInteractionDuration = const Duration(seconds: 3),
    this.restartAfterInteraction = true,
    this.onChangeItemInViewPort,
    this.autoStartAfter = Duration.zero,
    this.onInteraction,
    this.controller,
    this.onStarted,
    this.onStopped,
    this.padding = .zero,
    this.hitTestBehavior = .opaque,
    this.scrollablePointerIgnoring = false,
    this.interactionsChangesAnimationDirection = true,
    this.edgeDuration = .zero,
    super.key,
  }) : assert(
         (() {
           if (autoStartAfter > .zero) {
             return autoStart;
           }

           return true;
         })(),
         'if `autoStartAfter` duration bigger than `zero` then `autoStart` must be `true`',
       ),
       infinity = itemCount == null,
       delegate = SliverChildBuilderDelegate(
         (context, index) {
           onChangeItemInViewPort?.call(index);

           final widget = itemBuilder(context, index);

           if (separatorBuilder == null || index + 1 == itemCount) {
             return widget;
           }

           final children = [widget];

           if (direction == .rtl) {
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

  /// Animation direction
  final MarqueerDirection direction;

  /// Padding around content
  final EdgeInsets padding;

  /// Animation speed in pixels per second
  final double pps;

  /// Enable user interaction
  final bool interaction;

  /// Restart after user interaction
  final bool restartAfterInteraction;

  /// Interactions change animation direction
  final bool interactionsChangesAnimationDirection;

  /// Delay before restart after interaction
  final Duration restartAfterInteractionDuration;

  /// Controller for programmatic control
  final MarqueerController? controller;

  /// Start animation automatically
  final bool autoStart;

  /// Delay before auto-start
  final Duration autoStartAfter;

  /// Delay at edges for finite marquees
  final Duration edgeDuration;

  /// Hit test behavior
  final HitTestBehavior hitTestBehavior;

  /// Ignore pointer events on scrollable
  final bool scrollablePointerIgnoring;

  /// Loop infinitely
  final bool infinity;

  /// Called when animation starts
  final void Function()? onStarted;

  /// Called when animation stops
  final void Function()? onStopped;

  /// Called on user interaction
  final void Function()? onInteraction;

  /// Called when item changes in viewport
  final void Function(int index)? onChangeItemInViewPort;

  @override
  State<Marqueer> createState() => _MarqueerState();
}

/// Internal state class for Marqueer widget
/// Manages animation, scrolling, and user interaction
class _MarqueerState extends State<Marqueer> with WidgetsBindingObserver {
  final scrollController = ScrollController();

  ScrollDirection scrollDirection = .reverse;
  var animating = false;

  late bool interaction = widget.interaction;

  Size? viewSize;

  Timer? timerStarter;
  Timer? timerLoop;
  Timer? timerInteraction;
  Timer? timerWidowResize;

  /// Calculates and executes the next animation step
  /// Returns animation duration or null if not possible
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
      unawaited(
        scrollController.animateTo(
          position,
          duration: duration,
          curve: Curves.linear,
        ),
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

  /// Starts forward animation
  void forward() {
    scrollDirection = .reverse;

    stop();
    start();
  }

  /// Starts backward animation
  void backward() {
    scrollDirection = .forward;

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

    _cancelAllTimers();

    widget.onStopped?.call();
  }

  /// Calculates the next scroll position
  /// Returns null if no valid position
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
      case .idle:
        return _kDefaultStep;

      case .forward:
        final next = offset - _kDefaultStep;

        if (next <= 0) {
          return 0;
        }

        return next;

      case .reverse:
        final next = offset + _kDefaultStep;

        if (next >= maxScrollExtent) {
          return maxScrollExtent;
        }

        return next;
    }
  }

  /// Enables or disables user interaction
  void interactionEnabled(bool enabled) {
    if (interaction == enabled) {
      return;
    }

    timerInteraction?.cancel();
    interaction = enabled;
    setState(() {});
  }

  /// Handles pointer up events
  void onPointerUpHandler(PointerUpEvent event) {
    if (!widget.restartAfterInteraction || !widget.interaction) {
      return;
    }
    timerInteraction = Timer(widget.restartAfterInteractionDuration, start);
  }

  /// Handles pointer down events
  void onPointerDownHandler(PointerDownEvent event) {
    widget.onInteraction?.call();

    timerInteraction?.cancel();
    timerLoop?.cancel();
  }

  /// Searches and disables IgnorePointer widgets in render tree
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

  VoidCallback? _isScrollingNotifierListener;

  /// Listens to scroll events and updates animation state
  void scrollListener() {
    final ScrollPosition(
      :userScrollDirection,
      :isScrollingNotifier,
    ) = scrollController.position;

    _isScrollingNotifierListener ??= () {
      if (animating == isScrollingNotifier.value) {
        return;
      }

      animating = isScrollingNotifier.value;
    };

    isScrollingNotifier.addListener(_isScrollingNotifierListener!);

    if (widget.interactionsChangesAnimationDirection) {
      if (scrollDirection == userScrollDirection ||
          userScrollDirection == .idle) {
        return;
      }

      scrollDirection = userScrollDirection;
    }
  }

  void _cancelAllTimers() {
    timerLoop?.cancel();
    timerStarter?.cancel();
    timerInteraction?.cancel();
    timerWidowResize?.cancel();
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
    if (_isScrollingNotifierListener != null) {
      scrollController.position.isScrollingNotifier.removeListener(
        _isScrollingNotifierListener!,
      );
    }

    scrollController.dispose();

    widget.controller?._detach(this);

    WidgetsBinding.instance.removeObserver(this);

    _cancelAllTimers();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isVertical = widget.direction == .btt || widget.direction == .ttb;
    final isReverse = widget.direction == .ltr || widget.direction == .btt;

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
        scrollDirection: isVertical ? .vertical : .horizontal,
        semanticChildCount: widget.delegate.estimatedChildCount,
        hitTestBehavior: widget.hitTestBehavior,
      ),
    );
  }
}
