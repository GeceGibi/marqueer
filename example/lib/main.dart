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
          _PostCard(),
          SizedBox(height: 40),
          SizedBox(
            height: 100,
            child: Marqueer(
              pps: 30,
              child: Row(
                children: List<Widget>.generate(10, (index) {
                  return Image.network(
                    'https://picsum.photos/id/40$index/60/100',
                    width: 60,
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

    Future.delayed(const Duration(seconds: 5), () {
      controller.interactionEnabled(false);
      Future.delayed(const Duration(seconds: 1), controller.start);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LayoutBuilder(builder: (context, consts) {
          final size = consts.maxWidth;

          return SizedBox(
            height: size,
            width: size,
            child: Image.network(
              'https://images.pexels.com/photos/9968493/pexels-photo-9968493.jpeg?auto=compress&cs=tinysrgb&w=$size&h=$size&dpr=2',
              fit: BoxFit.cover,
            ),
          );
        }),
        Positioned(
          height: 42,
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: ColoredBox(
                color: const Color(0xaa000000),
                child: Marqueer(
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
