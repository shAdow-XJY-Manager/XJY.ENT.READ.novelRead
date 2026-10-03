import 'frequency/native_entry.dart' if (dart.library.html) 'frequency/web_entry.dart' as entry;
export 'frequency/native_entry.dart' if (dart.library.html) 'frequency/web_entry.dart';

void main() => entry.start();
