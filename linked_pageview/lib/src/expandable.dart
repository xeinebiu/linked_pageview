import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:linked_pageview/linked_pageview.dart';

typedef WidgetBuilder = Widget Function(BuildContext context, int index);

class ExpandableLinkedPageView extends StatefulWidget {
  /// List of widgets to display
  ///
  /// Corresponds to Material's PageView's children parameter: https://api.flutter.dev/flutter/widgets/PageView-class.html
  final List<Widget>? children;

  /// Number of widgets to display
  ///
  /// Corresponds to Material PageView's itemCount parameter: https://api.flutter.dev/flutter/widgets/PageView-class.html
  final int? itemCount;

  /// Item builder function
  ///
  /// Corresponds to Material's PageView's itemBuilder parameter: https://api.flutter.dev/flutter/widgets/PageView-class.html
  final WidgetBuilder? itemBuilder;

  /// An object that can be used to control the position to which this page view is scrolled.
  ///
  /// Corresponds to Material's PageView's controller parameter: https://api.flutter.dev/flutter/widgets/PageView-class.html
  final LinkedPageController controller;

  /// Called whenever the page in the center of the viewport changes.
  ///
  /// Corresponds to Material's PageView's onPageChanged parameter: https://api.flutter.dev/flutter/widgets/PageView-class.html
  final ValueChanged<int>? onPageChanged;

  /// Whether the page view scrolls in the reading direction.
  ///
  /// Corresponds to Material's PageView's reverse parameter: https://api.flutter.dev/flutter/widgets/PageView-class.html
  final bool reverse;

  /// Duration of PageView resize animation upon page change
  ///
  /// Defaults to [100 milliseconds]
  final Duration animationDuration;

  /// Curve use for PageView resize animation upon page change
  ///
  /// Defaults to [Curves.easeInOutCubic]
  final Curve animationCurve;

  /// How the page view should respond to user input.
  ///
  /// Corresponds to Material's PageView's physics parameter: https://api.flutter.dev/flutter/widgets/PageView-class.html
  final ScrollPhysics? physics;

  /// Set to false to disable page snapping, useful for custom scroll behavior.
  ///
  /// Corresponds to Material's PageView's pageSnapping parameter: https://api.flutter.dev/flutter/widgets/PageView-class.html
  final bool pageSnapping;

  /// Determines the way that drag start behavior is handled.
  ///
  /// Corresponds to Material's PageView's dragStartBehavior parameter: https://api.flutter.dev/flutter/widgets/PageView-class.html
  final DragStartBehavior dragStartBehavior;

  /// Controls whether the widget's pages will respond to [RenderObject.showOnScreen], which will allow for implicit accessibility scrolling.
  ///
  /// Corresponds to Material's PageView's allowImplicitScrolling parameter: https://api.flutter.dev/flutter/widgets/PageView-class.html
  final bool allowImplicitScrolling;

  /// Restoration ID to save and restore the scroll offset of the scrollable.
  ///
  /// Corresponds to Material's PageView's restorationId parameter: https://api.flutter.dev/flutter/widgets/PageView-class.html
  final String? restorationId;

  /// The content will be clipped (or not) according to this option.
  ///
  /// Corresponds to Material's PageView's clipBehavior parameter: https://api.flutter.dev/flutter/widgets/PageView-class.html
  final Clip clipBehavior;

  /// Whether to animate the first page displayed by this widget.
  ///
  /// By default (false) [ExpandableLinkedPageView] will resize to the size of it's
  /// initially displayed page without any animation.
  final bool animateFirstPage;

  /// Determines the alignment of the content when animating. Useful when building centered or bottom-aligned PageViews.
  final Alignment alignment;

  /// The estimated size of displayed pages.
  ///
  /// This property can be used to indicate how big a page will be more or less.
  /// By default (0.0) all pages will have their initial sizes set to 0.0
  /// until they report that their size changed, which will result in
  /// [ExpandableLinkedPageView] size animation. This can lead to a behaviour
  /// when after changing the page, [ExpandableLinkedPageView] will first shrink to 0.0
  /// and then animate to the size of the page.
  ///
  /// For example: If there is certainty that most pages displayed by [ExpandableLinkedPageView]
  /// will vary from 200 to 600 in size, then [estimatedPageSize] could be set to some
  /// value in that range, to at least partially remove the "shrink and expand" effect.
  ///
  /// Setting it to a value much bigger than most pages' sizes might result in a
  /// reversed - "expand and shrink" - effect.
  final double estimatedPageSize;

