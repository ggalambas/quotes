import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DragUpIndicator extends StatefulWidget {
  final bool disabled;
  final AsyncCallback? onRefresh;
  final Widget child;

  const DragUpIndicator({
    Key? key,
    this.disabled = false,
    this.onRefresh,
    required this.child,
  }) : super(key: key);

  @override
  State<DragUpIndicator> createState() => _DragUpIndicatorState();
}

class _DragUpIndicatorState extends State<DragUpIndicator>
    with SingleTickerProviderStateMixin {
  static const dragOffset = 50.0;
  var prevScrollDirection = ScrollDirection.idle;

  double containerHeight(IndicatorController controller) =>
      controller.value * dragOffset;

  @override
  Widget build(BuildContext context) {
    if (widget.disabled) return widget.child;
    return CustomRefreshIndicator(
      reversed: true,
      leadingScrollIndicatorVisible: false,
      trailingScrollIndicatorVisible: true,
      offsetToArmed: dragOffset,
      onRefresh: () async => await widget.onRefresh?.call(),
      builder: (context, child, controller) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                if (controller.scrollingDirection == ScrollDirection.reverse &&
                    prevScrollDirection == ScrollDirection.forward) {
                  controller.stopDrag();
                }
                prevScrollDirection = controller.scrollingDirection;
                return Container(
                  alignment: Alignment.center,
                  height: containerHeight(controller),
                  child: const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                return Transform.translate(
                  offset: Offset(0.0, -containerHeight(controller)),
                  child: child,
                );
              },
            ),
          ],
        );
      },
      child: widget.child,
    );
  }
}
