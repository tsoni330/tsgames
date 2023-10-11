
import 'dart:async';

class MsgBloc{

  StreamController streamController = StreamController.broadcast();

  Stream get blocStream =>streamController.stream;
  Sink get blocSink => streamController.sink;

  void dispose(){
    streamController.close();
  }
}