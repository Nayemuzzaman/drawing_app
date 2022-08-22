
import 'dart:io';
import 'dart:typed_data';

import 'package:drawing_app/provider/paint_provider.dart';
import 'package:drawing_app/screens/paint.dart';
import 'package:drawing_app/utills/line_point.dart';
import 'package:drawing_app/utills/tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:gallery_saver/gallery_saver.dart';

class PaintingScreen extends StatefulWidget {

  const PaintingScreen({Key? key}) : super(key: key);

  @override
  State<PaintingScreen> createState() => _PaintingScreenState();
  
}

class _PaintingScreenState extends State<PaintingScreen>{

  Future<void> savePaintInDevice() async {
    ByteData? image = await Provider.of<PaintProvider>(context, listen: false).convertCanvasToImage();
    final Uint8List pngBytes = image!.buffer.asUint8List();

    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String fullPath = '$dir/${DateTime.now().millisecond}.png';
    File capturedFile = File(fullPath);
    await capturedFile.writeAsBytes(pngBytes);

    await GallerySaver.saveImage(capturedFile.path).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Drawing saved!'),
      ));
    });
  }

 @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 0), () {
      Provider.of<PaintProvider>(context, listen: false).changeSizeSelectorColor();
    });
  }
   @override
  Widget build(BuildContext context) {
    var viewportWidth = MediaQuery.of(context).size.width;
    List<Color>? lineColors = Provider.of<PaintProvider>(context).getLineColors;
    List<Color>? backgroundColors = Provider.of<PaintProvider>(context).getBackgroundColors;
    List<Tool>? toolsList = Provider.of<PaintProvider>(context).getToolsList;
    Color? selectedBackgroundColor = Provider.of<PaintProvider>(context).selectedBackgroundColor;
    Color? selectedLineColor = Provider.of<PaintProvider>(context).selectedLineColor;
    Tools? selectedTool = Provider.of<PaintProvider>(context).selectedTool;
    double? lineSize = Provider.of<PaintProvider>(context).lineSize;
    List<LinePoint>? points = Provider.of<PaintProvider>(context).points;
    Color? sizeSelectorColor = Provider.of<PaintProvider>(context).lineSizeColor;
    final panelActions = Provider.of<PaintProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            viewportWidth < 426
                ? Container(
                    height: 150,
                    width: double.infinity,
                    child: Row(
                      children: [
                        
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                                  child: Text('Actions'),
                                ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        panelActions.undoStroke();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black)),
                                        margin: const EdgeInsets.all(2),
                                        height: 35,
                                        width: 35,
                                        child: const Icon(Icons.undo, size: 22),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (points!.isNotEmpty) {
                                          // panelActions.convertCanvasToImage();

                                         await savePaintInDevice();
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black)),
                                        margin: const EdgeInsets.all(2),
                                        height: 35,
                                        width: 35,
                                        child: const Icon(Icons.save, size: 22),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        panelActions.redoStroke();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black)),
                                        margin: const EdgeInsets.all(2),
                                        height: 35,
                                        width: 35,
                                        child: const Icon(Icons.redo, size: 22),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                                  child: Text('Line Size'),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      child: Slider(
                                        value: lineSize!,
                                        onChanged: (newSize) {
                                          panelActions.changeLineSize = newSize;
                                        },
                                        activeColor: sizeSelectorColor,
                                        thumbColor: Colors.black,
                                        min: 1,
                                        max: 10,
                                        divisions: 9,
                                        label: "$lineSize",
                                      ),
                                      width: 150,
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(width: 10),
                        Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                                  child: Text('Color Choice'),
                                ),
                                Row(
                                  children: [
                                    ...lineColors!.map((color) {
                                      return GestureDetector(
                                        onTap: () {
                                          panelActions.changeLineColor = color;
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: color,
                                            border: selectedLineColor == color
                                                ? Border.all(color: color == Colors.black ? Colors.white : Colors.black, width: 3)
                                                : Border.all(color: color),
                                          ),
                                          margin: const EdgeInsets.all(2),
                                          height: selectedLineColor == color ? 25 : 20,
                                          width: selectedLineColor == color ? 25 : 20,
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ],
                            ),
                            
                          ],
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                                  child: Text('Tools'),
                                ),
                                Row(
                                  children: [
                                    ...toolsList!.map((tool) {
                                      return GestureDetector(
                                        onTap: () {
                                          panelActions.changeToolSelected = tool;
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: selectedTool == tool.tool ? Border.all(color: Colors.black, width: 4) : Border.all(color: Colors.white),
                                          ),
                                          margin: const EdgeInsets.all(4),
                                          padding: const EdgeInsets.all(4),
                                          height: 30,
                                          width: 30,
                                          child: SvgPicture.asset(
                                            tool.srcUrl!,
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    }).toList()
                                  ],
                                ),
                              ],
                            ),
                            
                          ],
                        ),
                      ],
                    ),
                  )
                : Container(
                    height: 150,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          
                            Column(
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        panelActions.undoStroke();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black)),
                                        margin: const EdgeInsets.all(4),
                                        height: 30,
                                        width: 30,
                                        child: const Icon(Icons.undo),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        panelActions.redoStroke();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black)),
                                        margin: const EdgeInsets.all(4),
                                        height: 30,
                                        width: 30,
                                        child: const Icon(Icons.redo),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        
                        const SizedBox(width: 10),
                        Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                  child: Text('Color'),
                                ),
                                Row(
                                  children: [
                                    ...lineColors!.map((color) {
                                      return GestureDetector(
                                        onTap: () {
                                          panelActions.changeLineColor = color;
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: color,
                                            border: selectedLineColor == color
                                                ? Border.all(color: color == Colors.black ? Colors.white : Colors.black, width: 3)
                                                : Border.all(color: color),
                                          ),
                                          margin: const EdgeInsets.all(4),
                                          height: selectedLineColor == color ? 30 : 25,
                                          width: selectedLineColor == color ? 30 : 25,
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                  child: Text('Background'),
                                ),
                                Row(
                                  children: [
                                    ...backgroundColors!.map((color) {
                                      return GestureDetector(
                                        onTap: () {
                                          panelActions.changeBackgroundColor = color;
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: color,
                                            border: selectedBackgroundColor == color
                                                ? Border.all(color: Colors.black, width: 3)
                                                : Border.all(color: color == Colors.white ? Colors.black : color),
                                          ),
                                          margin: const EdgeInsets.all(4),
                                          height: selectedBackgroundColor == color ? 30 : 25,
                                          width: selectedBackgroundColor == color ? 30 : 25,
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                  child: Text('Line Size'),
                                ),
                                Row(
                                  children: [
                                    Slider(
                                      value: lineSize!,
                                      onChanged: (newSize) {
                                        panelActions.changeLineSize = newSize;
                                      },
                                      activeColor: sizeSelectorColor,
                                      thumbColor: Colors.black,
                                      min: 1,
                                      max: 10,
                                      divisions: 9,
                                      label: "$lineSize",
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                  child: Text('Tools'),
                                ),
                                Row(
                                  children: [
                                    ...toolsList!.map((tool) {
                                      return GestureDetector(
                                        onTap: () {
                                          panelActions.changeToolSelected = tool;
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: selectedTool == tool.tool ? Border.all(color: Colors.black, width: 3) : Border.all(color: Colors.white),
                                          ),
                                          margin: const EdgeInsets.all(4),
                                          padding: const EdgeInsets.all(4),
                                          height: 30,
                                          width: 30,
                                          child: SvgPicture.asset(
                                            tool.srcUrl!,
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    }).toList()
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
            const Expanded(
              child: Paint(),
            ),
          ],
        ),
      ),
    );
  }

}

