import 'package:flutter/material.dart';

class MaxContainer extends StatelessWidget {
  final Widget child;

  MaxContainer({this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1000),
        child: child,
      ),
    );
  }
}
