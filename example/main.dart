import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:marqueer/marqueer.dart';

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key});

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
            height: 100,
            child: Marqueer.builder(
              pps: 60,
              direction: MarqueerDirection.ltr,
              itemBuilder: (_, index) {
                return Image.network(
                  'https://api.lorem.space/image/game?w=300&h=300&t=$index',
                  width: 100,
                );
              },
            ),
          ),
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
              autoStartAfter: const Duration(seconds: 2),
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

class _PostCard extends StatelessWidget {
  const _PostCard({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = (mediaQuery.size.width * mediaQuery.devicePixelRatio).toInt();
    final id = Random().nextInt(1000);

    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Image.network(
            'https://api.lorem.space/image?w=$size&h=$size&t=$id',
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          height: 42,
          bottom: 8,
          left: 0,
          right: 0,
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: ColoredBox(
                color: const Color(0x66000000),
                child: Marqueer(
                  autoStartAfter: const Duration(seconds: 3),
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
