
import 'dart:async';

class AnimationBloc{
  
  // ignore: close_sinks
  StreamController? _streamController = StreamController.broadcast();
  
  Stream get blocStream => _streamController!.stream;
  Sink get blocSink => _streamController!.sink;

  void dispose(){
    _streamController!.close();
  }
}