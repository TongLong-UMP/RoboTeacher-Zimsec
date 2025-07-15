import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../services/teacher_chat_service.dart';
import '../widgets/learning_flowchart.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// const String geminiApiKey = 'YOUR_GEMINI_API_KEY';
// const String geminiApiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=YOUR_GEMINI_API_KEY';

class LearningDeskScreen extends StatefulWidget {
  const LearningDeskScreen({super.key});

  @override
  State<LearningDeskScreen> createState() => _LearningDeskScreenState();
}

class _LearningDeskScreenState extends State<LearningDeskScreen> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _showBotChat = false;
  bool _showTeacherChat = false;
  final List<Map<String, String>> _botMessages = [];
  final TextEditingController _botController = TextEditingController();
  final TextEditingController _teacherController = TextEditingController();

  String studentId = 'student_123'; // Replace with actual user ID
  String teacherId = 'teacher_456'; // Replace with actual teacher ID
  String studentName = 'Tinashe'; // Replace with actual user name

  String get chatId => ' {studentId}_$teacherId';

  // Example flowchart data (can be loaded/refined in the future)
  final List<Map<String, dynamic>> flowchartData = [
    {
      'id': 'start',
      'label': 'Start',
      'next': ['syllables'],
      'isActive': true
    },
    {
      'id': 'syllables',
      'label': 'Syllables',
      'next': ['meanings']
    },
    {
      'id': 'meanings',
      'label': 'Word Meanings',
      'next': ['sentences']
    },
    {
      'id': 'sentences',
      'label': 'Sentences',
      'next': ['practice']
    },
    {
      'label': 'Practice & Fun',
      'next': ['end']
    },
    {'id': 'end', 'label': 'Conclusion', 'next': []},
  ];

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    final directory = await getApplicationDocumentsDirectory();
    final videoPath = '${directory.path}/learning_to_read.mp4';
    final videoFile = File(videoPath);
    if (await videoFile.exists()) {
      _videoController = VideoPlayerController.file(videoFile);
    } else {
      _videoController =
          VideoPlayerController.asset('assets/videos/learning_to_read.mp4');
    }
    await _videoController!.initialize();
    setState(() {
      _isVideoInitialized = true;
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _botController.dispose();
    _teacherController.dispose();
    super.dispose();
  }

  void _askGemini(String question) async {
    setState(() {
      _botMessages.add({'role': 'user', 'text': question});
      _botMessages.add({'role': 'bot', 'text': 'Thinking...'});
    });
    // TODO: Integrate Gemini API for production use
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _botMessages.removeLast();
      _botMessages.add({
        'role': 'bot',
        'text': 'This is a sample Gemini explanation for: $question'
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Learning Desk')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Flowchart at the top
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: LearningFlowchart(nodesData: flowchartData),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Video player section
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: _isVideoInitialized && _videoController != null
                          ? AspectRatio(
                              aspectRatio: _videoController!.value.aspectRatio,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: VideoPlayer(_videoController!),
                                  ),
                                  Positioned(
                                    right: 16,
                                    top: 16,
                                    child: Column(
                                      children: [
                                        FloatingActionButton(
                                          heroTag: 'pause',
                                          mini: true,
                                          onPressed: () {
                                            setState(() {
                                              if (_videoController != null &&
                                                  _videoController!
                                                      .value.isPlaying) {
                                                _videoController!.pause();
                                              } else if (_videoController !=
                                                  null) {
                                                _videoController!.play();
                                              }
                                            });
                                          },
                                          child: Icon(
                                              _videoController != null &&
                                                      _videoController!
                                                          .value.isPlaying
                                                  ? Icons.pause
                                                  : Icons.play_arrow),
                                        ),
                                        const SizedBox(height: 8),
                                        FloatingActionButton(
                                          heroTag: 'ask_gemini',
                                          mini: true,
                                          backgroundColor: Colors.blue,
                                          onPressed: () {
                                            setState(() {
                                              _showBotChat = !_showBotChat;
                                              _showTeacherChat = false;
                                              _videoController?.pause();
                                            });
                                          },
                                          tooltip: 'Ask Gemini',
                                          child: const Icon(Icons.smart_toy),
                                        ),
                                        const SizedBox(height: 8),
                                        FloatingActionButton(
                                          heroTag: 'ask_teacher',
                                          mini: true,
                                          backgroundColor: Colors.green,
                                          onPressed: () {
                                            setState(() {
                                              _showTeacherChat =
                                                  !_showTeacherChat;
                                              _showBotChat = false;
                                              _videoController?.pause();
                                            });
                                          },
                                          tooltip: 'Ask a Teacher',
                                          child: const Icon(Icons.person),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text('Video not found or failed to load.',
                                    style: TextStyle(color: Colors.red)),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Chat panels
                  if (_showBotChat) _buildBotChat(theme),
                  if (_showTeacherChat) _buildTeacherChat(theme),
                  // Room for future enhancements (quizzes, notes, etc.)
                  const SizedBox(height: 24),
                  // TODO: Add more learning tools here
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBotChat(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Ask Gemini (AI Bot)',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: ListView(
                children: _botMessages
                    .map((msg) => Align(
                          alignment: msg['role'] == 'user'
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Card(
                            color: msg['role'] == 'user'
                                ? Colors.blue[100]
                                : Colors.grey[200],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(msg['text']!),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _botController,
                    decoration:
                        const InputDecoration(hintText: 'Ask a question...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_botController.text.trim().isNotEmpty) {
                      _askGemini(_botController.text.trim());
                      _botController.clear();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherChat(ThemeData theme) {
    final teacherChatService =
        Provider.of<TeacherChatService>(context, listen: false);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Ask a Human Teacher',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: teacherChatService.getMessages(chatId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return const Center(child: CircularProgressIndicator());
                  final messages = snapshot.data!;
                  return ListView(
                    children: messages
                        .map((msg) => Align(
                              alignment: msg['senderId'] == studentId
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Card(
                                color: msg['senderId'] == studentId
                                    ? Colors.green[100]
                                    : Colors.grey[200],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      '${msg['senderName']}: ${msg['text']}'),
                                ),
                              ),
                            ))
                        .toList(),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _teacherController,
                    decoration:
                        const InputDecoration(hintText: 'Type your message...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_teacherController.text.trim().isNotEmpty) {
                      teacherChatService.sendMessage(
                        chatId,
                        studentId,
                        studentName,
                        _teacherController.text.trim(),
                      );
                      _teacherController.clear();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
