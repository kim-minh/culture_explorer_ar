import 'package:flutter/rendering.dart';

class CustomGridDelegate extends SliverGridDelegate {
  // This is the desired height of each row (and width of each square).
  // When there is not enough room, we shrink this to the width of the scroll view.
  final double dimension = 200;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    // Determine how many squares we can fit per row.
    int count = constraints.crossAxisExtent ~/ dimension;
    if (count < 1) {
      count = 1; // Always fit at least one regardless.
    }
    final double squareDimension = constraints.crossAxisExtent / count;
    return CustomGridLayout(
      crossAxisCount: count,
      dimension: squareDimension,
    );
  }

  @override
  bool shouldRelayout(CustomGridDelegate oldDelegate) {
    return dimension != oldDelegate.dimension;
  }
}

class CustomGridLayout extends SliverGridLayout {
  const CustomGridLayout({
    required this.crossAxisCount,
    required this.dimension,
  })  : assert(crossAxisCount > 0),
        loopLength = crossAxisCount,
        loopHeight = dimension;

  final int crossAxisCount;
  final double dimension;
  final int loopLength;
  final double loopHeight;

  @override
  double computeMaxScrollOffset(int childCount) {
    if (childCount == 0 || dimension == 0) {
      return 0;
    }
    return (childCount ~/ loopLength) * loopHeight +
        ((childCount % loopLength) ~/ crossAxisCount) * dimension;
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    final int loopIndex = index % loopLength;
    return SliverGridGeometry(
      scrollOffset: (index ~/ loopLength) * loopHeight,
      crossAxisOffset: (loopIndex % crossAxisCount) * dimension,
      mainAxisExtent: dimension,
      crossAxisExtent: dimension,
    );
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    return (scrollOffset ~/ dimension) * loopLength;
  }

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    final int rows = (scrollOffset / loopHeight).ceil();
    return rows * loopLength - 1;
  }
}
