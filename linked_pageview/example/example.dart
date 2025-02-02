import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:linked_pageview/linked_pageview.dart';

void main() {
  runApp(const MyApp());
}

final group = LinkedPageControllerGroup();
final viewportFractions = [0.2, 0.4, 0.6, 0.8, 1.0];
final controllers = [
  for (double fraction in viewportFractions) group.create(viewportFraction: fraction),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('LinkedPageView Example')),
        body: Column(
          children: [
            for (int controllerIndex = 0; controllerIndex < controllers.length; controllerIndex++)
              Expanded(
                child: LinkedPageView(
                  controller: controllers[controllerIndex],
                  children: List.generate(
                    5,
                        (pageIndex) => Container(
                      color: Colors.primaries[
                      (pageIndex + controllerIndex) % Colors.primaries.length],
                      child: Center(
                        child: Text("LinkedPageView $controllerIndex\nPage $pageIndex"),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
