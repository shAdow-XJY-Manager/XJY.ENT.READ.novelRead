@TestOn('browser')
library;

import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novel_read/frequency/web_entry.dart';

const book = NovelBook('test-book', '测试书', '本地测试文本', [
  NovelChapter('later-id', '第一章', '第一段正文。\n\n保留空行与标点。'),
  NovelChapter('earlier-id', '第二章', '第二段正文，不按 ID 排序。'),
]);
const progressKey = 'frequency.novel.progress.test-book';

void clearStorage() {
  for (final key in html.window.localStorage.keys.toList()) {
    if (key.startsWith('frequency.novel.'))
      html.window.localStorage.remove(key);
  }
}

Future<void> mount(WidgetTester tester, Widget widget) async {
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    clearStorage();
    await tester.binding.setSurfaceSize(null);
  });
  await tester.pumpWidget(widget);
  await tester.pumpAndSettle();
}

void main() {
  setUp(clearStorage);

  test('书目 JSON 往返保留章节顺序和完整正文', () {
    final restored = NovelBook.fromJson(
      jsonDecode(jsonEncode(book.toJson())) as Map<String, dynamic>,
    );
    expect(restored.toJson(), book.toJson());
    expect(restored.chapters.map((chapter) => chapter.id), [
      'later-id',
      'earlier-id',
    ]);
    expect(restored.chapters.first.text, '第一段正文。\n\n保留空行与标点。');
  });

  for (final width in [390.0, 768.0, 1280.0]) {
    testWidgets('文字阅览入口在 ${width.toInt()}px 显示真实书目', (tester) async {
      await tester.binding.setSurfaceSize(Size(width, 900));
      await mount(tester, const NovelApp());
      expect(find.text('文字阅览'), findsOneWidget);
      expect(find.text('夜班频率'), findsOneWidget);
      expect(find.text('章节目录'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('查找书目无结果后可以恢复原书目', (tester) async {
    await mount(tester, const NovelApp());
    await tester.enterText(find.byType(TextField), '不存在的书目');
    await tester.pump();
    expect(find.text('没有匹配的书目。换一个词，或导入 TXT 文件。'), findsOneWidget);
    expect(find.text('夜班频率'), findsNothing);
    await tester.enterText(find.byType(TextField), '夜班');
    await tester.pump();
    expect(find.text('夜班频率'), findsOneWidget);
  });

  testWidgets('续读按章节 ID 恢复并在翻章后写入真实进度', (tester) async {
    html.window.localStorage[progressKey] = jsonEncode({
      'chapter': 'earlier-id',
      'fraction': 0,
      'size': 24,
    });
    await mount(tester, const MaterialApp(home: NovelRead(book: book)));
    expect(find.text('2 / 2 章'), findsOneWidget);
    expect(find.text(book.chapters.last.text), findsOneWidget);
    expect(find.text('24 px'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, '已读到末章'))
          .onPressed,
      isNull,
    );
    await tester.tap(find.text('上一章'));
    await tester.pump();
    expect(find.text('1 / 2 章'), findsOneWidget);
    expect(find.text(book.chapters.first.text), findsOneWidget);
    final saved = jsonDecode(html.window.localStorage[progressKey]!);
    expect(saved['chapter'], 'later-id');
    expect(saved['fraction'], 0);
    expect(saved['size'], 24);
    expect(
      tester
          .widget<OutlinedButton>(find.widgetWithText(OutlinedButton, '上一章'))
          .onPressed,
      isNull,
    );
  });

  testWidgets('目录筛选后仍打开原章节索引', (tester) async {
    await mount(
      tester,
      const MaterialApp(home: NovelRead(book: book, showDirectory: true)),
    );
    await tester.enterText(find.byType(TextField), '第二');
    await tester.pump();
    final chapter = find.widgetWithText(ListTile, '第二章');
    expect(chapter, findsOneWidget);
    expect(find.widgetWithText(ListTile, '第一章'), findsNothing);
    await tester.tap(chapter);
    await tester.pumpAndSettle();
    expect(find.text('2 / 2 章'), findsOneWidget);
    expect(find.text(book.chapters.last.text), findsOneWidget);
  });

  testWidgets('损坏进度保留原数据且正文仍可读', (tester) async {
    html.window.localStorage[progressKey] = '{broken';
    await mount(tester, const MaterialApp(home: NovelRead(book: book)));
    expect(find.text('本地进度未能读取，从第一章开始。'), findsOneWidget);
    expect(find.text(book.chapters.first.text), findsOneWidget);
    expect(html.window.localStorage[progressKey], '{broken');
  });

  for (final value in [17, 29]) {
    testWidgets('恢复 $value px 后字号操作仍限制在 16 至 30 px', (tester) async {
      html.window.localStorage[progressKey] = jsonEncode({
        'chapter': 'later-id',
        'fraction': 0,
        'size': value,
      });
      await mount(tester, const MaterialApp(home: NovelRead(book: book)));
      await tester.tap(find.byTooltip(value == 17 ? '缩小字号' : '放大字号'));
      await tester.pump();
      expect(find.text(value == 17 ? '16 px' : '30 px'), findsOneWidget);
      final saved = jsonDecode(html.window.localStorage[progressKey]!);
      expect(saved['size'], value == 17 ? 16 : 30);
    });
  }

  testWidgets('空书目显示明确状态', (tester) async {
    await mount(
      tester,
      const MaterialApp(
        home: NovelRead(book: NovelBook('empty', '空书', '测试', [])),
      ),
    );
    expect(find.text('这本书还没有章节。'), findsOneWidget);
    expect(find.text('下一章'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
