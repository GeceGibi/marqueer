

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