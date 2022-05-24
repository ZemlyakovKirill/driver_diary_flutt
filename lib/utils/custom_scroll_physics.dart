import 'dart:core';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class CustomScrollPhysics extends ScrollPhysics {
  final double separatorSize;
  final double itemSize;
  final int itemCount;

  const CustomScrollPhysics(
      {required this.separatorSize,
        required this.itemSize,
      required this.itemCount});

  double _getPage(ScrollMetrics position) {
    return position.pixels / (separatorSize + itemSize);
  }

  double _getPixels(double page) {
    return page * (separatorSize + itemSize);
  }

  double _getTargetPixels(
      ScrollMetrics position, Tolerance tolerance, double velocity) {
    double page = _getPage(position);
    if (velocity < -tolerance.velocity) {
      page -= 0.5;
    } else if (velocity > tolerance.velocity) {
      page += 0.5;
    }
    return _getPixels(page.roundToDouble());
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    if (velocity < 0.0 && position.pixels <= position.minScrollExtent) {
      return BouncingScrollSimulation(
          position: position.pixels,
          velocity: velocity,
          leadingExtent: 0,
          trailingExtent: 0,
          tolerance: this.tolerance,
          spring: spring);
    }
    if (velocity > 0.0 && position.pixels >= position.maxScrollExtent) {
      return BouncingScrollSimulation(
          position: position.pixels,
          velocity: velocity,
          leadingExtent: 0,
          trailingExtent: _getPixels(itemCount-1),
          spring: spring);
    }
    final Tolerance tolerance = this.tolerance;
    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels) {
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    }
    return null;
  }

  @override
  ScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(
        separatorSize: separatorSize, itemSize: itemSize,itemCount: itemCount);
  }

  @override
  bool get allowImplicitScrolling {
    return false;
  }
}
