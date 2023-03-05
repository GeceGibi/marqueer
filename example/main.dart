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
        padding: const EdgeInsets.symmetric(vertical: 0),
        children: [
          const _PostCard(),
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
          const ExchangeBar(),
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

class ExchangeBar extends StatelessWidget {
  static const data = <Map<String, dynamic>>[
    {
      "id": "xu100_index",
      "direction": -1,
      "value": "5.212,38",
      "change_percent": "%-0.93",
      "title": "BIST 100",
      "currency": ""
    },
    {
      "id": "usdtry_curncy",
      "direction": -1,
      "value": "18,7993",
      "change_percent": "%-0.32",
      "title": "Dolar",
      "currency": "₺"
    },
    {
      "id": "eurtry_curncy",
      "direction": 1,
      "value": "20,0293",
      "change_percent": "%0.24",
      "title": "Euro",
      "currency": "₺"
    },
    {
      "id": "eurusd_curncy",
      "direction": 1,
      "value": "1,0636",
      "change_percent": "%0.33",
      "title": "EUR/USD",
      "currency": "\$"
    },
    {
      "id": "tahvil2y",
      "direction": -1,
      "value": "10,49",
      "change_percent": "%-1.32",
      "title": "Faiz",
      "currency": ""
    },
    {
      "id": "xau_curncy",
      "direction": 1,
      "value": "1.856,48",
      "change_percent": "%1.12",
      "title": "Altın Ons",
      "currency": "\$"
    },
    {
      "id": "co1_comdty",
      "direction": 1,
      "value": "85,83",
      "change_percent": "%1.27",
      "title": "Brent Petrol",
      "currency": "\$"
    },
    {
      "id": "bdiy_index",
      "direction": 1,
      "value": "1.211,00",
      "change_percent": "%5.76",
      "title": "Baltık Kuru Yük.",
      "currency": "\$"
    },
    {
      "id": "btcusdt",
      "title": "Bitcoin",
      "value": "22,430.00",
      "change_percent": "%0.46",
      "direction": 1,
      "currency": "\$"
    },
    {
      "id": "ethusdt",
      "title": "Ethereum",
      "value": "1,570.10",
      "change_percent": "%0.4",
      "direction": 1,
      "currency": "\$"
    },
    {
      "id": "gldgr",
      "title": "Altın Gram",
      "value": "1,127.08",
      "change_percent": "%1.01",
      "direction": 1,
      "currency": "₺"
    }
  ];

  const ExchangeBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Marqueer.builder(
        itemBuilder: (context, index) {
          var multiplier = index ~/ data.length;

          var i = index;

          if (multiplier > 0) {
            i = index - (multiplier * data.length);
          }

          final item = data[i];

          late Color color;

          switch (item['direction']) {
            case 1:
              color = Colors.green;
              break;

            case -1:
              color = Colors.red;
              break;

            default:
              color = Colors.grey;
              break;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
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
