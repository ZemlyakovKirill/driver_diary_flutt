import 'dart:developer';

import 'package:flutter/material.dart';

class AnimatedAppearance extends StatefulWidget {
  AnimatedAppearance({Key? key,required this.child}) : super(key: key);
  final Widget child;
  @override
  _AnimatedAppearanceState createState() => _AnimatedAppearanceState();
}

class _AnimatedAppearanceState extends State<AnimatedAppearance> with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller=AnimationController(vsync: this,duration: Duration(milliseconds: 500));
    _animation=CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    _controller.forward();
  }


  @override
  void didUpdateWidget(AnimatedAppearance oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        sizeFactor: _animation,
      axis: Axis.horizontal,
      child: widget.child,
    );
  }
}
