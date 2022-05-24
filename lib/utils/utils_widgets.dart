

import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CustomToggle extends StatefulWidget {
  CustomToggle({Key? key,required this.items,required this.onToggle,required this.selectedIndex,this.minWidth}) : super(key: key);
  List<String> items;
  void Function(int? value) onToggle;
  int selectedIndex;
  double? minWidth;

  @override
  _CustomToggleState createState() => _CustomToggleState();
}

class _CustomToggleState extends State<CustomToggle> {
  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      iconSize: 0,
      activeBgColor: [Theme.of(context).primaryColor],
      radiusStyle: true,
      activeFgColor: Theme.of(context).textTheme.bodyText1!.color,
      inactiveBgColor: Theme.of(context).canvasColor,
      inactiveFgColor: Theme.of(context).textTheme.bodyText1!.color,
      minWidth: widget.minWidth??100,
      activeBorders: [Border.all(color:Theme.of(context).canvasColor,width: 3.0)],
      animate: false,
      initialLabelIndex: widget.selectedIndex,
      labels: widget.items,
      onToggle: widget.onToggle,
    );
  }
}
