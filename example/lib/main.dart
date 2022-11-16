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
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
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
                print(index);
              },
              onInteraction: () {
                print('interaction callback');
              },
              onStarted: () {
                print('marquee started');
              },
              onStoped: () {
                print('marquee stoped');
              },
              child: Text(
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
              child: Text(
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
                child: Text("Stop"),
              ),
              TextButton(
                onPressed: controller.start,
                child: Text("Start"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
