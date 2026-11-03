import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marqueer/marqueer.dart';

void main() {
  testWidgets('holds when the next item reaches the start', (tester) async {
    final controller = MarqueerController();

    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 120,
          height: 40,
          child: Marqueer(
            controller: controller,
            pps: 1000,
            pauseDuration: const Duration(seconds: 1),
            child: const SizedBox(width: 300, height: 20),
          ),
        ),
      ),
    );

    await tester.pump();

    var elapsed = 0;
    while (controller.offset < 299 && elapsed < 2000) {
      await tester.pump(const Duration(milliseconds: 50));
      elapsed += 50;
    }

    expect(controller.offset, closeTo(300, 1));

    await tester.pump(const Duration(milliseconds: 700));
    expect(controller.offset, closeTo(300, 1));

    // The hold ends on a timer inside one pump. The next pump is the resume.
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 100));
    expect(controller.offset, greaterThan(350));
  });

  testWidgets('zero pause keeps scrolling through the item edge', (
    tester,
  ) async {
    final controller = MarqueerController();

    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 120,
          height: 40,
          child: Marqueer(
            controller: controller,
            pps: 1000,
            child: const SizedBox(width: 300, height: 20),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 16));
    await tester.pump(const Duration(milliseconds: 450));

    expect(controller.offset, greaterThan(400));
  });

  testWidgets('edgeDuration waits only at the ends of a finite marquee', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 120,
            height: 40,
            child: Marqueer(
              infinity: false,
              pps: 10000,
              edgeDuration: const Duration(seconds: 5),
              child: const SizedBox(width: 15120, height: 20),
            ),
          ),
        ),
      ),
    );

    final position = tester
        .state<ScrollableState>(find.byType(Scrollable))
        .position;

    await tester.pump();

    var elapsed = 0;
    while (position.pixels < 9990 && elapsed < 3000) {
      await tester.pump(const Duration(milliseconds: 50));
      elapsed += 50;
    }

    expect(position.pixels, closeTo(10000, 5));

    await tester.pump(const Duration(milliseconds: 200));
    expect(position.pixels, greaterThan(10500));

    while (position.pixels < position.maxScrollExtent - 10 && elapsed < 8000) {
      await tester.pump(const Duration(milliseconds: 50));
      elapsed += 50;
    }

    expect(position.pixels, closeTo(position.maxScrollExtent, 5));

    await tester.pump(const Duration(milliseconds: 700));
    expect(position.pixels, closeTo(position.maxScrollExtent, 5));
  });

  testWidgets('infinity ignores edgeDuration', (tester) async {
    final controller = MarqueerController();

    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 120,
          height: 40,
          child: Marqueer(
            controller: controller,
            pps: 10000,
            edgeDuration: const Duration(seconds: 5),
            child: const SizedBox(width: 300, height: 20),
          ),
        ),
      ),
    );

    await tester.pump();

    var elapsed = 0;
    while (controller.offset < 9990 && elapsed < 3000) {
      await tester.pump(const Duration(milliseconds: 50));
      elapsed += 50;
    }

    expect(controller.offset, closeTo(10000, 5));

    await tester.pump(const Duration(milliseconds: 200));
    expect(controller.offset, greaterThan(10500));
  });
}