  ///A ScrollBehavior that will be applied to this widget individually.
  //
  // Defaults to null, wherein the inherited ScrollBehavior is copied and modified to alter the viewport decoration, like Scrollbars.
  //
  // ScrollBehaviors also provide ScrollPhysics. If an explicit ScrollPhysics is provided in physics, it will take precedence, followed by scrollBehavior, and then the inherited ancestor ScrollBehavior.
  //
  // The ScrollBehavior of the inherited ScrollConfiguration will be modified by default to not apply a Scrollbar.
  final ScrollBehavior? scrollBehavior;

  ///The axis along which the page view scrolls.
  //
  // Defaults to Axis.horizontal.
  final Axis scrollDirection;

  /// Whether to add padding to both ends of the list.
  ///
  /// If this is set to true and [PageController.viewportFraction] < 1.0, padding will be added
  /// such that the first and last child slivers will be in the center of
  /// the viewport when scrolled all the way to the start or end, respectively.
  ///
  /// If [PageController.viewportFraction] >= 1.0, this property has no effect.
  ///
  /// This property defaults to true and must not be null.
  final bool padEnds;

  const ExpandableLinkedPageView({
    required List<Widget> this.children,
    required this.controller,
    this.onPageChanged,
    this.reverse = false,
    this.animationDuration = const Duration(milliseconds: 100),
    this.animationCurve = Curves.easeInOutCubic,
    this.physics,
    this.pageSnapping = true,
    this.dragStartBehavior = DragStartBehavior.start,
    this.allowImplicitScrolling = false,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.animateFirstPage = false,
    this.estimatedPageSize = 0.0,
    this.alignment = Alignment.topCenter,
    this.scrollBehavior,
    this.scrollDirection = Axis.horizontal,
    this.padEnds = true,
    super.key,
  })  : assert(estimatedPageSize >= 0.0),
        itemBuilder = null,
        itemCount = null;

  const ExpandableLinkedPageView.builder({
    required int this.itemCount,
    required WidgetBuilder this.itemBuilder,
    required this.controller,
    this.onPageChanged,
    this.reverse = false,
    this.animationDuration = const Duration(milliseconds: 100),
    this.animationCurve = Curves.easeInOutCubic,
    this.physics,
    this.pageSnapping = true,
    this.dragStartBehavior = DragStartBehavior.start,
    this.allowImplicitScrolling = false,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.animateFirstPage = false,
    this.estimatedPageSize = 0.0,
    this.alignment = Alignment.topCenter,
    this.scrollBehavior,
    this.scrollDirection = Axis.horizontal,
    this.padEnds = true,
    super.key,
  })  : assert(estimatedPageSize >= 0.0),
        children = null;

  @override
  State createState() => _ExpandableLinkedPageViewState();
}

class _ExpandableLinkedPageViewState extends State<ExpandableLinkedPageView> {
  late LinkedPageController _pageController;
  late List<double> _sizes;
  int _currentPage = 0;
  int _previousPage = 0;
  bool _firstPageLoaded = false;

  double get _currentSize => _sizes[_currentPage];

  double get _previousSize => _sizes[_previousPage];

  bool get isBuilder => widget.itemBuilder != null;

  bool get _isHorizontalScroll => widget.scrollDirection == Axis.horizontal;

  @override
  void initState() {
    super.initState();
    _sizes = _prepareSizes();
    _pageController = widget.controller;
    _pageController.addListener(_updatePage);
    _currentPage = _pageController.initialPage.clamp(0, _sizes.length - 1);
    _previousPage = _currentPage - 1 < 0 ? 0 : _currentPage - 1;
  }

