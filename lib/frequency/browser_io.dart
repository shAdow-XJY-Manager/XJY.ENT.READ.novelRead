import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

class PickedFile {
  final String name;
  final List<int> bytes;
  const PickedFile(this.name, this.bytes);
}

String? readLocal(String key) => html.window.localStorage[key];
void writeLocal(String key, String value) {
  html.window.localStorage[key] = value;
  if (html.window.localStorage[key] != value) {
    throw StateError('本浏览器未能保存数据');
  }
}
void removeLocal(String key) => html.window.localStorage.remove(key);

Future<PickedFile?> pickFile(String accept, {int maxBytes = 20 * 1024 * 1024}) async {
  final input = html.FileUploadInputElement()..accept = accept;
  input.style.display = 'none';
  html.document.body?.append(input);
  final result = Completer<PickedFile?>();
  StreamSubscription<html.Event>? focus;
  StreamSubscription<html.Event>? change;
  change = input.onChange.listen((_) async {
    final files = input.files;
    if (files == null || files.isEmpty) {
      if (!result.isCompleted) result.complete(null);
      return;
    }
    final file = files.first;
    if (file.size > maxBytes) {
      if (!result.isCompleted) result.completeError(StateError('文件超过 ${maxBytes ~/ (1024 * 1024)} MB 限制'));
      return;
    }
    try {
      final reader = html.FileReader();
      final done = Completer<List<int>>();
      final loaded = reader.onLoad.listen((_) {
        if (done.isCompleted) return;
        try {
          final bytes = reader.result;
          if (bytes is ByteBuffer) {
            done.complete(bytes.asUint8List());
          } else if (bytes is List<int>) {
            done.complete(bytes);
          } else {
            throw StateError('文件读取结果不是字节数据');
          }
        } catch (error) {
          done.completeError(error);
        }
      });
      final failed = reader.onError.listen((_) {
        if (!done.isCompleted) done.completeError(StateError('浏览器未能读取文件'));
      });
      reader.readAsArrayBuffer(file);
      late final List<int> bytes;
      try { bytes = await done.future; }
      finally { await loaded.cancel(); await failed.cancel(); }
      if (!result.isCompleted) result.complete(PickedFile(file.name, bytes));
    } catch (error) {
      if (!result.isCompleted) result.completeError(error);
    }
  });
  focus = html.window.onFocus.listen((_) {
    Future<void>.delayed(const Duration(milliseconds: 500), () {
      if (!result.isCompleted && (input.files == null || input.files!.isEmpty)) result.complete(null);
    });
  });
  input.click();
  try {
    return await result.future;
  } finally {
    await change.cancel();
    await focus.cancel();
    input.remove();
  }
}

void downloadBytes(String name, List<int> bytes, String type) {
  final blob = html.Blob([Uint8List.fromList(bytes)], type);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)..download = name;
  html.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
  Future<void>.delayed(const Duration(seconds: 2), () => html.Url.revokeObjectUrl(url));
}
