// import 'dart:convert';
// import 'package:web_socket_channel/io.dart';
//
// class WebsocketUtil{
//   static final WebsocketUtil _instance = WebsocketUtil._internal();
//   IOWebSocketChannel? _channel;
//
//   factory WebsocketUtil() {
//     return _instance;
//   }
//
//   WebsocketUtil._internal();
//
//   Future<void> open(token) async {
//
//     _channel = IOWebSocketChannel.connect('$serverUrl?Token=$token');
//
//     _channel!.stream.listen((message) {
//       final json = jsonDecode(message);
//       final msgModule = json['msgModule'];
//       switch (msgModule) {
//         case 'fileManage':
//           fileManageModule(json);
//           break;
//         case 'clipboard':
//           clipboardModule(json);
//           break;
//         default:
//           print('Unknown msgModule: $msgModule');
//           break;
//       }
//     });
//   }
//
//   void send(msg) {
//     _channel?.sink.add(msg);
//   }
//
//   void close() {
//     _channel?.sink.close();
//   }
//
// }