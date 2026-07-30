import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'dart:io';

typedef GetStringC = ffi.Pointer<Utf8> Function();

typedef GetStringDart = ffi.Pointer<Utf8> Function();

class FFIHelper {
  static String fetchStringFromC() {
    final ffi.DynamicLibrary lib = Platform.isAndroid
        ? ffi.DynamicLibrary.open('libnative_lib.so')
        : ffi.DynamicLibrary.process();

    final getMyString = lib
        .lookup<ffi.NativeFunction<GetStringC>>('get_my_string')
        .asFunction<GetStringDart>();

    final ffi.Pointer<Utf8> pointer = getMyString();

    final String myDartString = pointer.toDartString();

    return myDartString;
  }
}
