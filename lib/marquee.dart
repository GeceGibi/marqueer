library marquee;

import 'dart:async';
import 'package:flutter/widgets.dart';

enum MarqueeDirection {
  rtl,
  ltr,
}

class Marquee extends StatefulWidget {
  const Marquee({
    required this.child,
    this.pps = 15.0,
    this.direction = MarqueeDirection.rtl,
    this.swipeable = true,
    this.initialOffset = 0.0,
    this.restartAfterInteractionDuration = const Duration(seconds: 3),
    this.stopWhenInteraction = false,
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

  /// Swipeable
  final bool swipeable;

  /// Restart delay
  final Duration restartAfterInteractionDuration;

  /// Stop when interaction
  final bool stopWhenInteraction;

  @override
  State<Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> {
  late final controller = ScrollController(
    initialScrollOffset: widget.initialOffset,
  );

  late var offset = controller.initialScrollOffset;
  late final step = MediaQuery.of(context).size.width * 10;

  Duration get duration => Duration(seconds: step ~/ widget.pps);

  Timer? timerLoop;
  Timer? timerTouch;

  void animate() {
    controller.animateTo(
      offset + step,
      duration: duration,
      curve: Curves.linear,
    );
  }

  void begin() {
    timerLoop?.cancel();
    timerLoop = Timer.periodic(duration, (_) {
      offset = controller.offset;
      animate();
    });

    animate();
  }

  Future<void> onPointerUpHandler(PointerUpEvent event) async {
    if (!widget.stopWhenInteraction) {
      /// Clear prev timer if setted
      timerTouch?.cancel();

      /// Wait for scroll animation end
      timerTouch = Timer(widget.restartAfterInteractionDuration, () {
        offset = controller.offset;
        begin();
      });
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      begin();
    });
  }

  @override
  void dispose() {
    timerLoop?.cancel();
    timerTouch?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final physics = widget.swipeable
        ? const BouncingScrollPhysics()
        : const NeverScrollableScrollPhysics();

    final marquee = ListView.builder(
      controller: controller,
      padding: EdgeInsets.zero,
      reverse: widget.direction == MarqueeDirection.ltr,
      addAutomaticKeepAlives: false,
      scrollDirection: Axis.horizontal,
      physics: physics,
      itemBuilder: (context, index) => widget.child,
    );

    if (widget.swipeable) {
      return Listener(
        onPointerUp: onPointerUpHandler,
        child: marquee,
      );
    }

    return marquee;
  }
}
