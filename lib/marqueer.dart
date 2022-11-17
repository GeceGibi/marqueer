library marquee;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum MarqueerDirection {
  rtl,
  ltr,
}

class MarqueerController {
  MarqueerController();

  final _marquees = <_MarqueerState>[];
  void _attach(_MarqueerState marquee) {
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

class Marqueer extends StatefulWidget {
  const Marqueer({
    required this.child,
    this.pps = 15.0,
    this.autoStart = true,
    this.direction = MarqueerDirection.ltr,
    this.interaction = true,
    this.initialOffset = 0.0,
    this.restartAfterInteractionDuration = const Duration(seconds: 3),
    this.restartAfterInteraction = true,
    this.onChangeItemInViewPort,
    this.seperator,
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

  /// Initial offset
  final double initialOffset;

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
  final Widget? seperator;

  /// callbacks
  final void Function()? onStarted;
  final void Function()? onStoped;
  final void Function()? onInteraction;
  final void Function(int index)? onChangeItemInViewPort;

  @override
  State<Marqueer> createState() => _MarqueerState();
}

class _MarqueerState extends State<Marqueer> {
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

    final isReverse = widget.direction == MarqueerDirection.rtl;

    return IgnorePointer(
      ignoring: !interaction,
      child: Listener(
        onPointerDown: onPointerDownHandler,
        onPointerUp: onPointerUpHandler,
        child: ListView.builder(
          controller: controller,
          padding: EdgeInsets.zero,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          reverse: isReverse,
          addAutomaticKeepAlives: false,
          scrollDirection: Axis.horizontal,
          physics: physics,
          itemBuilder: (context, index) {
            widget.onChangeItemInViewPort?.call(index);

            if (widget.seperator != null) {
              final children = [widget.child];

              children.insert(isReverse ? 0 : 1, widget.seperator!);

              return Row(
                mainAxisSize: MainAxisSize.min,
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
