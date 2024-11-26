<h2>Transform to "Marquee" from any widget.</h2>


<img src="https://raw.githubusercontent.com/GeceGibi/marqueer/main/preview.gif" alt="preview">


## Marquee
| Argument                              | Type                                              | Required | Default                     |
| ------------------------------------- | ------------------------------------------------- | -------- | --------------------------- |
| child                                 | Widget                                            | YES      | -                           |
| pps                                   | double                                            | NO       | 15.0                        |
| direction                             | enum                                              | NO       | MarqueerDirection.rtl       |
| padding                               | EdgeInsets                                        | NO       | EdgeInsets.zero             |
| separatorBuilder                      | Widget Function(BuildContext context, int index)  | NO       | null                        |
| infinity                              | bool                                              | NO       | true                        |    
| interaction                           | bool                                              | NO       | true                        |
| autoStart                             | bool                                              | NO       | true                        |
| autoStartAfter                        | Duration                                          | NO       | Duration.zero               |
| restartAfterInteraction               | bool                                              | NO       | true                        | 
| restartAfterInteractionDuration       | Duration                                          | NO       | Duration(seconds: 3)        |
| controller                            | MarqueerController                                | NO       | null                        |
| onChangeItemInViewPort                | void Function(index int)                          | NO       | null                        |
| onInteraction                         | void Function()                                   | NO       | null                        |
| onStarted                             | void Function()                                   | NO       | null                        |
| onStopped                             | void Function()                                   | NO       | null                        |
| itemBuilder                           | Widget Function(BuildContext context, int index)  | YES      | null                        |
| itemCount                             | int                                               | NO       | null                        |
| scrollablePointerIgnoring             | bool                                              | NO       | false                       |
| hitTestBehavior                       | HitTestBehavior                                   | NO       | HitTestBehavior.translucent | 
| edgeDuration                          | Duration                                          | NO       | Duration.zero               | 
| interactionsChangesAnimationDirection | bool                                              | NO       | true                        |
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