The **Marqueer** package is a versatile Flutter widget designed to create smooth and customizable marquee effects. Whether you're building a news ticker, scrolling advertisements, or any animated content display, Marqueer offers flexibility, performance, and user interaction controls.

With support for infinite scrolling, dynamic item generation, and highly customizable animation behavior, Marqueer ensures an engaging and fluid user experience.

<img src="https://raw.githubusercontent.com/GeceGibi/marqueer/main/preview.gif" alt="preview">

---

### **Package Features**

- **Directional Scrolling**: Scroll content in any direction—right-to-left, left-to-right, top-to-bottom, or bottom-to-top.
- **Infinite or Finite Scrolling**: Display unlimited content or stop after a specific item count.
- **Customizable Speed**: Control scroll speed with a `pps` (pixels per second) parameter.
- **Item Pause**: `pauseDuration` holds the marquee each time an item lines up with the start of the scroll, then continues. Use it for a long title that should rest for a moment on every loop.
- **Finite Edge Rest**: `edgeDuration` rests a finite marquee at the start and at the far end. Infinite marquees ignore it.
- **Interactive Control**: Pause and resume scrolling based on user interactions.
- **Dynamic Content**: Use the `builder` constructor for generating items dynamically.
- **Responsive**: Automatically adapts to screen size changes and other layout updates.
- **Stable Animation**: The loop keeps running when the parent rebuilds with `setState`. It restarts when `pps`, `direction`, or `pauseDuration` changes.

---

### **Infinity**

- `infinity: true` repeats the child with no end.
- `infinity: false` lays the content out once, scrolls to the far end, then returns to the start. `edgeDuration` waits at those two ends.
- `Marqueer.builder` follows `itemCount`. `null` repeats forever. A number is finite.

---

### **Constructor Parameters**

#### **Core Parameters**

- `direction`: Defines the scroll direction. Options include:
  - `rtl` (Right-to-Left)
  - `ltr` (Left-to-Right)
  - `ttb` (Top-to-Bottom)
  - `btt` (Bottom-to-Top)

- `pps`: Pixels per second, controlling the speed of the scroll animation. For instance, `pps: 15.0` means 15 pixels are scrolled every second.

- `infinity`: When `true` (the default), the child is repeated without an end. When `false`, the content is laid out once, scrolled to the far end, then brought back to the start. `Marqueer.builder` uses `itemCount` for this: `null` repeats forever, a number is finite.

- `autoStart`: A `bool` controlling whether the marquee starts automatically when the widget is built.

#### **Interactivity**

- `interaction`: If `true`, pauses the animation on user touch.
- `restartAfterInteraction`: Automatically restarts scrolling after user interaction if enabled.
- `restartAfterInteractionDuration`: Specifies the delay before restarting, e.g., `Duration(seconds: 3)`.

#### **Content Customization**

- `separatorBuilder`: Adds a separator widget between items in the marquee.
- `padding`: Adds padding around the scrolling content.

#### **Callbacks**

- `onStarted`: Triggered when the animation starts.
- `onStopped`: Triggered when the animation stops.
- `onInteraction`: Called when a user interacts with the marquee.
- `onChangeItemInViewPort`: Called with the child index while that child is built. This is not a viewport-enter event.

#### **Advanced Control**

- `controller`: An optional `MarqueerController` to programmatically control the marquee (e.g., start, stop, change direction, or animate to position).
- `edgeDuration`: How long a finite marquee rests after it arrives at the start or the far end. It is ignored while `infinity` is true. `Duration.zero` does not wait.
- `pauseDuration`: How long to rest each time an item's leading edge lines up with the side the marquee is moving toward. `Duration.zero` never holds. A long title uses about `Duration(seconds: 1)`: the text scrolls, rests when the next copy is back at the start, then continues. Use `separatorBuilder` for the gap between copies.
- `clipBehavior`: Controls how the content is clipped. Default is `Clip.hardEdge`.
- `intrinsicCrossAxisSize`: Auto-sizes the cross axis based on child widget. No need for `SizedBox` wrapper. Default is `false`.

