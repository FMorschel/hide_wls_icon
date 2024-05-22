import 'dart:ffi';

import 'package:ffi/ffi.dart';

class MessageBox {
  static final _user32 = DynamicLibrary.open('user32.dll');

  static final _messageBox = _user32.lookupFunction<
      Int32 Function(IntPtr hWnd, Pointer<Utf16> lpText,
          Pointer<Utf16> lpCaption, Uint32 uType),
      int Function(int hWnd, Pointer<Utf16> lpText, Pointer<Utf16> lpCaption,
          int uType)>('MessageBoxW');

  int show({required String title, required String text, int type = 0}) {
    final lpText = text.toNativeUtf16();
    final lpCaption = title.toNativeUtf16();
    final result = _messageBox(0, lpText, lpCaption, type);
    calloc.free(lpText);
    calloc.free(lpCaption);
    return result;
  }
}
