import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ResponsiveWidget({Key key, this.mobile, this.tablet, this.desktop})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 750) {
        return mobile;
      } else if (constraints.maxWidth >= 600 && constraints.maxWidth <= 1100) {
        return tablet;
      } else
        return desktop;
    });
  }
}
