import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'browser_io.dart';

void start() => runApp(const NovelApp());

class NovelChapter {
  final String id, title, text;
  const NovelChapter(this.id, this.title, this.text);
  Map<String, String> toJson() => {'id': id, 'title': title, 'text': text};
}

class NovelBook {
  final String id, title, source;
  final List<NovelChapter> chapters;
  const NovelBook(this.id, this.title, this.source, this.chapters);
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'source': source,
    'chapters': chapters.map((c) => c.toJson()).toList(),
  };
  factory NovelBook.fromJson(Map<String, dynamic> j) => NovelBook(
    j['id'] as String,
    j['title'] as String,
    j['source'] as String,
    (j['chapters'] as List)
        .map(
          (c) => NovelChapter(
            c['id'] as String,
            c['title'] as String,
            c['text'] as String,
          ),
        )
        .toList(),
  );
}

const sample = NovelBook('frequency-night-v1', '夜班频率', '原创阅读样例 · 三章短篇', [
  NovelChapter(
    'window',
    '01 · 留一扇亮着的窗',
    '''凌晨一点，街上的店都关了。只有旧修理铺的窗还亮着，灯光在湿漉漉的路面上铺成一条窄窄的路。

林在桌上放下一台收音机。木壳的一角磨得发白，旋钮旁贴着一张纸，上面只有四个字：慢慢调谐。

她不太会修机器。她擅长的是听：哪一页纸被翻过去了，谁在门外停了一会儿，雨落在铁皮上的轻重。她觉得声音总比人先抵达一间屋子。

收音机是外公留下的。白天，她拆开后盖，里面没有灰尘，只有一颗松动的螺丝。她小心把螺丝收进玻璃瓶，像收起一颗没有人认领的星星。

旋钮转过半圈，沙沙声突然变轻。一阵短促的敲击从扬声器里传出来：三下，一下，三下。

窗外没有人。林把灯调暗，看见一只极小的飞蛾停在玻璃上。它的翅膀泛着淡黄色，像纸张被灯光透过。雨水沿着窗滑下，它却一直停在那里。

林轻轻敲了敲桌面。三下，一下，三下。

飞蛾的翅膀开合了一次。收音机里传来一种更远的声音，好像有人在山顶展开一张巨大的地图。

她把窗推开一点。夜风带来潮湿的树叶气味，也把桌上的纸吹到地上。纸背面有外公以前写的一句话：听见的时候，先别急着解释。

于是她坐下来，听完整段沙沙声。那声音并没有告诉她任何答案。可她突然发现，自己已经很久没有这样安静地坐过了。''',
  ),
  NovelChapter(
    'roof',
    '02 · 城市的另一种刻度',
    '''第二天夜里，林又打开收音机。飞蛾没有来，敲击声却准时出现。她把每次间隔记在笔记本上，慢慢发现它们与街角的红绿灯并不同步。

城市总有一套自己的刻度。公交车、闹钟、账单和电梯，把一天切成整齐的小块。那段声音却不着急，像在等她自己找到一个可以停下的地方。

她顺着声音走到屋顶。楼梯很窄，扶手冰凉。每向上一层，收音机里的沙沙声就变得更清晰一点。

屋顶有几只空花盆。林小时候来过这里，那时外公种薄荷，说它们最会把夏天记住。后来花盆空了，屋顶也很少有人上来。

飞蛾停在水塔边。它不是普通的虫子：翅膀上有细细的金属纹路，腹部藏着一盏暖色小灯。它并不怕她，只在她靠近时缓慢后退。

林没有追。她坐到花盆旁边，把收音机放在膝上。天边出现第一道浅灰色。那些整晚没有睡的窗，一扇一扇暗下去。

她忽然明白，声音不是一封要她破解的信。它只是让她离开桌子，来到这里。

外公说过，有些机器修好了，就会继续工作；有些修好了，会提醒你什么时候该休息。

飞蛾在微亮的天色里画了一个小小的圆。扬声器安静下来。林抬头，看见城市的轮廓第一次没有被通知和时间表填满。

她把那个空花盆搬近了一点，计划白天去买一株薄荷。''',
  ),
  NovelChapter(
    'morning',
    '03 · 写下今天',
    '''天亮以后，修理铺的门开了。有人送来坏掉的台灯，有人只是借一把伞。林把收音机放在窗边，它又变回一台普通的旧机器。

她在笔记本上写：昨夜听见一只飞蛾。

这句话不够准确。也许她听见的是楼里的风，也许只是电路上某个接触不良的地方。她又写：昨夜我终于走上了屋顶。

第二句更接近事实。她决定暂时把两句都留下。写作有时候不是马上找出哪一句正确，而是给事情留下一个还能重新看见的位置。

中午，邻居带来一盆薄荷。她没有讲飞蛾的事，只说屋顶缺一点绿色。邻居点头，说那里应该再放一张椅子。

傍晚，玻璃瓶里那颗螺丝映着灯光。林没有把它拧回去。收音机现在工作得很好，她想先查清楚它原本属于哪里。

她给每一件待修的物品贴上纸签，写下名字、日期、问题，以及已经做过的事情。纸签让她少猜测，也让别人能接着往下做。

夜里一点，窗依旧亮着。林把灯调暗，合上笔记本。远处有一辆车驶过，轮胎压过积水，发出很轻的声响。

她不再等待敲击声，也没有把旋钮固定在某个神秘的频率。她给自己留了一把椅子，给窗外留了一点空间。

在那空间里，一天缓缓结束。另一天尚未开始。她觉得这样就很好。''',
  ),
]);

