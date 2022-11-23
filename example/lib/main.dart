import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:marqueer/marqueer.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          const _PostCard(),
          const SizedBox(height: 40),
          SizedBox(
            height: 150,
            child: Marqueer(
              pps: 60,
              infinity: false,
              child: Row(
                children: List<Widget>.generate(5, (index) {
                  return Image.network(
                    'https://api.lorem.space/image/game?w=300&h=300&t=$index',
                    width: 150,
                  );
                }),
              ),
            ),
          ),
          SizedBox(
            height: 150,
            child: Marqueer(
              pps: 30,
              direction: MarqueerDirection.ltr,
              child: Row(
                children: List<Widget>.generate(20, (index) {
                  return Image.network(
                    'https://api.lorem.space/image/fashion?w=300&h=300&t=$index',
                    width: 150,
                  );
                }),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _PostCard extends StatefulWidget {
  const _PostCard({super.key});
  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  final controller = MarqueerController();

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      controller.start();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LayoutBuilder(builder: (context, consts) {
          final pixelRatio = MediaQuery.of(context).devicePixelRatio;
          final size = (consts.maxWidth * pixelRatio).toInt();

          return SizedBox(
            height: consts.maxWidth,
            width: consts.maxWidth,
            child: Image.network(
              'https://api.lorem.space/image/movie?w=$size&h=$size&t',
              fit: BoxFit.cover,
            ),
          );
        }),
        Positioned(
          height: 42,
          bottom: 8,
          left: 0,
          right: 0,
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: ColoredBox(
                color: const Color(0x66000000),
                child: Marqueer(
                  autoStart: false,
                  controller: controller,
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      "Curabitur nec ex auctor risus scelerisque rhoncus ut porttitor sapien. Pellentesque vestibulum leo a nisi sollicitudin vehicula. Ut fringilla elementum iaculis. Sed risus justo, facilisis at metus sed, interdum euismod lectus. Vivamus tincidunt lorem vel mauris hendrerit, a efficitur felis porttitor. Nulla facilisi.",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
