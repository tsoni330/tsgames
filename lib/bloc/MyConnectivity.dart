import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';

class MyConnectivity {
  MyConnectivity._internal();

  static final MyConnectivity? _instance = MyConnectivity._internal();

  static MyConnectivity? get instance => _instance;

  Connectivity? connectivity;

  // ignore: close_sinks
  StreamController? controller = StreamController.broadcast();

  Stream get myStream => controller!.stream;
  Sink get mySink => controller!.sink;

  void initialise() async {
    connectivity = Connectivity();
    ConnectivityResult result = await connectivity!.checkConnectivity();
    _checkStatus(result);
    connectivity!.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }


  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else
        isOnline = false;
    } on SocketException catch (_) {
      isOnline = false;
    }
    if(!controller!.isClosed){
      mySink.add({result: isOnline});
    }
  }


  void dispose() async{

    await controller!.close();

  }
}