class NovelApp extends StatelessWidget {
  const NovelApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: '文字阅览 · 频率站',
    debugShowCheckedModeBanner: false,
    theme: FrequencyTheme.dark(),
    home: const NovelShelf(),
  );
}

class NovelShelf extends StatefulWidget {
  const NovelShelf({super.key});
  @override
  State<NovelShelf> createState() => _NovelShelfState();
}

class _NovelShelfState extends State<NovelShelf> {
  final books = <NovelBook>[sample];
  String query = '', error = '';
  @override
  void initState() {
    super.initState();
    try {
      final raw = readLocal('frequency.novel.books.v1');
      if (raw != null)
        books.addAll(
          (jsonDecode(raw) as List).map(
            (j) => NovelBook.fromJson(j as Map<String, dynamic>),
          ),
        );
    } catch (_) {
      error = '本地书目未能读取。现有数据已保留，可重新导入文本。';
    }
  }

  Future<void> importBook() async {
    try {
      final file = await pickFile('.txt,text/plain');
      if (file == null || !mounted) return;
      final text = utf8.decode(file.bytes).replaceFirst('\uFEFF', '').trim();
      if (text.isEmpty) throw StateError('文本为空');
      final lines = text.split('\n');
      final chapters = <NovelChapter>[];
      String heading = '正文';
      final content = <String>[];
      void flush() {
        final body = content.join('\n').trim();
        if (body.isNotEmpty)
          chapters.add(NovelChapter('${chapters.length}', heading, body));
        content.clear();
      }

      for (final line in lines) {
        if (RegExp(
              r'^\s*(第\s*[0-9零〇一二三四五六七八九十百千万两]+\s*[章节回卷](?:\s|$)|Chapter\s+\d+(?:\s|$))',
              caseSensitive: false,
            ).hasMatch(line) &&
            line.length < 100) {
          flush();
          heading = line.trim();
        } else {
          content.add(line);
        }
      }
      flush();
      if (chapters.isEmpty) throw StateError('没有可阅读的正文');
      final book = NovelBook(
        'import-${DateTime.now().microsecondsSinceEpoch}',
        file.name.replaceFirst(RegExp(r'\.txt$', caseSensitive: false), ''),
        '你的本地文本 · ${chapters.length} 章',
        chapters,
      );
      final next = [...books, book];
      writeLocal(
        'frequency.novel.books.v1',
        jsonEncode(
          next.where((b) => b.id != sample.id).map((b) => b.toJson()).toList(),
        ),
      );
      setState(() {
        books.add(book);
        error = '';
      });
    } catch (e) {
      if (mounted) setState(() => error = '导入失败：$e。原有书目未改变。');
    }
  }

