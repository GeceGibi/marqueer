library marqueer;

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

part 'controller.dart';

enum MarqueerDirection {
  rtl,
  ltr,
}

class Marqueer extends StatefulWidget {
  Marqueer({
    required this.child,
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
    this.separator,
    super.key,
  })  : assert(child != null, 'Child can\'t be null'),
        assert((() {
          if (autoStartAfter > Duration.zero) {
            return autoStart;
          }

          return true;
        })(),
            "if `autoStartAfter` duration bigger than `zero`, `autoStart` must be `true`"),
        itemBuilder = null,
        itemCount = null;

  Marqueer.builder({
    required this.itemBuilder,
    this.itemCount,
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
    this.separator,
    super.key,
  })  : assert(itemBuilder != null, 'itemBuilder can\'t be null'),
        assert((() {
          if (autoStartAfter > Duration.zero) {
            return autoStart;
          }

          return true;
        })(),
            "if `autoStartAfter` duration bigger than `zero`, `autoStart` must be `true`"),
        child = null,
        infinity = itemCount == null;

  /// Child
  final Widget? child;

  /// Direction
  final MarqueerDirection direction;

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

  /// Separator widget
  final Widget? separator;

  /// Auto Start after duration
  final Duration autoStartAfter;

  ///
  final bool infinity;

  /// callbacks
  final void Function()? onStarted;
  final void Function()? onStopped;
  final void Function()? onInteraction;
  final void Function(int index)? onChangeItemInViewPort;

  /// Builder
  final Widget Function(BuildContext context, int index)? itemBuilder;
  final int? itemCount;

  @override
  State<Marqueer> createState() => _MarqueerState();
}

class _MarqueerState extends State<Marqueer> {
  final controller = ScrollController();

  var step = 0.0;
  var offset = 0.0;
  var animating = false;
  var interactionDirection = ScrollDirection.idle;

  late var interaction = widget.interaction;

  Timer? timerLoop;
  Timer? timerInteraction;

  /// default delay added for wait scroll anim. end;
  Duration get duration => Duration(
        milliseconds: ((step / widget.pps) * 1000).round(),
      );

  void animate() {
    controller.animateTo(
      offset + step,
      duration: duration,
      curve: Curves.linear,
    );
  }

  void start() {
    if (animating || !mounted) {
      return;
    }

    if (calculateDistance()) {
      animating = true;
      animate();
      createLoop();
      widget.onStarted?.call();
    }
  }

  /// Duration calculating after every interaction
  /// so Timer.periodic is not a good solution
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

    controller.jumpTo(controller.offset);
    offset = controller.offset;

    widget.onStopped?.call();
  }

  bool calculateDistance() {
    final currentPos = controller.offset;
    final maxPos = controller.position.maxScrollExtent;

    if (widget.infinity) {
      offset = currentPos;
      step = 10000.0;
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
          break;

        case ScrollDirection.reverse:
          final isEnd = maxPos == currentPos;
          step = isEnd ? maxPos : maxPos - currentPos;
          offset = isEnd ? -maxPos : maxPos - step;
          break;
      }

      return step.isFinite;
    }

    return false;
  }

  void interactionEnabled(bool enabled) {
    if (interaction != enabled) {
      offset = controller.offset;
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.autoStart) {
        Future.delayed(widget.autoStartAfter, start);
      }

      if (!widget.infinity) {
        controller.addListener(() {
          final direction = controller.position.userScrollDirection;

          if (interactionDirection != direction) {
            interactionDirection = direction;
          }
        });
      }
    });
  }

  bool get isWebOrDesktop => kIsWeb || (!Platform.isAndroid && !Platform.isIOS);
  bool get isReverse => widget.direction == MarqueerDirection.ltr;
  bool get hasCustomBuilder => widget.itemBuilder != null;

  Widget _defaultItemBuilder(BuildContext context, int index) {
    final actualIndex = hasCustomBuilder ? index ~/ 2 : index;

    widget.onChangeItemInViewPort?.call(actualIndex);

    if (index.isOdd && widget.separator != null) {
      return widget.separator!;
    }

    if (hasCustomBuilder) {
      return widget.itemBuilder!(context, actualIndex);
    }

    return widget.child!;
  }

  @override
  void dispose() {
    controller.dispose();
    timerLoop?.cancel();
    timerInteraction?.cancel();
    widget.controller?._detach(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final physics = interaction
        ? const BouncingScrollPhysics()
        : const NeverScrollableScrollPhysics();

    var itemCount = widget.infinity ? null : 1;

    if (hasCustomBuilder) {
      itemCount =
          widget.itemCount != null ? max(0, (widget.itemCount! * 2) - 1) : null;
    }

    Widget body = ListView.builder(
      physics: physics,
      reverse: isReverse,
      itemCount: itemCount,
      controller: controller,
      padding: EdgeInsets.zero,
      addAutomaticKeepAlives: false,
      scrollDirection: Axis.horizontal,
      itemBuilder: _defaultItemBuilder,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    );

    if (isWebOrDesktop) {
      body = MouseRegion(
        onEnter: (_) => stop(),
        onExit: (_) => start(),
        child: body,
      );
    }

    return IgnorePointer(
      ignoring: !interaction,
      child: Listener(
        onPointerDown: onPointerDownHandler,
        onPointerUp: onPointerUpHandler,
        child: body,
      ),
    );
  }
}
