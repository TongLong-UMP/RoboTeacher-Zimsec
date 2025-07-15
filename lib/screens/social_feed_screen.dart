import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../services/social_feed_service.dart';
import '../services/theme_service.dart';
import '../widgets/advertising_banner_widget.dart';
import '../widgets/animated_social_card.dart';

class SocialFeedScreen extends StatefulWidget {
  const SocialFeedScreen({super.key});

  @override
  State<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late ScrollController _scrollController;
  String _selectedFilter = 'All';
  bool _showFloatingActionButton = true;

  final List<String> _filters = [
    'Community',
    'School Calendar',
    'Events Board',
    'RoboRankings',
    'Supplier Directory',
    'Schools Directory',
  ];

  // Demo community chat state
  final List<Map<String, String>> _chatMessages = [
    {'user': 'Alice', 'avatar': '👩', 'text': 'Welcome to the community chat!'},
    {'user': 'Bob', 'avatar': '👨', 'text': 'Hi everyone!'},
  ];
  final TextEditingController _chatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    // Inject demo posts if none exist
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final socialFeedService =
          Provider.of<SocialFeedService>(context, listen: false);
      if (socialFeedService.posts.isEmpty) {
        debugPrint('Injecting demo posts...');
        socialFeedService.addPost(SocialPost(
          id: 'demo1',
          userId: 'teacher_1',
          userName: 'Mrs. Sarah Johnson',
          userAvatar: '👩‍🏫',
          content:
              'Welcome to the Learning Community! Share your thoughts below.',
          subject: 'General',
          grade: 'All Grades',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
          likes: ['student_1'],
          comments: [],
          isEducational: true,
        ));
        socialFeedService.addPost(SocialPost(
          id: 'demo2',
          userId: 'student_2',
          userName: 'Tommy M.',
          userAvatar: '👦',
          content: 'What are your favorite study tips?',
          subject: 'General',
          grade: 'Grade 5',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          likes: [],
          comments: [],
          isEducational: false,
        ));
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _scrollController.dispose();
    _chatController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 100 && _showFloatingActionButton) {
      setState(() {
        _showFloatingActionButton = false;
      });
    } else if (_scrollController.offset <= 100 && !_showFloatingActionButton) {
      setState(() {
        _showFloatingActionButton = true;
      });
    }
  }

  Widget _buildDemoCommunityChat() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Community Chat (Demo)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView(
                children: _chatMessages
                    .map((msg) => Align(
                          alignment: msg['user'] == 'You'
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Card(
                            color: msg['user'] == 'You'
                                ? Colors.blue[100]
                                : Colors.grey[200],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(msg['avatar'] ?? '🙂',
                                      style: const TextStyle(fontSize: 18)),
                                  const SizedBox(width: 6),
                                  Text('${msg['user']}: ',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(msg['text'] ?? ''),
                                ],
                              ),
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
                    controller: _chatController,
                    decoration:
                        const InputDecoration(hintText: 'Type a message...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_chatController.text.trim().isNotEmpty) {
                      setState(() {
                        _chatMessages.add({
                          'user': 'You',
                          'avatar': '🧑',
                          'text': _chatController.text.trim(),
                        });
                        _chatController.clear();
                      });
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

  Widget _buildSectionContent(
      SocialFeedService socialFeedService, ThemeService themeService) {
    debugPrint('Rendering section: $_selectedFilter');
    switch (_selectedFilter) {
      case 'Community':
        return SliverList(
          delegate: SliverChildListDelegate([
            _buildDemoCommunityChat(),
            _buildPostsList(socialFeedService, themeService),
          ]),
        );
      case 'School Calendar':
        return const SliverToBoxAdapter(
            child: Center(
                child: Text(
                    '2025 School Calendar: Term 1: Jan 10 - Apr 5, Term 2: May 2 - Aug 8, Term 3: Sep 2 - Dec 5')));
      case 'Events Board':
        return const SliverToBoxAdapter(
            child: Center(
                child: Text(
                    'Upcoming Events: Science Fair (Mar 15), Sports Day (Jun 10), Prize Giving (Nov 20)')));
      case 'RoboRankings':
        return const SliverToBoxAdapter(
            child: Center(
                child: Text(
                    'RoboRankings: Top Schools and Students will appear here.')));
      case 'Supplier Directory':
        return const SliverToBoxAdapter(
            child: Center(
                child: Text(
                    'Supplier Directory: Find trusted suppliers for your school needs.')));
      case 'Schools Directory':
        return const SliverToBoxAdapter(
            child: Center(
                child:
                    Text('Schools Directory: Browse all registered schools.')));
      default:
        debugPrint('Default section: $_selectedFilter');
        return _buildPostsList(socialFeedService, themeService);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final socialFeedService = Provider.of<SocialFeedService>(context);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Custom App Bar
          _buildSliverAppBar(themeService),

          // Advertising Banner
          SliverToBoxAdapter(
            child: AdvertisingBannerWidget(
              imageUrl: null, // Replace with ad image URL if available
              adText:
                  'Advertise with us! Reach thousands of parents and schools.',
              onTap: () {
                // TODO: Implement ad tap action
              },
            ),
          ),

          // Filter Chips
          _buildFilterChips(themeService),

          // Posts or Section Content
          _buildSectionContent(socialFeedService, themeService),
        ],
      ),

      // Floating Action Button
      floatingActionButton: _showFloatingActionButton
          ? _buildFloatingActionButton(themeService)
          : null,

      // Confetti
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // bottomNavigationBar removed; now handled by MainScaffold
    );
  }

  Widget _buildSliverAppBar(ThemeService themeService) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: themeService.currentTheme == AppTheme.western
          ? const Color(0xFF8B4513)
          : const Color(0xFFFF6B35),
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Learning Community',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: themeService.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned.fill(
                child: CustomPaint(
                  painter: _BackgroundPatternPainter(themeService.currentTheme),
                ),
              ),
              // Content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      themeService.currentTheme == AppTheme.western
                          ? Icons.school
                          : Icons.psychology,
                      size: 40,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Share, Learn, Grow Together',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            themeService.toggleTheme();
          },
          icon: Icon(
            themeService.currentTheme == AppTheme.western
                ? Icons.brightness_6
                : Icons.brightness_7,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {
            // Show notifications
          },
          icon: const Icon(
            Icons.notifications_outlined,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips(ThemeService themeService) {
    return SliverToBoxAdapter(
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _filters.length,
          itemBuilder: (context, index) {
            final filter = _filters[index];
            final isSelected = _selectedFilter == filter;

            return Container(
              margin: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(filter),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
                backgroundColor: Colors.grey[200],
                selectedColor: themeService.currentTheme == AppTheme.western
                    ? const Color(0xFFD2B48C)
                    : const Color(0xFFFFD700),
                labelStyle: TextStyle(
                  color: isSelected
                      ? (themeService.currentTheme == AppTheme.western
                          ? const Color(0xFF8B4513)
                          : const Color(0xFFFF6B35))
                      : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            )
                .animate()
                .fadeIn(delay: (index * 100).ms)
                .slideX(begin: 0.3, end: 0);
          },
        ),
      ),
    );
  }

  Widget _buildPostsList(
      SocialFeedService socialFeedService, ThemeService themeService) {
    debugPrint('Building posts list for filter: $_selectedFilter');
    List<SocialPost> filteredPosts = _getFilteredPosts(socialFeedService.posts);

    if (socialFeedService.isLoading) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (filteredPosts.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.forum_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No posts found',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Be the first to share something!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final post = filteredPosts[index];
          return AnimatedSocialCard(
            post: post,
            onTap: () => _showPostDetail(post),
            onLike: () => _handleLike(post),
            onComment: () => _showCommentDialog(post),
            onShare: () => _handleShare(post),
          );
        },
        childCount: filteredPosts.length,
      ),
    );
  }

  Widget _buildFloatingActionButton(ThemeService themeService) {
    return FloatingActionButton.extended(
      onPressed: _showCreatePostDialog,
      backgroundColor: themeService.currentTheme == AppTheme.western
          ? const Color(0xFF8B4513)
          : const Color(0xFFFF6B35),
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text(
        'Share',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ).animate().scale(duration: 300.ms).fadeIn();
  }

  List<SocialPost> _getFilteredPosts(List<SocialPost> posts) {
    debugPrint('Filtering posts for: $_selectedFilter');
    switch (_selectedFilter) {
      case 'Educational':
        return posts.where((post) => post.isEducational).toList();
      case 'Mathematics':
        return posts.where((post) => post.subject == 'Mathematics').toList();
      case 'English':
        return posts.where((post) => post.subject == 'English').toList();
      case 'Science':
        return posts.where((post) => post.subject == 'Science').toList();
      case 'History':
        return posts.where((post) => post.subject == 'History').toList();
      default:
        return posts;
    }
  }

  void _showPostDetail(SocialPost post) {
    // Navigate to post detail screen
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildPostDetailSheet(post),
    );
  }

  Widget _buildPostDetailSheet(SocialPost post) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    AnimatedSocialCard(
                      post: post,
                      showActions: false,
                    ),

                    const SizedBox(height: 16),

                    // Comments section
                    _buildCommentsSection(post),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommentsSection(SocialPost post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comments (${post.comments.length})',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (post.comments.isEmpty)
          Center(
            child: Text(
              'No comments yet. Be the first to comment!',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          )
        else
          ...post.comments.map((comment) => _buildCommentTile(comment)),
      ],
    );
  }

  Widget _buildCommentTile(Comment comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            comment.userAvatar,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  comment.content,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimestamp(comment.timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleLike(SocialPost post) {
    final socialFeedService =
        Provider.of<SocialFeedService>(context, listen: false);
    socialFeedService.likePost(post.id, 'local_user_123');

    // Show confetti for likes
    _confettiController.play();
  }

  void _showCommentDialog(SocialPost post) {
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Comment'),
        content: TextField(
          controller: commentController,
          decoration: const InputDecoration(
            hintText: 'Write your comment...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (commentController.text.isNotEmpty) {
                final socialFeedService =
                    Provider.of<SocialFeedService>(context, listen: false);
                final comment = Comment(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  userId: 'local_user_123',
                  userName: 'Current User',
                  userAvatar: '👤',
                  content: commentController.text,
                  timestamp: DateTime.now(),
                  likes: [],
                );
                socialFeedService.addComment(post.id, comment);
                Navigator.pop(context);
              }
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  void _handleShare(SocialPost post) {
    // Show share options
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Share this post',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(Icons.copy, 'Copy Link'),
                _buildShareOption(Icons.share, 'Share'),
                _buildShareOption(Icons.bookmark_border, 'Save'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  void _showCreatePostDialog() {
    final contentController = TextEditingController();
    final subjectController = TextEditingController();
    final gradeController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const Text(
                    'Create Post',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (contentController.text.isNotEmpty) {
                        _createPost(
                          contentController.text,
                          subjectController.text,
                          gradeController.text,
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Post'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Column(
                  children: [
                    TextField(
                      controller: contentController,
                      decoration: const InputDecoration(
                        hintText: 'What would you like to share?',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      expands: true,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: subjectController,
                            decoration: const InputDecoration(
                              hintText: 'Subject (optional)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: gradeController,
                            decoration: const InputDecoration(
                              hintText: 'Grade (optional)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createPost(String content, String subject, String grade) {
    final socialFeedService =
        Provider.of<SocialFeedService>(context, listen: false);
    final post = SocialPost(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'local_user_123',
      userName: 'Current User',
      userAvatar: '👤',
      content: content,
      subject: subject.isNotEmpty ? subject : 'General',
      grade: grade.isNotEmpty ? grade : 'All Grades',
      timestamp: DateTime.now(),
      likes: [],
      comments: [],
      isEducational: true,
    );

    socialFeedService.addPost(post);
    socialFeedService.addUserPost(post);

    // Show success animation
    _confettiController.play();
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class _BackgroundPatternPainter extends CustomPainter {
  final AppTheme theme;

  _BackgroundPatternPainter(this.theme);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;

    if (theme == AppTheme.western) {
      // Western pattern - stars
      for (int i = 0; i < 20; i++) {
        final x = (i * 40) % size.width;
        final y = (i * 30) % size.height;
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    } else {
      // African pattern - geometric shapes
      for (int i = 0; i < 15; i++) {
        final x = (i * 50) % size.width;
        final y = (i * 40) % size.height;
        final rect = Rect.fromCenter(
          center: Offset(x, y),
          width: 8,
          height: 8,
        );
        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
