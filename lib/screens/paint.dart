import 'dart:ui' as ui;

import 'package:drawing_app/provider/paint_provider.dart';
import 'package:drawing_app/screens/board.dart';
import 'package:drawing_app/utills/line_point.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


//paint.dart
class Paint extends StatefulWidget {
  const Paint({Key? key}) : super(key: key);

  @override
  State<Paint> createState() => _PaintState();
}

class _PaintState extends State<Paint> {
  List<LinePoint> stroke = [];

  @override
  Widget build(BuildContext context) {
    Color selectedBackgroundColor = Provider.of<PaintProvider>(context).selectedBackgroundColor;
    Color selectedLineColor = Provider.of<PaintProvider>(context).selectedLineColor;
    double? lineSize = Provider.of<PaintProvider>(context).lineSize;
    List<LinePoint>? points = Provider.of<PaintProvider>(context).points;
    Offset? pointerOffset = Provider.of<PaintProvider>(context).pointerOffset;
    Tools selectedTool = Provider.of<PaintProvider>(context).selectedTool;
    final drawActions = Provider.of<PaintProvider>(context);

    setStroke(Offset position) {
      if (selectedTool == Tools.pencil) {
        stroke.add(
          LinePoint(
            point: position,
            color: selectedLineColor,
            size: lineSize,
            tool: Tools.pencil,
          ),
        );
      } else if (selectedTool == Tools.eraser) {
        stroke.add(
          LinePoint(
            point: position,
            size: lineSize,
            tool: Tools.eraser,
          ),
        );
      }
    }

    return GestureDetector(
      onPanStart: (details) {
        drawActions.drawOnBoard(details.localPosition);
        setStroke(details.localPosition);
      },
      onPanUpdate: (details) {
        drawActions.drawOnBoard(details.localPosition);
        setStroke(details.localPosition);
      },
      onPanEnd: (details) {
        drawActions.drawOnBoard(null);
        stroke.add(
          LinePoint(
            point: null,
            size: lineSize,
            tool: Tools.eraser,
          ),
        );
        drawActions.addStrokeHistory([...stroke]);
        stroke = [];
      },
      child: ClipRect(
        child: CustomPaint(
          size: MediaQuery.of(context).size,
          painter: Board(
            pointerOffset: pointerOffset,
            points: points,
            backgroundColor: selectedBackgroundColor,
            // pointerImage: pointerImage
          ),
        ),
      ),
    );
  }
}
