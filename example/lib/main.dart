import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marquee Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AppHome(),
    );
  }
}

class AppHome extends StatefulWidget {
  const AppHome({Key? key}) : super(key: key);
  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  final controller = MarqueeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          SizedBox(
            height: 30,
            child: Marquee(
              pps: 100,
              controller: controller,
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
          ),
          SizedBox(
            height: 30,
            child: Marquee(
              interaction: false,
              controller: controller,
              direction: MarqueeDirection.rtl,
              child: const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer pretium massa mollis lorem blandit imperdiet. Nulla mattis vitae mauris vel condimentum. Nam posuere, augue vitae lobortis consequat, odio ante condimentum est, at maximus augue purus id metus. Curabitur condimentum aliquet ante at aliquet. Quisque vel massa congue, bibendum leo sodales, malesuada ante. Maecenas sed tortor quis ipsum dictum sollicitudin.',
              ),
            ),
          ),
          SizedBox(
            height: 160,
            child: Marquee(
              pps: 60,
              controller: controller,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.network(
                      'https://picsum.photos/id/$index/100/160',
                      width: 100,
                    ),
                  );
                },
              ),
            ),
          ),
          Row(
            children: [
              TextButton(
                onPressed: controller.stop,
                child: const Text('Stop'),
              ),
              TextButton(
                onPressed: controller.start,
                child: const Text('Start'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
