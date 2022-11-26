<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

Transform to "Marquee" from any widget.


<img src="https://raw.githubusercontent.com/GeceGibi/marqueer/main/preview.gif" alt="preview">


## Marquee
| Argument                        | Type                     | Description      | Required | Default               |
| ------------------------------- |------------------------  | ---------------- | -------- | --------------------- |
| child                           | Widget                   |                  | YES      | -                     |
| pps                             | double                   | Pixel Per Second | NO       | 15.0                  |
| direction                       | enum                     |                  | NO       | MarqueerDirection.rtl |
| separator                       | Widget                   |                  | NO       | null                  |
| infinity                        | bool                     |                  | NO       | true                  |    
| interaction                     | bool                     |                  | NO       | true                  |
| autoStart                       | bool                     |                  | NO       | true                  |
| autoStartAfter                  | Duration                 |                  | NO       | Duration.zero         |
| restartAfterInteraction         | bool                     |                  | NO       | true                  | 
| restartAfterInteractionDuration | Duration                 |                  | NO       | Duration(seconds: 3)  |
| controller                      | MarqueerController       |                  | NO       | null                  |
| onChangeItemInViewPort          | void Function(index int) | callback         | NO       | null                  |
| onInteraction                   | void Function()          | callback         | NO       | null                  |
| onStarted                       | void Function()          | callback         | NO       | null                  |
| onStoped                        | void Function()          | callback         | NO       | null                  |


```dart
final controller = MarqueerController();

/// controller.start()
/// controller.stop()
/// controller.interactionEnabled(false)

SizedBox(
    height: 30,
    child: Marqueer(
        pps: 100, /// optional
        controller: controller, /// optional
        direction: MarqueerDirection.rtl,  /// optional
        restartAfterInteractionDuration: const Duration(seconds: 6), /// optional
        restartAfterInteraction: false, /// optional
        onChangeItemInViewPort: (index) {
            print('item index: $index');
        },
        onInteraction: () {
            print('on interaction callback');
        },
        onStarted: () {
            print('on started callback');
        },
        onStoped: () {
            print('on stopped callback');
        },
        child: const Text(
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer pretium massa mollis lorem blandit imperdiet. Nulla mattis vitae mauris vel condimentum. Nam posuere, augue vitae lobortis consequat, odio ante condimentum est, at maximus augue purus id metus. Curabitur condimentum aliquet ante at aliquet. Quisque vel massa congue, bibendum leo sodales, malesuada ante. Maecenas sed tortor quis ipsum dictum sollicitudin.',
        ),
    ),
);
```

Basic usage

```dart
SizedBox(
    height: 50,
    child:Marqueer(
        child: AnyWidget()
    )
)
```