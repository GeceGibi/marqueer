library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

part 'controller.dart';
part 'scroll_view.dart';
part 'measure_size.dart';

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

/// A widget that animates its children in a continuous scrolling marquee.
/// Supports horizontal/vertical directions with customizable speed.
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
  /// [restartAfterInteractionDuration] - Delay before restart (default: 3s)
  /// [restartAfterInteraction] - Restart after interaction (default: true)
  /// [onChangeItemInViewPort] - Callback when item changes in viewport
  /// [autoStartAfter] - Delay before auto-start (default: zero)
  /// [onInteraction] - Callback on user interaction
  /// [controller] - Optional controller for programmatic control
  /// [onStarted] - Callback when animation starts
  /// [onStopped] - Callback when animation stops
  /// [padding] - Padding around marquee (default: zero)
  /// [hitTestBehavior] - Hit test behavior (default: translucent)
  /// [scrollablePointerIgnoring] - Ignore pointer on scrollable (default: false)
  /// [interactionsChangesAnimationDirection] - Interactions change direction
  /// [edgeDuration] - Finite only. Rest at the start and the far end
  /// (default: zero)
  /// [pauseDuration] - Rest each time an item lines up with the start
  /// edge (default: zero)
  /// [intrinsicCrossAxisSize] - Auto-size cross axis (default: false)
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
    this.pauseDuration = .zero,
    this.clipBehavior = .hardEdge,
    this.intrinsicCrossAxisSize = false,
    super.key,
  }) : measureChild = child,
       assert(
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
  /// [restartAfterInteractionDuration] - Delay before restart (default: 3s)
  /// [restartAfterInteraction] - Restart after interaction (default: true)
  /// [onChangeItemInViewPort] - Callback when item changes in viewport
  /// [autoStartAfter] - Delay before auto-starting (default: Duration.zero)
  /// [onInteraction] - Callback when user interacts
  /// [controller] - Optional controller for programmatic control
  /// [onStarted] - Callback when animation starts
  /// [onStopped] - Callback when animation stops
  /// [padding] - Padding around the marquee (default: EdgeInsets.zero)
  /// [hitTestBehavior] - Hit test behavior (default: HitTestBehavior.opaque)
  /// [scrollablePointerIgnoring] - Ignore pointer on scrollable (default: false)
  /// [interactionsChangesAnimationDirection] - Interactions change direction
  /// [edgeDuration] - Finite only. Rest at the start and the far end
  /// (default: zero)
  /// [pauseDuration] - Rest each time an item lines up with the start
  /// edge (default: zero)
  /// [intrinsicCrossAxisSize] - Auto-size cross axis (default: false)
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
    this.pauseDuration = .zero,
    this.clipBehavior = .hardEdge,
    this.intrinsicCrossAxisSize = false,
    super.key,
  }) : measureChild = null,
       assert(
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

  /// Children laid out along the scroll axis.
  ///
  /// The default constructor repeats its child. [Marqueer.builder] uses
  /// `itemBuilder`.
  final SliverChildDelegate delegate;

  /// Scroll direction.
  ///
  /// [MarqueerDirection.rtl] moves content left, [MarqueerDirection.ltr]
  /// moves it right, [MarqueerDirection.ttb] moves it down, and
  /// [MarqueerDirection.btt] moves it up.
  final MarqueerDirection direction;

  /// Empty space around the scrolling content.
  final EdgeInsets padding;

  /// Scroll speed in pixels per second.
  ///
  /// `15` moves 15 pixels each second. Higher values scroll faster.
  final double pps;

  /// Whether the user can drag the marquee.
  ///
  /// A pointer down cancels the running loop. When
  /// [restartAfterInteraction] is true, the loop starts again after
  /// [restartAfterInteractionDuration].
  final bool interaction;

  /// Whether a completed drag starts the loop again.
  ///
  /// Has no effect when [interaction] is false.
  final bool restartAfterInteraction;

  /// Whether a drag replaces the animation direction.
  ///
  /// After the user scrolls the other way, the loop continues that way.
  /// When false, the marquee keeps the original [direction].
  final bool interactionsChangesAnimationDirection;

  /// How long to wait after a drag before the loop starts again.
  ///
  /// Used with [restartAfterInteraction]. The default is 3 seconds.
  final Duration restartAfterInteractionDuration;

  /// Optional handle for start, stop, direction, and position changes.
  ///
  /// One controller may attach to several marquees. [MarqueerController.offset]
  /// and [MarqueerController.isAnimating] require exactly one.
  final MarqueerController? controller;

  /// Whether the loop starts on its own after the first frame.
  ///
  /// Set this to false when a [MarqueerController] will call `start`.
  final bool autoStart;

  /// How long to wait after the first frame before [autoStart].
  ///
  /// [Duration.zero] starts on the next frame. A longer delay requires
  /// [autoStart] to be true.
  final Duration autoStartAfter;

  /// How long a finite marquee rests at the start and at the far end.
  ///
  /// Used only when [infinity] is false. The wait begins after the scroll
  /// arrives at offset 0 or at the last pixel, then the loop continues.
  /// [Duration.zero] does not wait. Infinite marquees ignore this value.
  final Duration edgeDuration;

  /// How long to rest each time an item lines up with the start edge.
  ///
  /// The scroll moves until the next item's leading edge reaches the side
  /// it is moving toward, holds, then continues. A long title uses about
  /// one second: the text scrolls, rests when the repeated title is back
  /// at the start, and repeats. Put the gap between copies in
  /// `separatorBuilder`. [Duration.zero] never holds.
  final Duration pauseDuration;

  /// How this marquee participates in hit testing.
  final HitTestBehavior hitTestBehavior;

  /// Whether taps on children keep working while the loop is animating.
  ///
  /// Flutter ignores pointers on a scroll view during an animation. Set
  /// this to true so a child's tap still fires while the marquee moves.
  final bool scrollablePointerIgnoring;

  /// Whether the child is repeated without an end.
  ///
  /// True keeps building copies. False lays the content out once, scrolls
  /// to the far end, then back to the start. [edgeDuration] applies only
  /// to that finite trip. [Marqueer.builder] sets this from `itemCount`:
  /// null repeats forever, a number stops after that many items.
  final bool infinity;

  /// Called each time the loop starts, including a restart after a drag.
  final void Function()? onStarted;

  /// Called when the loop is stopped.
  final void Function()? onStopped;

  /// Called on pointer down while [interaction] is enabled.
  final void Function()? onInteraction;

  /// Called with a child index while that child is built.
  ///
  /// This runs from the item builder. It does not mean the item has
  /// crossed into the viewport.
  final void Function(int index)? onChangeItemInViewPort;

  /// How content outside the marquee box is clipped.
  ///
  /// The default is [Clip.hardEdge].
  final Clip clipBehavior;

  /// Sizes the cross axis from the child.
  ///
  /// A horizontal marquee takes the child's height, a vertical one its
  /// width, so an outer [SizedBox] is unnecessary. Only the default
  /// constructor can measure a child. [Marqueer.builder] cannot.
  final bool intrinsicCrossAxisSize;

  /// Child measured when [intrinsicCrossAxisSize] is true.
  ///
  /// The default constructor sets this to its child. [Marqueer.builder]
  /// leaves it null.
  final Widget? measureChild;

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

  /// Cached reference to the [RenderIgnorePointer] Flutter inserts inside
  /// every [Scrollable] (via `_ignorePointerKey`). It is reused on every new
  /// scroll activity to avoid re-walking the render tree.
  RenderIgnorePointer? _cachedIgnorePointer;

  Timer? timerStarter;
  Timer? timerLoop;
  Timer? timerInteraction;
  Timer? timerWidowResize;

  /// Measured cross-axis size for intrinsicCrossAxisSize feature
  double? _measuredCrossAxisSize;

  /// Tracks if autoStart has been scheduled
  bool _autoStartScheduled = false;

  /// True when the step about to run ends on an item boundary.
  bool _pauseOnArrival = false;

  /// True when the step about to run ends at 0 or the far end.
  bool _pauseOnEdge = false;

  /// Proxy delegate to maintain stability while allowing dynamic updates
  _MarqueerProxyDelegate get _proxyDelegate => _MarqueerProxyDelegate(this);

  /// Recalculates intrinsic size by resetting measurement
  /// Called by controller.recalculateIntrinsicSize()
  void _recalculateIntrinsicSize() {
    if (!widget.intrinsicCrossAxisSize) return;

    _measuredCrossAxisSize = null;
    setState(() {});
  }

  /// Calculates and executes the next animation step
  /// Returns animation duration or null if not possible
  Duration? run() {
    if (!scrollController.hasClients) {
      return null;
    }

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
        scrollController
            .animateTo(
              position,
              duration: duration,
              curve: Curves.linear,
            )
            .catchError((Object e) {
              if (kDebugMode) {
                debugPrint('Marqueer animation error (async): $e');
              }
            }),
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        debugPrint('Marqueer animation error: $e');
      }
    }

    _disableScrollableIgnorePointer();

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
    if (!mounted) {
      return;
    }

    final duration = run();

    if (duration == null) {
      return;
    }

    const gap = Duration(milliseconds: 50);
    final edge = _pauseOnEdge ? widget.edgeDuration : Duration.zero;
    final pause = _pauseOnArrival ? widget.pauseDuration : Duration.zero;

    timerLoop?.cancel();
    timerLoop = Timer(
      duration + gap + edge + pause,
      createLoop,
    );
  }

  /// Stops the marquee animation and cancels all timers
  void stop() {
    if (!mounted) {
      return;
    }

    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.offset);
    }

    _cancelAllTimers();

    widget.onStopped?.call();
  }

  /// Calculates the next scroll position.
  ///
  /// Returns null when there is no valid position. A non-zero
  /// [Marqueer.pauseDuration] stops the step on the next item.
  double? getNextPosition() {
    final ScrollController(:offset, :position) = scrollController;
    final maxScrollExtent = position.maxScrollExtent;

    if (maxScrollExtent == 0) {
      _pauseOnArrival = false;
      _pauseOnEdge = false;
      return null;
    }

    if (offset == 0) {
      if (!widget.infinity && _kDefaultStep >= maxScrollExtent) {
        return _markEdge(offset, _limitToItemBoundary(offset, maxScrollExtent));
      }

      return _markEdge(offset, _limitToItemBoundary(offset, _kDefaultStep));
    } else if (offset >= maxScrollExtent) {
      _pauseOnArrival = false;

      if (!widget.infinity && _kDefaultStep >= maxScrollExtent) {
        return _markEdge(offset, 0);
      }

      return _markEdge(offset, _kDefaultStep);
    }

    switch (scrollDirection) {
      case .idle:
        return _markEdge(offset, _limitToItemBoundary(offset, _kDefaultStep));

      case .forward:
        final next = offset - _kDefaultStep;

        if (next <= 0) {
          return _markEdge(offset, _limitToItemBoundary(offset, 0));
        }

        return _markEdge(offset, _limitToItemBoundary(offset, next));

      case .reverse:
        final next = offset + _kDefaultStep;

        if (next >= maxScrollExtent) {
          return _markEdge(
            offset,
            _limitToItemBoundary(offset, maxScrollExtent),
          );
        }

        return _markEdge(offset, _limitToItemBoundary(offset, next));
    }
  }

  /// Records whether [target] is the start or the far end of a finite marquee.
  double _markEdge(double offset, double target) {
    final maxScrollExtent = scrollController.position.maxScrollExtent;

    _pauseOnEdge =
        !widget.infinity &&
        target != offset &&
        (target <= 0 || target >= maxScrollExtent);

    return target;
  }

  /// Stops [target] on the next item when [Marqueer.pauseDuration] is set.
  ///
  /// Item pitch comes from the sliver child already laid out (child plus
  /// separator). The 10000px step stays in place when the pause is disabled.
  double _limitToItemBoundary(double offset, double target) {
    if (widget.pauseDuration == Duration.zero) {
      _pauseOnArrival = false;
      return target;
    }

    final increasing = target > offset;
    final boundary = _nextItemBoundary(offset, increasing: increasing);

    if (boundary == null) {
      _pauseOnArrival = false;
      return target;
    }

    final hitsBoundary = increasing
        ? boundary > offset && boundary <= target
        : boundary < offset && boundary >= target;

    if (!hitsBoundary) {
      _pauseOnArrival = false;
      return target;
    }

    _pauseOnArrival = true;
    return boundary;
  }

  /// Nearest item edge in front of [offset], in scroll coordinates.
  double? _nextItemBoundary(double offset, {required bool increasing}) {
    final sliver = _findItemSliver();

    if (sliver == null) {
      return null;
    }

    final origin = sliver.constraints.precedingScrollExtent;
    const epsilon = 0.5;
    double? nearest;

    sliver.visitChildren((child) {
      if (child is! RenderBox || !child.hasSize) {
        return;
      }

      final layout = sliver.childScrollOffset(child);

      if (layout == null) {
        return;
      }

      final extent = switch (sliver.constraints.axis) {
        Axis.horizontal => child.size.width,
        Axis.vertical => child.size.height,
      };

      if (extent <= 0) {
        return;
      }

      final start = origin + layout;
      final end = start + extent;

      final candidate = increasing
          ? (offset + epsilon < start
                ? start
                : (offset + epsilon < end ? end : null))
          : (offset - epsilon > end
                ? end
                : (offset - epsilon > start ? start : null));

      if (candidate == null) {
        return;
      }

      if (nearest == null ||
          (increasing ? candidate < nearest! : candidate > nearest!)) {
        nearest = candidate;
      }
    });

    return nearest;
  }

  /// The list sliver that hosts marquee items.
  RenderSliverMultiBoxAdaptor? _findItemSliver() {
    if (!scrollController.hasClients) {
      return null;
    }

    final root = scrollController.position.context.storageContext
        .findRenderObject();

    if (root == null) {
      return null;
    }

    RenderSliverMultiBoxAdaptor? found;

    void visit(RenderObject node) {
      if (found != null) {
        return;
      }

      if (node is RenderSliverMultiBoxAdaptor) {
        found = node;
        return;
      }

      node.visitChildren(visit);
    }

    visit(root);
    return found;
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

  /// Forces Flutter's [Scrollable]-internal [RenderIgnorePointer] to keep
  /// `ignoring=false` so that child gesture detectors stay tappable while the
  /// marquee is animating.
  ///
  /// Background: every time the marquee calls [ScrollController.animateTo],
  /// Flutter installs a new [ScrollActivity] (e.g. `DrivenScrollActivity`)
  /// whose `shouldIgnorePointer` is `true`. As of recent Flutter versions,
  /// [ScrollPosition.beginActivity] reaches the render object directly via
  /// `context.setIgnorePointer(true)`, bypassing any one-shot override. We
  /// therefore have to re-apply the override on every new activity. The
  /// reference is cached so this stays O(1) after the first hit.
  void _disableScrollableIgnorePointer() {
    if (!widget.scrollablePointerIgnoring || !mounted) {
      return;
    }

    final cached = _cachedIgnorePointer;
    if (cached != null && cached.attached) {
      if (cached.ignoring) {
        cached.ignoring = false;
      }
      return;
    }

    _cachedIgnorePointer = _findIgnorePointer(context.findRenderObject());
    _cachedIgnorePointer?.ignoring = false;
  }

  /// Depth-first search for the first [RenderIgnorePointer] beneath
  /// [root]. The one we want belongs to the enclosing [Scrollable] and is the
  /// closest descendant – returning early keeps this cheap.
  RenderIgnorePointer? _findIgnorePointer(RenderObject? root) {
    if (root == null) {
      return null;
    }

    RenderIgnorePointer? result;

    void visit(RenderObject node) {
      if (result != null) {
        return;
      }
      node.visitChildren((child) {
        if (result != null) {
          return;
        }
        if (child is RenderIgnorePointer) {
          result = child;
        } else {
          visit(child);
        }
      });
    }

    visit(root);
    return result;
  }

  VoidCallback? _isScrollingNotifierListener;
  bool _listenerAttached = false;

  /// Listens to scroll events and updates animation state
  void scrollListener() {
    if (!scrollController.hasClients) {
      return;
    }

    final ScrollPosition(
      :userScrollDirection,
      :isScrollingNotifier,
    ) = scrollController.position;

    if (!_listenerAttached) {
      _isScrollingNotifierListener = () {
        final isScrolling = isScrollingNotifier.value;

        if (animating == isScrolling) {
          return;
        }

        animating = isScrolling;

        // ScrollPosition.beginActivity calls `context.setIgnorePointer(true)`
        // synchronously *before* flipping `isScrollingNotifier`. So whenever
        // a new scroll activity starts we override Flutter's IgnorePointer
        // here, ensuring child gestures keep working through every loop.
        if (isScrolling) {
          _disableScrollableIgnorePointer();
        }
      };

      isScrollingNotifier.addListener(_isScrollingNotifierListener!);
      _listenerAttached = true;
    }

    if (widget.interactionsChangesAnimationDirection) {
      if (scrollDirection == userScrollDirection ||
          userScrollDirection == .idle) {
        return;
      }

      scrollDirection = userScrollDirection;
    }
  }

  /// Animates to the specified position
  /// Stops current animation, animates to position, then restarts
  ///
  /// [position] - Target scroll position
  /// [duration] - Animation duration (default: 100ms)
  /// [curve] - Animation curve (default: linear)
  Future<void> animateTo(
    double position, {
    Duration duration = const Duration(milliseconds: 100),
    Curve curve = Curves.linear,
  }) async {
    stop();

    await scrollController.animateTo(
      position,
      duration: duration,
      curve: curve,
    );

    start();
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

    if (!mounted) {
      return;
    }

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

      // Only schedule autoStart here if not using intrinsicCrossAxisSize
      if (widget.autoStart && !widget.intrinsicCrossAxisSize) {
        _autoStartScheduled = true;
        timerStarter = Timer(widget.autoStartAfter, start);
      }

      scrollController.addListener(scrollListener);
    });
  }

  @override
  void didUpdateWidget(covariant Marqueer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reset measured size if intrinsicCrossAxisSize setting or delegate changed
    if (widget.intrinsicCrossAxisSize != oldWidget.intrinsicCrossAxisSize ||
        widget.delegate != oldWidget.delegate) {
      _measuredCrossAxisSize = null;
      _autoStartScheduled = false;
    }

    // Sync `interaction` field with widget property. Parent can flip
    // `widget.interaction` at runtime; without this, the internal field stays
    // stuck at its initial value.
    if (widget.interaction != oldWidget.interaction) {
      interaction = widget.interaction;
    }

    // Direction affects scroll axis & reverse. Underlying ScrollPosition keeps
    // the old offset, which is meaningless on the new axis. Reset to 0 and
    // restart the loop so the marquee behaves correctly after a direction
    // change.
    final directionChanged = widget.direction != oldWidget.direction;
    if (directionChanged) {
      // Invalidate cached RenderIgnorePointer — the underlying Scrollable will
      // be re-created when axis flips.
      _cachedIgnorePointer = null;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final wasAnimating = animating;
        stop();
        if (scrollController.hasClients) {
          scrollController.jumpTo(0);
        }
        if (wasAnimating) start();
      });
    }

    // Restart animation when speed or the item pause changes.
    if (!directionChanged &&
        animating &&
        (widget.pps != oldWidget.pps ||
            widget.pauseDuration != oldWidget.pauseDuration)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && animating) {
          stop();
          start();
        }
      });
    }
  }

  @override
  void dispose() {
    if (_isScrollingNotifierListener != null) {
      if (scrollController.hasClients) {
        scrollController.position.isScrollingNotifier.removeListener(
          _isScrollingNotifierListener!,
        );
      }
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

    // Measure child if intrinsicCrossAxisSize is enabled
    if (widget.intrinsicCrossAxisSize && _measuredCrossAxisSize == null) {
      final child = widget.measureChild;

      if (child == null) {
        throw FlutterError(
          'intrinsicCrossAxisSize requires measureChild. '
          'Use Marqueer() constructor instead of Marqueer.builder() '
          'or provide a fixed size.',
        );
      }

      return MeasureSize(
        onChange: (size) {
          final crossAxisSize = isVertical ? size.width : size.height;
          if (_measuredCrossAxisSize != crossAxisSize) {
            setState(() => _measuredCrossAxisSize = crossAxisSize);
          }
        },
        child: Opacity(opacity: 0, child: child),
      );
    }

    final physics = interaction
        ? const BouncingScrollPhysics()
        : const NeverScrollableScrollPhysics();

    // Build marquee with the proxy delegate
    Widget marquee = Listener(
      behavior: widget.hitTestBehavior,
      onPointerDown: onPointerDownHandler,
      onPointerUp: onPointerUpHandler,
      child: _MarqueerScrollView(
        _proxyDelegate,
        clipBehavior: widget.clipBehavior,
        physics: physics,
        reverse: isReverse,
        padding: widget.padding,
        controller: scrollController,
        scrollDirection: isVertical ? .vertical : .horizontal,
        semanticChildCount: _proxyDelegate.estimatedChildCount,
        hitTestBehavior: widget.hitTestBehavior,
      ),
    );

    // Apply measured size and keep MeasureSize active if needed
    if (widget.intrinsicCrossAxisSize) {
      final measureWidget = Offstage(
        child: MeasureSize(
          onChange: (size) {
            final crossAxisSize = isVertical ? size.width : size.height;
            if (_measuredCrossAxisSize != crossAxisSize) {
              setState(() => _measuredCrossAxisSize = crossAxisSize);
            }
          },
          child: widget.measureChild ?? const SizedBox(),
        ),
      );

      if (_measuredCrossAxisSize == null) {
        return measureWidget;
      }

      marquee = Stack(
        clipBehavior: .none,
        children: [
          measureWidget,
          SizedBox(
            height: isVertical ? null : _measuredCrossAxisSize,
            width: isVertical ? _measuredCrossAxisSize : null,
            child: marquee,
          ),
        ],
      );

      // Schedule autoStart after first measurement is complete
      if (widget.autoStart && !_autoStartScheduled) {
        _autoStartScheduled = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            timerStarter = Timer(widget.autoStartAfter, start);
          }
        });
      }
    }

    return marquee;
  }
}

/// A delegate that proxies calls to the current widget's delegate.
/// This maintains a stable identity for SliverList while allowing
/// the actual content to update dynamically when the widget rebuilds.
class _MarqueerProxyDelegate extends SliverChildDelegate {
  const _MarqueerProxyDelegate(this.state);
  final _MarqueerState state;

  @override
  Widget? build(BuildContext context, int index) {
    return state.widget.delegate.build(context, index);
  }

  @override
  bool shouldRebuild(covariant _MarqueerProxyDelegate oldDelegate) {
    // Always return true to ensure that when the parent Marqueer rebuilds,
    // the children are also rebuilt with latest properties (e.g. colors).
    return true;
  }

  @override
  int? get estimatedChildCount => state.widget.delegate.estimatedChildCount;
}
