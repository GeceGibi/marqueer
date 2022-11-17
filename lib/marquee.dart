library marquee;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum MarqueeDirection {
  rtl,
  ltr,
}

class MarqueeController {
  MarqueeController();

  final _marquees = <_MarqueeState>[];
  void _attach(_MarqueeState marquee) {
    _marquees.add(marquee);
  }

  void start() {
    assert(_marquees.isNotEmpty, "Not found any attached marquee widget");
    for (var marq in _marquees) {
      marq.start();
    }
  }

  void stop() {
    assert(_marquees.isNotEmpty, "Not found any attached marquee widget");
    for (var marq in _marquees) {
      marq.stop();
    }
  }

  void interactionEnabled(bool enabled) {
    assert(_marquees.isNotEmpty, "Not found any attached marquee widget");
    for (var marq in _marquees) {
      marq.interactionEnabled(enabled);
    }
  }
}

class Marquee extends StatefulWidget {
  const Marquee({
    required this.child,
    this.pps = 15.0,
    this.autoStart = true,
    this.direction = MarqueeDirection.ltr,
    this.interaction = true,
    this.initialOffset = 0.0,
    this.restartAfterInteractionDuration = const Duration(seconds: 3),
    this.restartAfterInteraction = true,
    this.onChangeItemInViewPort,
    this.controller,
    this.onInteraction,
    this.onStarted,
    this.onStoped,
    super.key,
  });

  /// Child
  final Widget child;

  /// Direction
  final MarqueeDirection direction;

  /// Pixel Per Second
  final double pps;

  /// Initial offset
  final double initialOffset;

  /// Interactions
  final bool interaction;

  /// Stop when interaction
  final bool restartAfterInteraction;

  /// Restart delay
  final Duration restartAfterInteractionDuration;

  /// Controller
  final MarqueeController? controller;

  /// auto start
  final bool autoStart;

  /// callbacks
  final void Function()? onStarted;
  final void Function()? onStoped;
  final void Function()? onInteraction;
  final void Function(int index)? onChangeItemInViewPort;

  @override
  State<Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> {
  late final controller = ScrollController(
    initialScrollOffset: widget.initialOffset,
  );

  late var offset = controller.initialScrollOffset;
  final step = 10000.0;

  Timer? timerLoop;
  Timer? timerInteraction;
  Duration get duration => Duration(seconds: step ~/ widget.pps);

  var animating = false;
  late var interaction = widget.interaction;

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

    animating = true;

    timerLoop?.cancel();
    timerLoop = Timer.periodic(duration, (_) {
      offset = controller.offset;
      animate();
    });

    animate();
    widget.onStarted?.call();
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
        offset = controller.offset;
        start();
      });
    }
  }

  void onPointerDownHandler(PointerDownEvent event) {
    animating = false;
    widget.onInteraction?.call();

    /// Clear prev timer if setted
    timerInteraction?.cancel();
  }

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);

    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        start();
      });
    }
  }

  @override
  void dispose() {
    timerLoop?.cancel();
    timerInteraction?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final physics = interaction
        ? const BouncingScrollPhysics()
        : const NeverScrollableScrollPhysics();

    return IgnorePointer(
      ignoring: !interaction,
      child: Listener(
        onPointerDown: onPointerDownHandler,
        onPointerUp: onPointerUpHandler,
        child: ListView.builder(
          controller: controller,
          padding: EdgeInsets.zero,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          reverse: widget.direction == MarqueeDirection.rtl,
          addAutomaticKeepAlives: false,
          scrollDirection: Axis.horizontal,
          physics: physics,
          itemBuilder: (context, index) {
            widget.onChangeItemInViewPort?.call(index);
            return widget.child;
          },
        ),
      ),
    );
  }
}
