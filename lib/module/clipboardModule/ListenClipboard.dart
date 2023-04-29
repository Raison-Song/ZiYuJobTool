import 'dart:async';
import 'package:flutter/services.dart';

class ClipboardMonitor {
  static const int DEFAULT_INTERVAL = 10; // 默认检查间隔为10秒

  final _clipboardStreamController =
  StreamController<String>.broadcast(); //创建stream控制器

  Timer? _timer; //创建定时器对象

  Stream<String> get clipboardStream => _clipboardStreamController.stream;

  void start({int interval = DEFAULT_INTERVAL})  {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: interval), (_) async {
      ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
      if (data != null) {
        _clipboardStreamController.add(data.text.toString());
      }
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    _clipboardStreamController.close();
  }
}
