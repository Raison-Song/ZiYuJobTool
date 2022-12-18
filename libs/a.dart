import 'dart:ffi' as ffi;

import 'dart:io' show Platform, Directory;
import 'package:path/path.dart' as path;

typedef hello_world_func = ffi.Void Function();
typedef HelloWorld = void Function();


void main(){
  var libraryPath = path.join(Directory.current.path, 'hello_library',
      'libhello.so');
  if (Platform.isMacOS) {
    libraryPath = path.join(Directory.current.path, 'hello_library',
        'libhello.dylib');
  } else if (Platform.isWindows) {
    libraryPath = path.join(Directory.current.path, 'hello_library',
        'Debug', 'hello.dll');
  }
  final dylib = ffi.DynamicLibrary.open(libraryPath);

  final HelloWorld hello = dylib
      .lookup<ffi.NativeFunction<hello_world_func>>('hello_world')
      .asFunction();

  hello();
}