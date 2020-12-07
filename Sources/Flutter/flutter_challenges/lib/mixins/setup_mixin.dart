import 'package:flutter/material.dart';

mixin SetupMixin<T extends StatefulWidget> on State<T> {
  final customPaintKey = GlobalKey();
  Size _size;

  @override
  void initState() {
    /// This will wait until after the draw call.
    Future.delayed(Duration.zero, () {
      final context = customPaintKey.currentContext;
      if (context == null)
        throw 'Make sure to add the key \`customPaintKey\` to your `CustomPainter`.';

      final RenderBox box = context.findRenderObject();

      _size = box.size;

      setup(box.size);
    });
    super.initState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    final context = customPaintKey.currentContext;
    if (context == null)
      throw 'Make sure to add the key \`customPaintKey\` to your `CustomPainter`.';

    final RenderBox box = context.findRenderObject();

    if (box.size != _size) {
      onWindowResize(box.size);
      _size = box.size;
    }

    super.didUpdateWidget(oldWidget);
  }

  /// final  box = customPaintKey.currentContext.findRenderObject();
  void setup(Size size);

  void onWindowResize(Size size);
}
