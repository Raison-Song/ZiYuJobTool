
import 'dart:async';

import 'package:process_run/shell.dart';
import 'dart:ffi';
import 'dart:io' show Platform;
import 'package:ffi/ffi.dart';

import '../module/clipboardModule/ListenClipboard.dart';



void openFile(String filename) {
  var shell = Shell();
  shell.run("C:\\Users\\33041\\Desktop\\毕业设计.docx");
}
void main() async {
  print(111);

  ClipboardMonitor monitor = ClipboardMonitor();
  print(111);
// 开始监控
  monitor.start(interval: 10);
  print(111);
// 监听剪贴板变化
  StreamSubscription<String> subscription =
  monitor.clipboardStream.listen((String data) {
    print("Clipboard content changed: $data");
  });
  print(22);
// // 停止监控
//   monitor.stop();
//
// // 取消监听
//   subscription.cancel();
//
// // 销毁资源
//   monitor.dispose();

}