  @override
  void didUpdateWidget(covariant ExpandableLinkedPageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_updatePage);
      _pageController = widget.controller;
      _pageController.addListener(_updatePage);
    }
    if (_shouldReinitializeHeights(oldWidget)) {
      _reinitializeSizes();
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_updatePage);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      curve: widget.animationCurve,
      duration: _getDuration(),
      tween: Tween<double>(begin: _previousSize, end: _currentSize),
      builder: (context, value, child) => SizedBox(
        height: _isHorizontalScroll ? value : null,
        width: !_isHorizontalScroll ? value : null,
        child: child,
      ),
      child: _buildPageView(),
    );
  }

  bool _shouldReinitializeHeights(ExpandableLinkedPageView oldWidget) {
    if (oldWidget.itemBuilder != null && isBuilder) {
      return oldWidget.itemCount != widget.itemCount;
    }
    return oldWidget.children?.length != widget.children?.length;
  }

  void _reinitializeSizes() {
    final currentPageSize = _sizes[_currentPage];
    _sizes = _prepareSizes();

    if (_currentPage >= _sizes.length) {
      final differenceFromPreviousToCurrent = _previousPage - _currentPage;
      _currentPage = _sizes.length - 1;
      widget.onPageChanged?.call(_currentPage);

      _previousPage = (_currentPage + differenceFromPreviousToCurrent)
          .clamp(0, _sizes.length - 1);
    }

    _previousPage = _previousPage.clamp(0, _sizes.length - 1);
    _sizes[_currentPage] = currentPageSize;
  }

  Duration _getDuration() {
    if (_firstPageLoaded) {
      return widget.animationDuration;
    }
    return widget.animateFirstPage ? widget.animationDuration : Duration.zero;
  }

  Widget _buildPageView() {
    if (isBuilder) {
      return LinkedPageView.builder(
        controller: _pageController,
        itemBuilder: _itemBuilder,
        itemCount: widget.itemCount,
        onPageChanged: widget.onPageChanged,
        reverse: widget.reverse,
        physics: widget.physics,
        pageSnapping: widget.pageSnapping,
        dragStartBehavior: widget.dragStartBehavior,
        allowImplicitScrolling: widget.allowImplicitScrolling,
        restorationId: widget.restorationId,
        clipBehavior: widget.clipBehavior,
        scrollBehavior: widget.scrollBehavior,
        scrollDirection: widget.scrollDirection,
        padEnds: widget.padEnds,
      );
    }
    return LinkedPageView(
      controller: _pageController,
      onPageChanged: widget.onPageChanged,
      reverse: widget.reverse,
      physics: widget.physics,
      pageSnapping: widget.pageSnapping,
      dragStartBehavior: widget.dragStartBehavior,
      allowImplicitScrolling: widget.allowImplicitScrolling,
      restorationId: widget.restorationId,
      clipBehavior: widget.clipBehavior,
      scrollBehavior: widget.scrollBehavior,
      scrollDirection: widget.scrollDirection,
      padEnds: widget.padEnds,
      children: _sizeReportingChildren(),
    );
  }

  List<double> _prepareSizes() {
    if (isBuilder) {
      return List.filled(widget.itemCount!, widget.estimatedPageSize);
    } else {
      return widget.children!.map((child) => widget.estimatedPageSize).toList();
    }
  }

  void _updatePage() {
    final newPage = _pageController.page!.round();
    if (_currentPage != newPage) {
      setState(() {
        _firstPageLoaded = true;
        _previousPage = _currentPage;
        _currentPage = newPage;
      });
    }
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final item = widget.itemBuilder!(context, index);
    return _OverflowPage(
      onSizeChange: (size) => setState(
        () => _sizes[index] = _isHorizontalScroll ? size.height : size.width,
      ),
      alignment: widget.alignment,
      scrollDirection: widget.scrollDirection,
      child: item,
    );
  }

  List<Widget> _sizeReportingChildren() => widget.children!
      .asMap()
      .map(
        (index, child) => MapEntry(
          index,
          _OverflowPage(
            onSizeChange: (size) => setState(
              () => _sizes[index] =
                  _isHorizontalScroll ? size.height : size.width,
            ),
            alignment: widget.alignment,
            scrollDirection: widget.scrollDirection,
            child: child,
          ),
        ),
      )
      .values
      .toList();
}

class _OverflowPage extends StatelessWidget {
  final ValueChanged<Size> onSizeChange;
  final Widget child;
  final Alignment alignment;
  final Axis scrollDirection;

  const _OverflowPage({
    required this.onSizeChange,
    required this.child,
    required this.alignment,
    required this.scrollDirection,
  });

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      minHeight: scrollDirection == Axis.horizontal ? 0 : null,
      minWidth: scrollDirection == Axis.vertical ? 0 : null,
      maxHeight: scrollDirection == Axis.horizontal ? double.infinity : null,
      maxWidth: scrollDirection == Axis.vertical ? double.infinity : null,
      alignment: alignment,
      child: _SizeReportingWidget(
        onSizeChange: onSizeChange,
        child: child,
      ),
    );
  }
}

class _SizeReportingWidget extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onSizeChange;

  const _SizeReportingWidget({
    required this.child,
    required this.onSizeChange,
  });

  @override
  _SizeReportingWidgetState createState() => _SizeReportingWidgetState();
}

class _SizeReportingWidgetState extends State<_SizeReportingWidget> {
  final _widgetKey = GlobalKey();
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
        return true;
      },
      child: SizeChangedLayoutNotifier(
        child: Container(
          key: _widgetKey,
          child: widget.child,
        ),
      ),
    );
  }

  void _notifySize() {
    try {
      final context = _widgetKey.currentContext;

      if (context == null) return;

      final size = context.size;

      if (_oldSize != size) {
        _oldSize = size;

        if (size != null) {
          widget.onSizeChange(size);
        }
      }
    } catch (e) {
      // Cannot get size from a render object that has been marked dirty for layout.
      // ignore
    }
  }
}
