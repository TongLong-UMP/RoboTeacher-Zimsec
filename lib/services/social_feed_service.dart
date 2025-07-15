import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SocialPost {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final String? imageUrl;
  final String? videoUrl;
  final String subject;
  final String grade;
  final DateTime timestamp;
  final List<String> likes;
  final List<Comment> comments;
  final bool isEducational;
  final String? lessonId;
  final Map<String, dynamic>? metadata;

  SocialPost({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    this.imageUrl,
    this.videoUrl,
    required this.subject,
    required this.grade,
    required this.timestamp,
    required this.likes,
    required this.comments,
    this.isEducational = false,
    this.lessonId,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'content': content,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'subject': subject,
      'grade': grade,
      'timestamp': timestamp.toIso8601String(),
      'likes': likes,
      'comments': comments.map((c) => c.toJson()).toList(),
      'isEducational': isEducational,
      'lessonId': lessonId,
      'metadata': metadata,
    };
  }

  factory SocialPost.fromJson(Map<String, dynamic> json) {
    return SocialPost(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      subject: json['subject'],
      grade: json['grade'],
      timestamp: DateTime.parse(json['timestamp']),
      likes: List<String>.from(json['likes']),
      comments:
          (json['comments'] as List).map((c) => Comment.fromJson(c)).toList(),
      isEducational: json['isEducational'] ?? false,
      lessonId: json['lessonId'],
      metadata: json['metadata'],
    );
  }

  SocialPost copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatar,
    String? content,
    String? imageUrl,
    String? videoUrl,
    String? subject,
    String? grade,
    DateTime? timestamp,
    List<String>? likes,
    List<Comment>? comments,
    bool? isEducational,
    String? lessonId,
    Map<String, dynamic>? metadata,
  }) {
    return SocialPost(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      subject: subject ?? this.subject,
      grade: grade ?? this.grade,
      timestamp: timestamp ?? this.timestamp,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      isEducational: isEducational ?? this.isEducational,
      lessonId: lessonId ?? this.lessonId,
      metadata: metadata ?? this.metadata,
    );
  }
}

class Comment {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final DateTime timestamp;
  final List<String> likes;

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.timestamp,
    required this.likes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'likes': likes,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      likes: List<String>.from(json['likes']),
    );
  }
}

class SocialFeedService extends ChangeNotifier {
  static const String _postsBoxName = 'social_posts';
  static const String _userPostsBoxName = 'user_posts';

  late Box<Map> _postsBox;
  late Box<Map> _userPostsBox;

  List<SocialPost> _posts = [];
  List<SocialPost> _userPosts = [];
  bool _isLoading = false;

