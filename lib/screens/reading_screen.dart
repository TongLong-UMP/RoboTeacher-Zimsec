import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ReadingScreen extends StatefulWidget {
  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  List<String> learningFiles = [
    'General',
    'Animals',
    'Days',
    'Numbers',
  ];
  int selectedFileIndex = 0;

  List<dynamic> vocabulary = [];
  bool isLoading = true;
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _loadVocabulary();
  }

  Future<void> _loadVocabulary() async {
    setState(() => isLoading = true);
    final String jsonString =
        await rootBundle.loadString('assets/vocabulary_list.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    setState(() {
      vocabulary = data['vocabulary'] ?? [];
      isLoading = false;
    });
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  void _startQuiz(String category) {
    final words = vocabulary.where((w) => w['category'] == category).toList();
    if (words.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Quiz'),
          content: Text('No words available for this category.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text('OK'))
          ],
        ),
      );
      return;
    }
    int current = 0;
    int score = 0;
    void showNext() {
      if (current >= words.length) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Quiz Complete'),
            content: Text('Your score: $score/${words.length}'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text('OK'))
            ],
          ),
        );
        return;
      }
      final word = words[current];
      final options = [word['word']];
      while (options.length < 4 && vocabulary.length > 1) {
        final random = (vocabulary..shuffle()).first;
        if (!options.contains(random['word']) &&
            random['category'] == category) {
          options.add(random['word']);
        }
      }
      options.shuffle();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text('Quiz'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Which word matches this example?'),
              if (word['example'] != null &&
                  word['example'].toString().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('"${word['example']}"',
                      style: TextStyle(fontStyle: FontStyle.italic)),
                ),
              ...options.map((opt) => ListTile(
                    title: Text(opt),
                    onTap: () {
                      if (opt == word['word']) score++;
                      Navigator.pop(context);
                      current++;
                      showNext();
                    },
                  )),
            ],
          ),
        ),
      );
    }

    showNext();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reading Module')),
      body: Row(
        children: [
          // Left: File/Folder Sidebar
          Container(
            width: MediaQuery.of(context).size.width * 0.35,
            color: Colors.grey[100],
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Text('My Learning Files',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.add),
                        tooltip: 'Add File',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              final controller = TextEditingController();
                              return AlertDialog(
                                title: Text('Add New File'),
                                content: TextField(
                                  controller: controller,
                                  decoration:
                                      InputDecoration(hintText: 'File name'),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (controller.text.trim().isNotEmpty) {
                                        setState(() {
                                          learningFiles
                                              .add(controller.text.trim());
                                        });
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text('Add'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: learningFiles.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.folder, color: Colors.amber),
                        title: Text(learningFiles[index]),
                        selected: selectedFileIndex == index,
                        onTap: () {
                          setState(() {
                            selectedFileIndex = index;
                          });
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.delete, size: 18),
                          onPressed: () {
                            setState(() {
                              learningFiles.removeAt(index);
                              if (selectedFileIndex >= learningFiles.length) {
                                selectedFileIndex = 0;
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Right: Reading Content
          Expanded(
            child: Container(
              color: Colors.white,
              child: _buildReadingContent(learningFiles.isNotEmpty
                  ? learningFiles[selectedFileIndex]
                  : ''),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingContent(String fileName) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    final filtered =
        vocabulary.where((w) => w['category'] == fileName).toList();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.quiz),
              label: Text('Quiz'),
              onPressed: () => _startQuiz(fileName),
            ),
            SizedBox(width: 16),
          ],
        ),
        Expanded(
          child: filtered.isEmpty
              ? Center(child: Text('No words in this category.'))
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final word = filtered[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(word['word'],
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            IconButton(
                              icon: Icon(Icons.volume_up),
                              tooltip: 'Pronounce',
                              onPressed: () => _speak(word['word']),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (word['part_of_speech'] != null &&
                                word['part_of_speech'].toString().isNotEmpty)
                              Text('Part of speech: ${word['part_of_speech']}'),
                            if (word['example'] != null &&
                                word['example'].toString().isNotEmpty)
                              Text('Example: ${word['example']}'),
                            if (word['variant'] != null &&
                                word['variant'].toString().isNotEmpty)
                              Text('Variant: ${word['variant']}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