  Map<String, dynamic>? progress(NovelBook b) {
    try {
      final raw = readLocal('frequency.novel.progress.${b.id}');
      return raw == null ? null : jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> open(NovelBook book, {bool directory = false}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NovelRead(book: book, showDirectory: directory),
      ),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final filtered = books
        .where((b) => b.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    final compact = MediaQuery.sizeOf(context).width < 700;
    return Scaffold(
      appBar: AppBar(
        title: const Text('文字阅览'),
        actions: [
          TextButton.icon(
            onPressed: importBook,
            icon: const Icon(Icons.file_open_outlined),
            label: const Text('导入 TXT'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: ListView(
            padding: EdgeInsets.all(compact ? 20 : 32),
            children: [
              const Text(
                '频率站 / 阅读',
                style: TextStyle(
                  color: FrequencyPalette.accent,
                  fontSize: 12,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '回到你的书页',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '选一本继续读，或导入自己的文本。',
                style: TextStyle(color: FrequencyPalette.muted),
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: const InputDecoration(
                  labelText: '查找书目',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (v) => setState(() => query = v),
              ),
              if (error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Semantics(
                    liveRegion: true,
                    child: Text(
                      error,
                      style: const TextStyle(color: FrequencyPalette.error),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              Text(
                '我的书目 · ${filtered.length}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              if (filtered.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('没有匹配的书目。换一个词，或导入 TXT 文件。'),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: importBook,
                        icon: const Icon(Icons.file_open_outlined),
                        label: const Text('导入 TXT'),
                      ),
                    ],
                  ),
                ),
              for (final book in filtered) _bookRow(book),
              const SizedBox(height: 20),
              const Text(
                '书目与阅读进度保存在本浏览器。',
                style: TextStyle(color: FrequencyPalette.muted, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bookRow(NovelBook book) => Container(
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: FrequencyPalette.border)),
    ),
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: LayoutBuilder(
      builder: (context, box) {
        final reading = progress(book) != null;
        final details = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: FrequencyPalette.selected,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.menu_book_outlined,
                color: FrequencyPalette.accent,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${book.source} · ${book.chapters.length} 章',
                    style: const TextStyle(
                      color: FrequencyPalette.muted,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
        final actions = Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              onPressed: () => open(book),
              icon: const Icon(Icons.arrow_forward),
              label: Text(reading ? '继续阅读' : '开始阅读'),
            ),
            TextButton.icon(
              onPressed: () => open(book, directory: true),
              icon: const Icon(Icons.format_list_bulleted),
              label: const Text('章节目录'),
            ),
          ],
        );
        if (box.maxWidth < 740 ||
            MediaQuery.textScalerOf(context).scale(16) > 24) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [details, const SizedBox(height: 16), actions],
          );
        }
        return Row(
          children: [
            Expanded(child: details),
            const SizedBox(width: 24),
            actions,
          ],
        );
      },
    ),
  );
}

class NovelRead extends StatefulWidget {
  final NovelBook book;
  final bool showDirectory;
  const NovelRead({super.key, required this.book, this.showDirectory = false});
  @override
  State<NovelRead> createState() => _NovelReadState();
}

class _NovelReadState extends State<NovelRead> {
  bool exiting = false;
  final scroll = ScrollController();
  final scaffold = GlobalKey<ScaffoldState>();
  Timer? debounce;
  int index = 0;
  double size = 20;
  double savedFraction = 0;
  String query = '', status = '';
  @override
  void initState() {
    super.initState();
    double fraction = 0;
    try {
      final raw = readLocal(key);
      if (raw != null) {
        final p = jsonDecode(raw);
        final found = widget.book.chapters.indexWhere(
          (c) => c.id == p['chapter'],
        );
        if (found >= 0) {
          index = found;
          fraction = (p['fraction'] as num? ?? 0).toDouble().clamp(0, 1);
        } else {
          status = '原章节已变动，请从目录重新选择。';
        }
        size = (p['size'] as num? ?? 20).toDouble().clamp(16, 30);
      }
    } catch (_) {
      status = '本地进度未能读取，从第一章开始。';
    }
    savedFraction = fraction;
    scroll.addListener(() {
      cachePosition();
      debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 400), save);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (scroll.hasClients)
        scroll.jumpTo(scroll.position.maxScrollExtent * fraction);
      if (widget.showDirectory) scaffold.currentState?.openDrawer();
    });
  }

  String get key => 'frequency.novel.progress.${widget.book.id}';
  void cachePosition() {
    if (scroll.hasClients) {
      final max = scroll.position.maxScrollExtent;
      savedFraction = max > 0 ? (scroll.offset / max).clamp(0, 1) : 0;
    }
  }

  void save() {
    if (widget.book.chapters.isEmpty) return;
    try {
      cachePosition();
      writeLocal(
        key,
        jsonEncode({
          'chapter': widget.book.chapters[index].id,
          'fraction': savedFraction,
          'size': size,
        }),
      );
    } catch (_) {
      if (mounted && !exiting && status.isEmpty)
        setState(() => status = '进度保存失败。正文仍可阅读，本次位置可能无法恢复。');
    }
  }

  void select(int next) {
    if (next < 0 || next >= widget.book.chapters.length) return;
    debounce?.cancel();
    setState(() {
      index = next;
      savedFraction = 0;
    });
    if (scroll.hasClients) scroll.jumpTo(0);
    save();
  }

  @override
  void dispose() {
    exiting = true;
    debounce?.cancel();
    save();
    scroll.dispose();
    super.dispose();
  }

  Widget directory() => SafeArea(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(widget.book.title, style: const TextStyle(fontSize: 24)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: const InputDecoration(
              labelText: '查找章节',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (v) => setState(() => query = v),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView(
            children: [
              for (int i = 0; i < widget.book.chapters.length; i++)
                if (widget.book.chapters[i].title.contains(query))
                  ListTile(
                    selected: index == i,
                    leading: index == i
                        ? const Icon(Icons.play_arrow)
                        : const Icon(Icons.article_outlined),
                    title: Text(widget.book.chapters[i].title),
                    onTap: () {
                      select(i);
                      if (scaffold.currentState?.isDrawerOpen ?? false)
                        Navigator.pop(context);
                    },
                  ),
            ],
          ),
        ),
      ],
    ),
  );
  @override
  Widget build(BuildContext context) {
    if (widget.book.chapters.isEmpty)
      return Scaffold(
        appBar: AppBar(title: Text(widget.book.title)),
        body: const Center(child: Text('这本书还没有章节。')),
      );
    final chapter = widget.book.chapters[index];
    return Scaffold(
      key: scaffold,
      drawer: Drawer(child: directory()),
      appBar: AppBar(
        leading: IconButton(
          tooltip: '返回书目',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(widget.book.title),
        actions: [
          IconButton(
            tooltip: '章节目录',
            onPressed: () => scaffold.currentState?.openDrawer(),
            icon: const Icon(Icons.format_list_bulleted),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              children: [
                Text('${index + 1} / ${widget.book.chapters.length} 章'),
                IconButton(
                  tooltip: '缩小字号',
                  onPressed: size > 16
                      ? () {
                          setState(() => size = (size - 2).clamp(16, 30));
                          save();
                        }
                      : null,
                  icon: const Icon(Icons.text_decrease),
                ),
                Text('${size.round()} px'),
                IconButton(
                  tooltip: '放大字号',
                  onPressed: size < 30
                      ? () {
                          setState(() => size = (size + 2).clamp(16, 30));
                          save();
                        }
                      : null,
                  icon: const Icon(Icons.text_increase),
                ),
              ],
            ),
          ),
          if (status.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                status,
                style: const TextStyle(color: FrequencyPalette.amber),
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              controller: scroll,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      MediaQuery.sizeOf(context).width < 700 ? 20 : 32,
                      24,
                      MediaQuery.sizeOf(context).width < 700 ? 20 : 32,
                      48,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chapter.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 32),
                        SelectableText(
                          chapter.text.isEmpty ? '这一章暂无正文。' : chapter.text,
                          style: TextStyle(fontSize: size, height: 1.8),
                        ),
                        const SizedBox(height: 48),
                        const Center(
                          child: Text(
                            '— 本章完 —',
                            style: TextStyle(color: FrequencyPalette.muted),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: index > 0 ? () => select(index - 1) : null,
                      icon: const Icon(Icons.chevron_left),
                      label: const Text('上一章'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: index < widget.book.chapters.length - 1
                          ? () => select(index + 1)
                          : null,
                      icon: const Icon(Icons.chevron_right),
                      label: Text(
                        index == widget.book.chapters.length - 1
                            ? '已读到末章'
                            : '下一章',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
