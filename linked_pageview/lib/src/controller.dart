import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:linked_pageview/src/pageview.dart';

class LinkedPageControllerGroup {
  LinkedPageControllerGroup() {
    _offsetNotifier = _OffsetNotifier(this);
  }

  final _controllers = <_LinkedPageController>[];

  late final _OffsetNotifier _offsetNotifier;

  double get offset => _attachedControllers.firstOrNull?.offset ?? 0.0;

  Iterable<_LinkedPageController> get _attachedControllers =>
      _controllers.where((c) => c.hasClients);

  LinkedPageController create({
    int initialPage = 0,
    bool keepPage = true,
    double viewportFraction = 1.0,
  }) {
    final controller = _LinkedPageController(
      this,
      initialPage: initialPage,
      keepPage: keepPage,
      viewportFraction: viewportFraction,
    );

    _controllers.add(controller);

    controller.addListener(_offsetNotifier.notifyListeners);

    return controller;
  }

  void addOffsetChangedListener(VoidCallback onChanged) =>
      _offsetNotifier.addListener(onChanged);

  void removeOffsetChangedListener(VoidCallback listener) =>
      _offsetNotifier.removeListener(listener);

  Future<void> animateTo(
    double offset, {
    required Curve curve,
    required Duration duration,
  }) {
    final animations = _attachedControllers.map(
      (c) => c.animateTo(
        offset,
        curve: curve,
        duration: duration,
      ),
    );

    return Future.wait(animations);
  }

  void jumpTo(double value) {
    for (final controller in _attachedControllers) {
      controller.jumpTo(value);
    }
  }

  void resetScroll() => jumpTo(0.0);

  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();
  }
}

/// This class provides change notification for [LinkedPageControllerGroup]'s
/// scroll offset.
///
/// This change notifier de-duplicates change events by only firing listeners
/// when the scroll offset of the group has changed.
class _OffsetNotifier extends ChangeNotifier {
  _OffsetNotifier(this.group);

  final LinkedPageControllerGroup group;

  /// The cached offset for the group.
  ///
  /// This value will be used in determining whether to notify listeners.
  double? _cachedOffset;

  @override
  void notifyListeners() {
    final currentOffset = group.offset;
    if (currentOffset != _cachedOffset) {
      _cachedOffset = currentOffset;

      super.notifyListeners();
    }
  }
}

/// A scroll controller that mirrors its movements to a peer, which must also
/// be a [_LinkedPageController].
class _LinkedPageController extends LinkedPageController {
  _LinkedPageController(
    this._group, {
    super.initialPage,
    super.keepPage,
    super.viewportFraction,
  });

  final LinkedPageControllerGroup _group;

  @override
  double get initialScrollOffset => _group._attachedControllers.isEmpty
      ? super.initialScrollOffset
      : _group.offset;

  Iterable<_LinkedPageController> get _peers =>
      _group._attachedControllers.where((p) => p != this);

  @override
  _LinkedScrollPosition get position => super.position as _LinkedScrollPosition;

  bool get canLinkWithPeers => _peers.isNotEmpty;

  @override
  void dispose() {
    _group._controllers.remove(this);

    super.dispose();
  }

  @override
  void attach(ScrollPosition position) {
    assert(
        position is _LinkedScrollPosition,
        'LinkedPageController can only be used with'
        ' LinkedScrollPosition.');

    final linkedPosition = position as _LinkedScrollPosition;

    assert(
      linkedPosition.owner == this,
      'LinkedScrollPosition cannot change controllers once created.',
    );

    super.attach(position);
  }

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return _LinkedScrollPosition(
      this,
      physics: physics,
      context: context,
      oldPosition: oldPosition,
    );
  }

  Iterable<_LinkedScrollActivityImpl> linkPeers(_LinkedScrollPosition driver) =>
      _peers.expand((p) => p._link(driver));

  Iterable<_LinkedScrollActivityImpl> _link(_LinkedScrollPosition driver) =>
      positions.map((p) => (p as _LinkedScrollPosition).link(driver));
}

// Implementation details: Whenever position.setPixels or position.forcePixels
// is called on a _LinkedScrollPosition (which may happen programmatically, or
// as a result of a user action),  the _LinkedScrollPosition creates a
// _LinkedScrollActivity for each linked position and uses it to move to or jump
// to the appropriate offset.
//
// When a new activity begins, the set of peer activities is cleared.
class _LinkedScrollPosition extends LinkedPagePosition {
  _LinkedScrollPosition(
    this.owner, {
    required super.physics,
    required super.context,
    super.oldPosition,
  });

  final _LinkedPageController owner;

  final _activities = <_LinkedScrollActivityImpl>{};

  @override
  ScrollHoldController hold(VoidCallback holdCancelCallback) {
    for (final controller in owner._peers) {
      controller.position._hold();
    }

    return super.hold(holdCancelCallback);
  }

