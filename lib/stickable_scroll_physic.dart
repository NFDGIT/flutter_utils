
import 'package:flutter/widgets.dart';

class StickableScrollPhysic extends ScrollPhysics {
  // 可贴停的点位
  final List<double> stickExtentList;

  const StickableScrollPhysic({required this.stickExtentList,super.parent});
  @override
  StickableScrollPhysic applyTo(ScrollPhysics? ancestor) {
    return StickableScrollPhysic(stickExtentList: stickExtentList,parent: buildParent(ancestor));
  }

  // 根据位置查找停留点
  double? _getPage(ScrollMetrics position) {
    double? page;
    double currentPosition = 0;
    for (var i = 0; i < stickExtentList.length; i++) {
      // 找到了对应的停留点
      if (position.pixels > currentPosition && position.pixels < currentPosition + stickExtentList[i]) {
        page = i.toDouble() + (position.pixels - currentPosition) / stickExtentList[i];
      }
      currentPosition += stickExtentList[i];
    }
    return page;
  }
  // 根据停留点查找位置
  double? _getPixels(ScrollMetrics position, int page) {
    if (page < stickExtentList.length) {
      double currentPosition = 0;
      for (var i = 0; i < page; i++) {
        currentPosition += stickExtentList[i];
      }
      return currentPosition;
    }
    return null;
  }
  // 获取当前的要停留的位置，如果为空则交由super 进行处理
  double? _getTargetPixels(ScrollMetrics position, Tolerance tolerance, double velocity) {

    double? page = _getPage(position);
    // 如果没有找到对应的停留点下标，则返回空
    if (page == null) {
      return null;
    }
    if (velocity < -tolerance.velocity) {
      page -= 0.5;
    } else if (velocity > tolerance.velocity) {
      page += 0.5;
    }

     // 如果根据停留点下标，没有找到对应的位置，则返回空
    var pixels = _getPixels(position, page.roundToDouble().toInt());
    if (pixels == null) {
      return null;
    }
    return pixels;
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    // 如果超出边界则交由super 进行处理
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final Tolerance tolerance = toleranceFor(position);
    final double? target = _getTargetPixels(position, tolerance, velocity);

    // 如果没有找到停留点，则交由super处理
    if (target == null) {
      return super.createBallisticSimulation(position, velocity);
    }
    // 如果找到停留点，并且停留点与当前位置不一样时，进行弹性过度
    if (target != position.pixels) {
      return ScrollSpringSimulation(spring, position.pixels, target, velocity, tolerance: tolerance);
    }
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}