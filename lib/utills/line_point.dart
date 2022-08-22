import 'dart:ui';

import 'package:drawing_app/provider/paint_provider.dart';

class LinePoint {
  Offset? point;
  Color? color;
  double? size;
  Tools? tool;

  LinePoint({this.point, this.color, this.size, this.tool});

  LinePoint clone() => LinePoint(point: point, color: color, size: size);
}
