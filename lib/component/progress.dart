import 'dart:math';

import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  int total;
  int current;

  ProgressBar({Key? key, required this.total, required this.current})
      : super(key: key);

  List<Widget> list = [];
//   final ScrollController _controller = new ScrollController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    for (int i = 1; i <= total; i++) {
      list.add(Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(5),
        width: 5,
        height: 5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: i < current
                ? Colors.green.shade300
                : i == current
                    ? Colors.orange.shade300
                    : Colors.grey.shade300),
      ));
      if (i != total) {
        list.add(Container(
          width: i == current || i == current - 1 ? 30 : 10,
          height: 0.5,
          decoration: BoxDecoration(color: Colors.grey.shade400),
          margin: EdgeInsets.symmetric(horizontal: 0.2),
        ));
      }
    }
    return SingleChildScrollView(
        // controller: _controller,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: list,
        ));
  }
}