  @override
  void beginActivity(ScrollActivity? newActivity) {
    if (newActivity == null) {
      return;
    }

    for (final activity in _activities) {
      activity.unlink(this);
    }

    _activities.clear();

    super.beginActivity(newActivity);
  }

  @override
  double setPixels(double newPixels) {
    if (newPixels == pixels) {
      return 0.0;
    }

    updateUserScrollDirection(
      newPixels - pixels > 0.0
          ? ScrollDirection.forward
          : ScrollDirection.reverse,
    );

    if (owner.canLinkWithPeers) {
      _activities.addAll(owner.linkPeers(this));

      for (final activity in _activities) {
        activity.moveTo(newPixels);
      }
    }

    return _setPixelsInternal(newPixels);
  }

  @override
  void forcePixels(double value) {
    if (value == pixels) {
      return;
    }

    updateUserScrollDirection(
      value - pixels > 0.0 ? ScrollDirection.forward : ScrollDirection.reverse,
    );

    if (owner.canLinkWithPeers) {
      _activities.addAll(owner.linkPeers(this));

      for (final activity in _activities) {
        activity.jumpTo(value);
      }
    }

    forcePixelsInternal(value);
  }

  @override
  void updateUserScrollDirection(ScrollDirection value) {
    super.updateUserScrollDirection(value);
  }

  @override
  void debugFillDescription(List<String> description) {
    super.debugFillDescription(description);
    description.add('owner: $owner');
  }

  void forcePixelsInternal(double value) {
    super.forcePixels(value);
  }

  void unlink(_LinkedScrollActivityImpl activity) {
    _activities.remove(activity);
  }

  _LinkedScrollActivityImpl link(_LinkedScrollPosition driver) {
    if (this.activity is! _LinkedScrollActivityImpl) {
      beginActivity(_LinkedScrollActivityImpl(this));
    }

    final activity = this.activity as _LinkedScrollActivityImpl;
    activity.link(driver);

    return activity;
  }

  void _hold() => super.hold(() {});

  double _setPixelsInternal(double newPixels) {
    return super.setPixels(newPixels);
  }
}

class _LinkedScrollActivityImpl extends ScrollActivity {
  _LinkedScrollActivityImpl(
    _LinkedScrollPosition super.delegate,
  );

  @override
  _LinkedScrollPosition get delegate => super.delegate as _LinkedScrollPosition;

  @override
  bool get shouldIgnorePointer => true;

  @override
  bool get isScrolling => true;

  @override
  double get velocity => 0.0;

  final drivers = <_LinkedScrollPosition>{};

  @override
  void dispose() {
    for (final driver in drivers) {
      driver.unlink(this);
    }

    super.dispose();
  }

  bool link(_LinkedScrollPosition driver) => drivers.add(driver);

  void unlink(_LinkedScrollPosition driver) {
    drivers.remove(driver);

    if (drivers.isEmpty) {
      delegate.goIdle();
    }
  }

  void moveTo(double newPixels) {
    _updateUserScrollDirection();

    if (drivers.isEmpty) return;

    final driver = drivers.first;
    final driverOffset = newPixels;
    final driverViewportFraction = driver.owner.viewportFraction;
    final driverViewportDimension = driver.viewportDimension;

    if (driverViewportFraction <= 0 || driverViewportDimension <= 0) return;

    final driverPage =
        driverOffset / (driverViewportDimension * driverViewportFraction);

    final peerViewportFraction = delegate.owner.viewportFraction;
    final peerViewportDimension = delegate.viewportDimension;

    if (peerViewportFraction <= 0 || peerViewportDimension <= 0) return;

    final targetOffset =
        driverPage * peerViewportDimension * peerViewportFraction;

    delegate._setPixelsInternal(targetOffset);
  }

  void jumpTo(double newPixels) {
    _updateUserScrollDirection();
    if (drivers.isEmpty) return;

    final driver = drivers.first;
    final driverOffset = newPixels;
    final driverViewportFraction = driver.owner.viewportFraction;
    final driverViewportDimension = driver.viewportDimension;

    if (driverViewportFraction <= 0 || driverViewportDimension <= 0) return;

    final driverPage =
        driverOffset / (driverViewportDimension * driverViewportFraction);

    final peerViewportFraction = delegate.owner.viewportFraction;
    final peerViewportDimension = delegate.viewportDimension;

    if (peerViewportFraction <= 0 || peerViewportDimension <= 0) return;

    final targetOffset =
        driverPage * peerViewportDimension * peerViewportFraction;

    delegate.forcePixelsInternal(targetOffset);
  }

  void _updateUserScrollDirection() {
    assert(drivers.isNotEmpty);
    var commonDirection = drivers.first.userScrollDirection;
    for (final driver in drivers) {
      if (driver.userScrollDirection != commonDirection) {
        commonDirection = ScrollDirection.idle;
      }
    }
    delegate.updateUserScrollDirection(commonDirection);
  }
}
