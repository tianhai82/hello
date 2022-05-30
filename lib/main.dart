// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello/provider/myprovider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatelessWidget {
  RandomWords({Key? key}) : super(key: key);

  final _suggestions = <WordPair>[];

  void _pushSaved(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (context) {
        return const Saved();
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => _pushSaved(context),
            tooltip: 'Saved Suggestions',
          ),
        ],
      ),
      body: Consumer(builder: (context, ref, child) {
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemBuilder: /*1*/ (context, i) {
            final saved = ref.watch(wordPairProvider);
            final biggerFont = ref.read(bigFontProvider);

            if (i >= _suggestions.length) {
              _suggestions.addAll(generateWordPairs().take(10)); /*4*/
            }

            final alreadySaved = saved.contains(_suggestions[i]);

            return Column(
              children: [
                ListTile(
                  title: Text(
                    _suggestions[i].asPascalCase,
                    style: biggerFont,
                  ),
                  trailing: Icon(
                    alreadySaved ? Icons.favorite : Icons.favorite_border,
                    color: alreadySaved ? Colors.red : null,
                    semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
                  ),
                  onTap: () {
                    if (alreadySaved) {
                      saved.remove(_suggestions[i]);
                    } else {
                      saved.add(_suggestions[i]);
                    }
                  },
                ),
                const Divider(),
              ],
            );
          },
        );
      }),
    );
  }
}

class Saved extends ConsumerWidget {
  const Saved({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordPairWatcher = ref.watch(wordPairProvider);
    final biggerFont = ref.read(bigFontProvider);
    final tiles = wordPairWatcher.map(
      (pair) {
        return ListTile(
          title: Text(
            pair.asPascalCase,
            style: biggerFont,
          ),
          trailing: const Icon(
            Icons.delete,
            semanticLabel: 'Remove from saved',
          ),
          onTap: () {
            ref.read(wordPairProvider.notifier).remove(pair);
          },
        );
      },
    );
    final divided = tiles.isNotEmpty
        ? ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList()
        : <Widget>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Suggestions'),
      ),
      body: ListView(children: divided),
    );
  }
}
