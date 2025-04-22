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
- 📐 Expandable PageView with animated resizing based on child content
- 🧱 Use either child-based or builder-based constructors for flexible content rendering
- 🔁 Seamlessly integrates with `LinkedPageController` for full scroll sync support

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  linked_pageview: ^1.1.1
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

### Expandable PageView

`ExpandableLinkedPageView` automatically resizes its height (or width, depending on scroll
direction) based on the content of the currently visible page. This is especially useful when your
pages have variable sizes, such as cards or dynamic layouts.

You can use either:

- `ExpandableLinkedPageView` with a list of children
- `ExpandableLinkedPageView.builder` for lazily built content

```dart
ExpandableLinkedPageView(
  controller: controller1,
  children: [
    Container(height: 200, color: Colors.red),
    Container(height: 400, color: Colors.green),
    Container(height: 300, color: Colors.blue),
  ],
),
```

Or with builder:

```dart
ExpandableLinkedPageView.builder(
  controller: controller2,
  itemCount: 3,
  itemBuilder: (context, index) => Container(
    height: 200.0 + index * 100,
    color: Colors.primaries[index],
  ),
),
```

The PageView will animate between sizes smoothly using customizable duration and curve settings.

## Use Cases

### Perfect For:

- 🖼️ Synchronized image carousels
- 📊 Coordinated data visualization scrolling
- 🎚️ Multi-layer parallax effects
- 📖 Parallel document comparison
- 🎨 Interactive scroll-based animations
- 📱 Complex onboarding screens
- ↕️ Pages with varying height content needing dynamic resizing

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

### `ExpandableLinkedPageView`

| Feature                | Description                                                            |
|------------------------|------------------------------------------------------------------------|
| Auto resizing          | PageView resizes to match the current page's content size              |
| Smooth animations      | Customizable duration and curve for resize transitions                 |
| Horizontal or vertical | Respects `scrollDirection` and animates width or height accordingly    |
| Builder support        | Use `.builder` constructor for performance with large dynamic lists    |
| Initial sizing config  | Use `estimatedPageSize` to minimize resize flicker during first render |
| Scroll sync            | Fully compatible with `LinkedPageController` for synchronized behavior |

## Disposal

To prevent memory leaks, ensure proper disposal of the controller group when it's no longer needed.
Disposing the `LinkedPageControllerGroup` will automatically dispose all linked controllers created
by it.

```dart
@override
void dispose() {
  controllerGroup.dispose();
  super.dispose();
}
```
