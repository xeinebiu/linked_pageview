# Linked PageView

A Flutter package that synchronizes scroll activity across multiple PageViews with different
viewport configurations. Perfect for creating coordinated scrolling experiences across multiple
PageViews.

![preview](docs/preview.gif)

## Features

- 🌀 Synchronize multiple PageViews with single gesture control
- ⚙️ Support for different viewport fractions per PageView
- 🏎️ Smooth scroll coordination with native feel
- 🧩 Simple integration with existing PageView setups
- 📏 Precise pixel-perfect synchronization

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  linked_pageview: ^1.0.0
```

Run in terminal:

```bash
flutter pub get
```

## Usage

### Basic Implementation

```dart
import 'package:flutter/material.dart';
import 'package:linked_pageview/linked_pageview.dart';

final controllerGroup = LinkedPageControllerGroup();
final controller1 = controllerGroup.create(viewportFraction: 0.7);
final controller2 = controllerGroup.create(viewportFraction: 0.4);

class SyncScrollDemo extends StatelessWidget {
  const SyncScrollDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: LinkedPageView(
              controller: controller1,
              children: [ /* Your pages */
              ],
            ),
          ),
          Expanded(
            child: LinkedPageView(
              controller: controller2,
              children: [ /* Your pages */
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

## Use Cases

### Perfect For:

- 🖼️ Synchronized image carousels
- 📊 Coordinated data visualization scrolling
- 🎚️ Multi-layer parallax effects
- 📖 Parallel document comparison
- 🎨 Interactive scroll-based animations
- 📱 Complex onboarding screens

## API Reference

### `LinkedPageControllerGroup`

| Method        | Description                              |
|---------------|------------------------------------------|
| `create()`    | Creates a new linked controller          |
| `animateTo()` | Synchronized animated scroll to position |
| `jumpTo()`    | Immediate synchronized scroll jump       |

### `LinkedPageView`

| Property        | Type                 | Description                      |
|-----------------|----------------------|----------------------------------|
| controller      | LinkedPageController | Required linked controller       |
| scrollDirection | Axis                 | Scroll axis (default horizontal) |
| physics         | ScrollPhysics        | Scroll behavior (default page)   |
| pageSnapping    | bool                 | Snap to pages (default true)     |


## Disposal

To prevent memory leaks, ensure proper disposal of the controller group when it's no longer needed. Disposing the LinkedPageControllerGroup will automatically dispose all linked controllers created by it.
```dart
@override
void dispose() {
    controllerGroup.dispose();
    super.dispose();
}
```