import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

class AllowMultipleGestureRecognizerForPageView extends OneSequenceGestureRecognizer {
  final Function leftPage;
  final Function rightPage;
  final double width;

  double _countMoves=0;
  AllowMultipleGestureRecognizerForPageView(this.width,this.leftPage,this.rightPage);

  @override
  void addPointer(PointerEvent event) {
    if (event is PointerDownEvent && (event.position.dx<40 || (width - event.position.dx)<40)) {
      startTrackingPointer(event.pointer);
      resolve(GestureDisposition.accepted);
    } else if(event is PointerUpEvent){
      _countMoves=0;
      stopTrackingPointer(event.pointer);
    }
  }
  @override
  void handleEvent(PointerEvent event) {
    if (event.position.dx<40) {
      if (event is PointerMoveEvent&&event.delta.dx>3) {
        _countMoves++;
        if(_countMoves>20){
          leftPage.call();
        }
      }
    } else if (width-event.position.dx<40) {
      if (event is PointerMoveEvent&&event.delta.dx<-3) {
        _countMoves++;
        if(_countMoves>20){
          rightPage.call();
        }
      }

    }
  }


  @override
  String get debugDescription => 'customPan';

  @override
  void didStopTrackingLastPointer(int pointer) {}

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }
}