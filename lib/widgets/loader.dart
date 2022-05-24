import 'dart:async';

import 'package:flutter/material.dart';

class CustomAnimatedProgressIndicator extends StatefulWidget {
  CustomAnimatedProgressIndicator(
      {Key? key, required this.size, required this.isCompleted, required this.color,required this.plug})
      : super(key: key);
  final double size;
  final Widget plug;
  bool isCompleted;
  Color color;

  @override
  State<CustomAnimatedProgressIndicator> createState() =>
      _CustomAnimatedProgressIndicatorState();
}

class _CustomAnimatedProgressIndicatorState
    extends State<CustomAnimatedProgressIndicator> {
  bool isFinished=false;


  @override
  void initState() {
    super.initState();
    if(widget.isCompleted){
      _showDelayedPlug();
    }
  }

  @override
  Widget build(BuildContext context) {
    if(!widget.isCompleted){
      isFinished=false;
    }
    return Center(
      child: SizedBox(
        height: widget.size,
        width: widget.size,
        child: Builder(
          builder: (context) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: widget.isCompleted
                  ? (isFinished?widget.plug:_showCompletedIcon()
              )
                  : CircularProgressIndicator(
                strokeWidth: 2.5,
                color: widget.color,
              ),
            );
          }
        ),
      ),
    );
  }

  void _showDelayedPlug(){
    Future.delayed(
      const Duration(seconds: 3),
          () {
            if(mounted){
          setState(() {
            isFinished = true;
          });
        }
      },
    );
  }

  Widget _showCompletedIcon(){
    _showDelayedPlug();
    return Icon(Icons.done,
        key: ValueKey<int>(9999),
        color: widget.color,
        size: widget.size);
  }
}
