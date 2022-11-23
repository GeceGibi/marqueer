library marqueer;

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

part 'controller.dart';

enum MarqueerDirection {
  rtl,
  ltr,
}

class Marqueer extends StatefulWidget {
  const Marqueer({
    required this.child,
    this.pps = 15.0,
    this.infinity = true,
    this.autoStart = true,
    this.direction = MarqueerDirection.rtl,
    this.interaction = true,
    this.restartAfterInteractionDuration = const Duration(seconds: 3),
    this.restartAfterInteraction = true,
    this.onChangeItemInViewPort,
    this.separator,
    this.controller,
    this.onInteraction,
    this.onStarted,
    this.onStoped,
    super.key,
  });

  /// Child
  final Widget child;

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

  /// Seperator widget
  final Widget? separator;

  ///
  final bool infinity;

  /// callbacks
  final void Function()? onStarted;
  final void Function()? onStoped;
  final void Function()? onInteraction;
  final void Function(int index)? onChangeItemInViewPort;

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
    if (animating) {
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
    if (!animating) {
      return;
    }

    animating = false;

    timerLoop?.cancel();
    timerInteraction?.cancel();

    controller.jumpTo(controller.offset);
    offset = controller.offset;

    widget.onStoped?.call();
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
    if (maxPos > 0) {
      switch (interactionDirection) {
        case ScrollDirection.idle:

          /// just pick random direction and move on
          interactionDirection = random.nextBool()
              ? ScrollDirection.forward
              : ScrollDirection.reverse;
          calculateDistance();
          break;

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

      return true;
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

    /// Clear prev timer if setted
    timerInteraction?.cancel();
    timerLoop?.cancel();
  }

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.autoStart) {
        start();
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

  @override
  void dispose() {
    controller.dispose();
    timerLoop?.cancel();
    timerInteraction?.cancel();
    widget.controller?._deattach(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final physics = interaction
        ? const BouncingScrollPhysics()
        : const NeverScrollableScrollPhysics();

    final isReverse = widget.direction == MarqueerDirection.ltr;

    return IgnorePointer(
      ignoring: !interaction,
      child: Listener(
        onPointerDown: onPointerDownHandler,
        onPointerUp: onPointerUpHandler,
        child: ListView.builder(
          controller: controller,
          padding: EdgeInsets.zero,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          addAutomaticKeepAlives: false,
          scrollDirection: Axis.horizontal,
          physics: physics,
          reverse: isReverse,
          itemCount: widget.infinity ? null : 1,
          itemBuilder: (context, index) {
            widget.onChangeItemInViewPort?.call(index);

            if (widget.separator != null && widget.infinity) {
              final children = [widget.child];

              children.insert(isReverse ? 0 : 1, widget.separator!);

              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              );
            }

            return widget.child;
          },
        ),
      ),
    );
  }
}
