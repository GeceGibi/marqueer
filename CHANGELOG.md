## 2.6.0
Added `pauseDuration`. When an item's leading edge reaches the start of the scroll, the marquee holds for that duration and then continues. `Duration.zero` keeps the previous continuous scroll. A long title scrolls, rests for about a second once the next copy lines up, and repeats. \
`edgeDuration` now waits only after a finite marquee arrives at the start or the end. Infinite marquees ignore it.

## 2.5.0
Fixed `scrollablePointerIgnoring` not working after the first animation loop on recent Flutter versions \
Replaced one-shot `_searchIgnorePointer` call with a cached `RenderIgnorePointer` reference that is re-applied on every new scroll activity via `isScrollingNotifier` \
Tree traversal now runs only once thanks to caching, keeping performance unchanged \
Removed `dart:io` import; platform detection now uses `defaultTargetPlatform` so the package compiles cleanly on Flutter Web \
Added async error handling for `ScrollController.animateTo` so unhandled future errors no longer crash the zone \
`didUpdateWidget` now syncs `widget.interaction` to the internal field at runtime \
`didUpdateWidget` now resets scroll offset and restarts the loop when `direction` changes, preventing visual glitches caused by stale offsets on the new axis

## 2.4.3
Fixed children update issue by ensuring proxy delegate updates and resetting measured size on widget rebuilds \

## 2.4.2
Fixed content update issue (e.g. text color changes) by disabling delegate caching when `intrinsicCrossAxisSize` is false \

## 2.4.1
Fixed animation interruption when parent widget rebuilds via setState \
Added delegate caching to prevent unnecessary recreation on parent rebuilds \
Added `recalculateIntrinsicSize()` to controller for manual size recalculation \
Animation now only restarts when `pps`, `direction`, or `infinity` parameters change

## 2.4.0
Added `intrinsicCrossAxisSize` parameter - Auto-sizes cross axis based on child widget, no `SizedBox` wrapper needed \
Added `offset` getter to `MarqueerController` for reading current scroll position \
Added `hasClients` guards to `run()`, `stop()`, and `scrollListener()` for safer lifecycle handling \
Improved autoStart behavior with `intrinsicCrossAxisSize` - animation starts after measurement completes

## 2.3.1
Added `clipBehavior` parameter to `Marqueer` and `Marqueer.builder` constructors for customizable clipping behavior

## 2.3.0
Added `MeasureSize` widget - A helper widget using RenderProxyBox to efficiently measure child widget sizes \
Improved example with advanced dynamic height pattern using MeasureSize and Stack \
Enhanced documentation with practical use cases for dynamic sizing

## 2.2.2
Fixed memory leak in scrollListener where listeners were added multiple times \
Optimized _searchIgnorePointer performance by caching result \
Added debug logging to animation error catch block \
Removed unused viewportDimension variable \
Improved code consistency in constructor parameters

## 2.2.1
Fixed `Cannot get renderObject of inactive element` error by guarding access with `mounted` check \
Fixed `ScrollController not attached to any scroll views` error during dispose lifecycle

## 2.2.0
Simplified and improved documentation across all classes and methods \
Added `_cancelAllTimers()` helper method for cleaner timer management \
Fixed memory leak in scroll listener by properly removing listeners in dispose \
Improved code consistency and readability

## 2.1.0
Enhanced code documentation with comprehensive inline comments for all public APIs \
Improved type safety by adding explicit type annotations \
Fixed potential memory leak in `didChangeMetrics` method \
Optimized timer management in stop() method \
Enhanced platform detection logic for better cross-platform support \
Updated pubspec.yaml description for better package discoverability

## 2.0.1
Updated **Readme.md**
Fixed `didChangeMetrics` bug

## 2.0.0
Refactored and cleared code-base.

Added `edgeDuration` \
Added `interactionsChangesAnimationDirection` \
Hidden `web` and `desktop` scrollbar \
Removed `MouseRegion` from widget hierarchy

## 1.5.0
Added `hitTestBehavior` support \
Added `scrollablePointerIgnoring` for handle touch at first time, fixed [#15](https://github.com/GeceGibi/marqueer/issues/15) [#13](https://github.com/GeceGibi/marqueer/issues/13)


## 1.4.5
Switched to [very_good_analysis](https://pub.dev/packages/very_good_analysis) for lint
added minor descriptions to code base

## 1.4.4
Updated lint version to `3.*`\
Updated preview gif

## 1.4.3
Added vertical direction support. [#11](https://github.com/GeceGibi/marqueer/issues/11) <br/>
> note: don't forget child height when using marqueer on vertical.

```dart
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
```

## 1.4.2
Added mouse swipe support for web [#10](https://github.com/GeceGibi/marqueer/issues/10)

## 1.4.1
Added `forward()` and  `backward()` methods to controller.

## 1.4.0
Fixed issue [5](https://github.com/GeceGibi/marqueer/issues/5).\
Breaking change: updated `Widget? separator` argument to `Widget separatorBuilder(BuildContext, int)` method.\
Added `padding` argument. See README.md

## 1.3.1
Updated `example` screen widgets\
Cleaned up example project.

## 1.3.0
Added `Marqueer.builder` for dynamic item build. [#1](https://github.com/GeceGibi/marqueer/issues/1)

## 1.2.1
Fixed misspelled variable names. (thanks @Aboidrees)

## 1.2.0
Improved desktop and web support.

p## 1.1.1
Added `autoStartAfter` property to `Marquuer` widget for auto start after specific duration

## 1.1.0
Fixed wrong distance calculation with no-infinity widget. When `ScrollDirection.idle`.  
Added `isAnimating` getter to `MarqueerController`.  
`MarqueerController` splitted to own file.  
Updated `/example`

## 1.0.6
Fix typo

## 1.0.5
Add Preview `gif`

## 1.0.2
Updated example project  
Fixed direction bug  
Added `infinite` option  

## 1.0.1
Add `hasClients` getter to MarqueerController  
Update README.md  

## 1.0.0
initial release.