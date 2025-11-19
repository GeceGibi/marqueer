import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:marqueer/marqueer.dart';

void main() {
  runApp(const ExampleApp());
}

final controller = MarqueerController();

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marqueer Example',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: .zero,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              TextButton.icon(
                onPressed: controller.backward,
                label: const Text('Backward'),
                icon: const Icon(Icons.chevron_left),
              ),

              TextButton.icon(
                onPressed: () {
                  unawaited(
                    controller.animateTo(
                      0,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut,
                    ),
                  );
                },
                label: const Text('Animate To 0'),
                icon: const Icon(Icons.play_arrow),
              ),

              TextButton.icon(
                onPressed: controller.forward,
                label: const Text('Forward'),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const _PostCard(),
          SizedBox(
            height: 100,
            child: Marqueer.builder(
              pps: 60,
              scrollablePointerIgnoring: true,
              controller: controller,
              itemBuilder: (context, index) {
                ///
                ///
                return GestureDetector(
                  behavior: .opaque,
                  onTap: () {
                    print('Tap');
                  },
                  child: Image.network(
                    'https://picsum.photos/300/300?random=$index',
                    width: 100,
                  ),
                );
              },
            ),
          ),
          const ExchangeBar(),
          SizedBox(
            height: 300,
            child: Marqueer.builder(
              pps: 30,
              controller: controller,
              direction: MarqueerDirection.ltr,
              autoStartAfter: const Duration(seconds: 2),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Image.network(
                  'https://picsum.photos/300/300?random=$index',
                  height: 300,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = (mediaQuery.size.width * mediaQuery.devicePixelRatio).toInt();
    final id = Random().nextInt(1000);

    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Marqueer(
            controller: controller,
            direction: .btt,
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                'https://picsum.photos/$size/$size?random=$id',
                fit: .cover,
              ),
            ),
          ),
        ),
        Positioned(
          height: 42,
          bottom: 8,
          left: 0,
          right: 0,
          child: ClipRRect(
            child: BackdropFilter(
              filter: .blur(sigmaX: 12, sigmaY: 12),
              child: ColoredBox(
                color: const Color(0x66000000),
                child: Marqueer(
                  controller: controller,
                  autoStartAfter: const Duration(seconds: 3),
                  child: const Padding(
                    padding: .all(12),
                    child: Text(
                      'Curabitur nec ex auctor risus scelerisque rhoncus ut porttitor sapien. Pellentesque vestibulum leo a nisi sollicitudin vehicula. Ut fringilla elementum iaculis. Sed risus justo, facilisis at metus sed, interdum euismod lectus. Vivamus tincidunt lorem vel mauris hendrerit, a efficitur felis porttitor. Nulla facilisi.',
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

class ExchangeBar extends StatelessWidget {
  const ExchangeBar({super.key});
  static const data = <Map<String, dynamic>>[
    {
      'id': 'xu100_index',
      'direction': -1,
      'value': '5.212,38',
      'change_percent': '%-0.93',
      'title': 'BIST 100',
      'currency': '',
    },
    {
      'id': 'usdtry_curncy',
      'direction': -1,
      'value': '18,7993',
      'change_percent': '%-0.32',
      'title': 'Dolar',
      'currency': '₺',
    },
    {
      'id': 'eurtry_curncy',
      'direction': 1,
      'value': '20,0293',
      'change_percent': '%0.24',
      'title': 'Euro',
      'currency': '₺',
    },
    {
      'id': 'eurusd_curncy',
      'direction': 1,
      'value': '1,0636',
      'change_percent': '%0.33',
      'title': 'EUR/USD',
      'currency': r'$',
    },
    {
      'id': 'tahvil2y',
      'direction': -1,
      'value': '10,49',
      'change_percent': '%-1.32',
      'title': 'Faiz',
      'currency': '',
    },
    {
      'id': 'xau_curncy',
      'direction': 1,
      'value': '1.856,48',
      'change_percent': '%1.12',
      'title': 'Altın Ons',
      'currency': r'$',
    },
    {
      'id': 'co1_comdty',
      'direction': 1,
      'value': '85,83',
      'change_percent': '%1.27',
      'title': 'Brent Petrol',
      'currency': r'$',
    },
    {
      'id': 'bdiy_index',
      'direction': 1,
      'value': '1.211,00',
      'change_percent': '%5.76',
      'title': 'Baltık Kuru Yük.',
      'currency': r'$',
    },
    {
      'id': 'btcusdt',
      'title': 'Bitcoin',
      'value': '22,430.00',
      'change_percent': '%0.46',
      'direction': 1,
      'currency': r'$',
    },
    {
      'id': 'ethusdt',
      'title': 'Ethereum',
      'value': '1,570.10',
      'change_percent': '%0.4',
      'direction': 1,
      'currency': r'$',
    },
    {
      'id': 'gldgr',
      'title': 'Altın Gram',
      'value': '1,127.08',
      'change_percent': '%1.01',
      'direction': 1,
      'currency': '₺',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Marqueer.builder(
        controller: controller,
        separatorBuilder: (_, index) => const Center(
          child: Text('      ~     '),
        ),
        itemBuilder: (context, index) {
          final multiplier = index ~/ data.length;

          var i = index;

          if (multiplier > 0) {
            i = index - (multiplier * data.length);
          }

          final item = data[i];

          final color = switch (item['direction']) {
            1 => Colors.green,
            -1 => Colors.red,
            _ => Colors.grey,
          };

          return Padding(
            padding: const .symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: .start,
              mainAxisAlignment: .center,
              children: [
                Text(
                  "${item['title']}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "${item['value']} ${item['currency']}",
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
