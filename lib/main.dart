import 'dart:async';
//import 'dart:html';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/rendering.dart';
//import 'package:wc_flutter_share/wc_flutter_share.dart';
//import 'package:wc_flutter_share/wc_flutter_share.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;
  GlobalKey _globalKey = new GlobalKey();
  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  // ignore: missing_return
  Future<Uint8List> _capturePng() async {
    try {
      print('inside');
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      // ignore: unnecessary_cast
      ByteData byteData = await (image.toByteData(
          format: ui.ImageByteFormat.png) as FutureOr<ByteData>);
      if (byteData != null) {
        final res =
            await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
        var ress = res.toString();
        print(ress);
        Fluttertoast.showToast(msg: "QR Code Saved in Gallery");
      }
      var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      print(pngBytes);
      print(bs64);
      setState(() {});
      //return pngBytes;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: RepaintBoundary(key: _globalKey, child: QRView())),
            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _capturePng,
        tooltip: 'Increment',
        child: Icon(Icons.save),
      ),
    );
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> status = await [
      Permission.storage,
    ].request();
    final info = status[Permission.storage].toString();
    print(info);
    //Fluttertoast.showToast(msg: info);
  }
}

class QRView extends StatefulWidget {
  @override
  _QRViewState createState() => _QRViewState();
}

class _QRViewState extends State<QRView> {
  String qrData = "Saaample QRCODE";
  @override
  Widget build(BuildContext context) {
    
    return Material(
      color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Container(
                    width: 280,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        QrImage(
                          //plce where the QR Image will be shown
                          data: qrData,
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
}
