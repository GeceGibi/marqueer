### **Introducing Marqueer**

The **Marqueer** package is a versatile Flutter widget designed to create smooth and customizable marquee effects. Whether you're building a news ticker, scrolling advertisements, or any animated content display, Marqueer offers flexibility, performance, and user interaction controls.

With support for infinite scrolling, dynamic item generation, and highly customizable animation behavior, Marqueer ensures an engaging and fluid user experience.

<img src="https://raw.githubusercontent.com/GeceGibi/marqueer/main/preview.gif" alt="preview">

---

### **Package Features**

- **Directional Scrolling**: Scroll content in any direction—right-to-left, left-to-right, top-to-bottom, or bottom-to-top.
- **Infinite or Finite Scrolling**: Display unlimited content or stop after a specific item count.
- **Customizable Speed**: Control scroll speed with a `pps` (pixels per second) parameter.
- **Interactive Control**: Pause and resume scrolling based on user interactions.
- **Dynamic Content**: Use the `builder` constructor for generating items dynamically.
- **Responsive**: Automatically adapts to screen size changes and other layout updates.

---

### **Updated Infinity Behavior**

- **infinity**: When `true`, the widget creates an endless loop by either:
  1. Duplicating the content after the original list ends and continuing seamlessly.
  2. Reversing the animation direction when the list ends.

By adjusting the **infinity** parameter, you can control how the marquee behaves at its boundaries, ensuring a smooth experience regardless of content length.

---

### **Constructor Parameters**

#### **Core Parameters**

- `direction`: Defines the scroll direction. Options include:
  - `rtl` (Right-to-Left)
  - `ltr` (Left-to-Right)
  - `ttb` (Top-to-Bottom)
  - `btt` (Bottom-to-Top)

- `pps`: Pixels per second, controlling the speed of the scroll animation. For instance, `pps: 15.0` means 15 pixels are scrolled every second.

- `infinity`: A `bool` determining how the scroll behaves after reaching the end of the list. When enabled, it either duplicates the content or reverses the animation.

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
- `onChangeItemInViewPort`: Invoked when a new item enters the viewport.

#### **Advanced Control**

- `controller`: An optional `MarqueerController` to programmatically control the marquee (e.g., start, stop, or change direction).
- `edgeDuration`: Adds a delay when the marquee reaches the edges, useful in finite scrolling scenarios.

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
/// controller.interactionEnabled(false)

SizedBox(
  height: 30,
  child: Marqueer(
    pps: 100,
    /// optional
    controller: controller,
    /// optional
    direction: MarqueerDirection.rtl,
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
          padding: EdgeInsets.all(4),
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