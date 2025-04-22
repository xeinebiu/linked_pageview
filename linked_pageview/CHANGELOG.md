## 1.1.1

* Fix: Exported `ExpandableLinkedPageView` widget
    - The widget was added in 1.1.0 but not exported from the package
    - Now available for external use via package imports

## 1.1.0

* Feat: Added `ExpandableLinkedPageView` widget
    - Automatically resizes based on the content of the current page
    - Supports both children list and builder constructor
    - Integrates fully with `LinkedPageController` for synchronized scrolling
    - Smooth resize animations with customizable duration and curve
    - Useful for pages with dynamic or varying content sizes

## 1.0.1

* Feat: Added disposal for `LinkedPageControllerGroup` to prevent memory leaks

## 1.0.0

* Initial release of `linked_pageview`
    - Synchronized scrolling across multiple `PageView`s
    - Supports custom viewport fractions
    - Pixel-perfect scroll coordination