  List<SocialPost> get posts => _posts;
  List<SocialPost> get userPosts => _userPosts;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    _postsBox = await Hive.openBox<Map>(_postsBoxName);
    _userPostsBox = await Hive.openBox<Map>(_userPostsBoxName);
    await _loadPosts();
    await _loadUserPosts();
  }

  Future<void> _loadPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final postsData = _postsBox.values.toList();
      _posts = postsData
          .map((data) => SocialPost.fromJson(Map<String, dynamic>.from(data)))
          .toList();

      // Sort by timestamp (newest first)
      _posts.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      // If no posts exist, create some sample posts
      if (_posts.isEmpty) {
        await _createSamplePosts();
      }
    } catch (e) {
      debugPrint('Error loading posts: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadUserPosts() async {
    try {
      final userPostsData = _userPostsBox.values.toList();
      _userPosts = userPostsData
          .map((data) => SocialPost.fromJson(Map<String, dynamic>.from(data)))
          .toList();

      _userPosts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      debugPrint('Error loading user posts: $e');
    }
  }

  Future<void> _createSamplePosts() async {
    final samplePosts = [
      SocialPost(
        id: '1',
        userId: 'teacher_1',
        userName: 'Mrs. Sarah Johnson',
        userAvatar: '👩‍🏫',
        content:
            'Just finished teaching Grade 3 students about African wildlife! 🦁 The kids loved learning about the Big Five. Remember: Lion, Elephant, Buffalo, Leopard, and Rhino! #AfricanWildlife #Grade3 #Education',
        subject: 'Science',
        grade: 'Grade 3',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        likes: ['student_1', 'student_2', 'parent_1'],
        comments: [
          Comment(
            id: 'c1',
            userId: 'student_1',
            userName: 'Tommy M.',
            userAvatar: '👦',
            content: 'I love lions! They are so strong! 🦁',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            likes: ['teacher_1'],
          ),
        ],
        isEducational: true,
        lessonId: 'wildlife_lesson_1',
      ),
      SocialPost(
        id: '2',
        userId: 'student_2',
        userName: 'Aisha K.',
        userAvatar: '👧',
        content:
            'Practiced my reading today! 📚 I can now read "The Little Red Hen" all by myself! My teacher says I\'m improving so much! #Reading #Progress #Proud',
        subject: 'English',
        grade: 'Grade 2',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        likes: ['teacher_1', 'parent_2', 'student_1'],
        comments: [],
        isEducational: true,
        lessonId: 'reading_lesson_2',
      ),
      SocialPost(
        id: '3',
        userId: 'parent_1',
        userName: 'Mr. David M.',
        userAvatar: '👨',
        content:
            'My daughter completed her math homework with flying colors! 🎉 The new digital platform is really helping her understand multiplication. Thank you teachers! #Math #Homework #ParentPride',
        subject: 'Mathematics',
        grade: 'Grade 4',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        likes: ['teacher_1', 'teacher_2'],
        comments: [
          Comment(
            id: 'c2',
            userId: 'teacher_1',
            userName: 'Mrs. Sarah Johnson',
            userAvatar: '👩‍🏫',
            content: 'She\'s doing amazing! Keep up the great work! 🌟',
            timestamp: DateTime.now().subtract(const Duration(hours: 5)),
            likes: ['parent_1'],
          ),
        ],
        isEducational: true,
      ),
    ];

    for (final post in samplePosts) {
      await addPost(post);
    }
  }

  Future<void> addPost(SocialPost post) async {
    try {
      _posts.insert(0, post);
      await _postsBox.put(post.id, post.toJson());
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding post: $e');
    }
  }

  Future<void> addUserPost(SocialPost post) async {
    try {
      _userPosts.insert(0, post);
      await _userPostsBox.put(post.id, post.toJson());
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding user post: $e');
    }
  }

  Future<void> likePost(String postId, String userId) async {
    try {
      final postIndex = _posts.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        final post = _posts[postIndex];
        final newLikes = List<String>.from(post.likes);

        if (newLikes.contains(userId)) {
          newLikes.remove(userId);
        } else {
          newLikes.add(userId);
        }

        final updatedPost = post.copyWith(likes: newLikes);
        _posts[postIndex] = updatedPost;
        await _postsBox.put(postId, updatedPost.toJson());
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error liking post: $e');
    }
  }

  Future<void> addComment(String postId, Comment comment) async {
    try {
      final postIndex = _posts.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        final post = _posts[postIndex];
        final newComments = List<Comment>.from(post.comments)..add(comment);
        final updatedPost = post.copyWith(comments: newComments);
        _posts[postIndex] = updatedPost;
        await _postsBox.put(postId, updatedPost.toJson());
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error adding comment: $e');
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      _posts.removeWhere((post) => post.id == postId);
      _userPosts.removeWhere((post) => post.id == postId);
      await _postsBox.delete(postId);
      await _userPostsBox.delete(postId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting post: $e');
    }
  }

  List<SocialPost> getPostsBySubject(String subject) {
    return _posts
        .where((post) => post.subject.toLowerCase() == subject.toLowerCase())
        .toList();
  }

  List<SocialPost> getPostsByGrade(String grade) {
    return _posts.where((post) => post.grade == grade).toList();
  }

  List<SocialPost> getEducationalPosts() {
    return _posts.where((post) => post.isEducational).toList();
  }

  List<SocialPost> getPostsByUser(String userId) {
    return _posts.where((post) => post.userId == userId).toList();
  }

  void dispose() {
    _postsBox.close();
    _userPostsBox.close();
    super.dispose();
  }
}
