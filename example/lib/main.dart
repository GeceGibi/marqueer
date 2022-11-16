import 'dart:ui';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          _PostCard(),
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
  final controller = MarqueeController();

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), controller.start);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LayoutBuilder(builder: (context, conts) {
          return SizedBox(
            height: conts.maxWidth,
            width: conts.maxWidth,
            child: Image.network(
              'https://images.pexels.com/photos/9968493/pexels-photo-9968493.jpeg?auto=compress&cs=tinysrgb&w=${conts.maxWidth}&h=${conts.maxWidth}&dpr=2',
              fit: BoxFit.cover,
            ),
          );
        }),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: ColoredBox(
                color: const Color(0xaa000000),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: SizedBox(
                    height: 16,
                    child: Marquee(
                      controller: controller,
                      autoStart: false,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
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
          ),
        ),
      ],
    );
  }
}