#### **Controller Methods**

- `start()`: Starts the marquee animation
- `stop()`: Stops the marquee animation
- `forward()`: Runs the loop toward the increasing scroll offset. On the default right-to-left marquee, content moves left.
- `backward()`: Runs the loop toward the decreasing scroll offset. On the default right-to-left marquee, content moves right.
- `animateTo(position, duration, curve)`: Animates to a specific scroll position
- `interactionEnabled(enabled)`: Enables or disables user interaction
- `recalculateIntrinsicSize()`: Recalculates intrinsic size when child content changes
- `isAnimating`: Returns the animation status (requires single attached widget)

### **scrollablePointerIgnoring**

The `scrollablePointerIgnoring` parameter is a boolean that resolves gesture-related issues caused by Flutter's default `IgnorePointer` behavior within `Scrollable` widgets. When set to `true`, it ensures that the `IgnorePointer` behavior in nested scrollable elements is bypassed, allowing gestures to propagate correctly.

#### **Why Use This?**
Flutter's `Scrollable` widget applies an `IgnorePointer` by default to prevent unintended interactions during animations. However, this can interfere with custom gestures or user interactions in certain scenarios. Enabling `scrollablePointerIgnoring` ensures smooth and predictable gesture handling.

#### **Default Behavior**
- **`false`**: The default `IgnorePointer` behavior remains active.
- **`true`**: Disables the default `IgnorePointer` behavior, allowing gestures to work as expected.

---

```dart
final controller = MarqueerController();

/// controller.start()
/// controller.stop()
/// controller.forward()
/// controller.backward()
/// controller.animateTo(position, duration: duration, curve: curve)
/// controller.interactionEnabled(false)

SizedBox(
  height: 30,
  child: Marqueer(
    pps: 100,
    /// optional
    controller: controller,
    /// optional
    direction: .rtl,
    /// optional
    restartAfterInteractionDuration: const Duration(seconds: 6),
    /// optional
    restartAfterInteraction: false,
    /// optional
    onChangeItemInViewPort: (index) {
      print('item index: $index');
    },
    onInteraction: () {
      print('on interaction callback');
    },
    onStarted: () {
      print('on started callback');
    },
    onStopped: () {
      print('on stopped callback');
    },
    child: const Text(
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer pretium massa mollis lorem blandit imperdiet. Nulla mattis vitae mauris vel condimentum. Nam posuere, augue vitae lobortis consequat, odio ante condimentum est, at maximus augue purus id metus. Curabitur condimentum aliquet ante at aliquet. Quisque vel massa congue, bibendum leo sodales, malesuada ante. Maecenas sed tortor quis ipsum dictum sollicitudin.',
    ),
  ),
);
```

Usage with builder

```dart
SizedBox(
  height: 50,
  child: Marqueer.builder(
    itemCount: 200,
    interaction: false,
    scrollablePointerIgnoring: true,
    itemBuilder: (context, index) {
      return GestureDetector(
        onTap: () => print('tapped $index'),
        child: Padding(
          padding: .all(4),
          child: Text('index: $index'),
        ),
      );
    },
  ),
);
```


Basic usage

```dart
SizedBox(
  height: 50,
  child: Marqueer(
    child: AnyWidget(),
  ),
);
```

Auto-size (no SizedBox needed)

```dart
Marqueer(
  intrinsicCrossAxisSize: true,
  child: Text('Auto-sized marquee text'),
)
```

Long title that rests on every loop

```dart
SizedBox(
  height: 48,
  child: Marqueer(
    pps: 40,
    pauseDuration: const Duration(seconds: 1),
    separatorBuilder: (_, _) => const SizedBox(width: 48),
    child: const Text('Long song title pauses when it comes back'),
  ),
)
```

Finite marquee that rests at both ends

```dart
SizedBox(
  height: 48,
  child: Marqueer(
    infinity: false,
    edgeDuration: const Duration(seconds: 1),
    child: const Text('Scrolls to the end, rests, then returns to the start'),
  ),
)
```