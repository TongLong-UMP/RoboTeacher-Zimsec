import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../services/social_feed_service.dart';
import '../services/theme_service.dart';

class AnimatedSocialCard extends StatefulWidget {
  final SocialPost post;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final bool showActions;

  const AnimatedSocialCard({
    super.key,
    required this.post,
    this.onTap,
    this.onLike,
    this.onComment,
    this.onShare,
    this.showActions = true,
  });

  @override
  State<AnimatedSocialCard> createState() => _AnimatedSocialCardState();
}

class _AnimatedSocialCardState extends State<AnimatedSocialCard>
    with TickerProviderStateMixin {
  late AnimationController _likeController;
  late AnimationController _cardController;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _likeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Check if current user has liked this post
    _isLiked = widget.post.likes.contains('local_user_123');

    // Start card animation
    _cardController.forward();
  }

  @override
  void dispose() {
    _likeController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  void _handleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });

    if (_isLiked) {
      _likeController.forward().then((_) => _likeController.reverse());
    }

    widget.onLike?.call();
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final socialFeedService =
        Provider.of<SocialFeedService>(context, listen: false);

    return AnimatedBuilder(
      animation: _cardController,
      builder: (context, child) {
        return Transform.scale(
          scale: Curves.elasticOut.transform(_cardController.value),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: themeService.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    _buildHeader(themeService),

                    // Content
                    _buildContent(themeService),

                    // Media (if any)
                    if (widget.post.imageUrl != null) _buildImage(),
                    if (widget.post.videoUrl != null) _buildVideo(),

                    // Subject and Grade tags
                    _buildTags(themeService),

                    // Actions
                    if (widget.showActions)
                      _buildActions(themeService, socialFeedService),

                    // Comments preview
                    if (widget.post.comments.isNotEmpty)
                      _buildCommentsPreview(themeService),
                  ],
                ),
              ),
            ),
          ),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
      },
    );
  }

  Widget _buildHeader(ThemeService themeService) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: themeService.primaryGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                widget.post.userAvatar,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ).animate().scale(duration: 400.ms, delay: 200.ms),

          const SizedBox(width: 12),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post.userName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: themeService.currentTheme == AppTheme.western
                            ? const Color(0xFF8B4513)
                            : const Color(0xFFFF6B35),
                      ),
                ),
                Text(
                  _formatTimestamp(widget.post.timestamp),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),

          // More options
          IconButton(
            onPressed: () {
              // Show more options
            },
            icon: Icon(
              Icons.more_horiz,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeService themeService) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        widget.post.content,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.4,
            ),
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildImage() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey[300] ?? Colors.grey,
                Colors.grey[400] ?? Colors.grey,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.image,
              size: 48,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildVideo() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey[300] ?? Colors.grey,
                Colors.grey[400] ?? Colors.grey,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.play_circle_outline,
              size: 48,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildTags(ThemeService themeService) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: themeService.currentTheme == AppTheme.western
                  ? const Color(0xFFD2B48C)
                  : const Color(0xFFFFD700),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.post.subject,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: themeService.currentTheme == AppTheme.western
                    ? const Color(0xFF8B4513)
                    : const Color(0xFFFF6B35),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: themeService.currentTheme == AppTheme.western
                  ? const Color(0xFFF5F5DC)
                  : const Color(0xFF8E44AD),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.post.grade,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: themeService.currentTheme == AppTheme.western
                    ? const Color(0xFF8B4513)
                    : Colors.white,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.2, end: 0);
  }

  Widget _buildActions(
      ThemeService themeService, SocialFeedService socialFeedService) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Like button
          _buildActionButton(
            icon: _isLiked ? Icons.favorite : Icons.favorite_border,
            label: '${widget.post.likes.length}',
            onPressed: _handleLike,
            isActive: _isLiked,
            themeService: themeService,
          ),

          const SizedBox(width: 16),

          // Comment button
          _buildActionButton(
            icon: Icons.comment_outlined,
            label: '${widget.post.comments.length}',
            onPressed: widget.onComment,
            themeService: themeService,
          ),

          const SizedBox(width: 16),

          // Share button
          _buildActionButton(
            icon: Icons.share_outlined,
            label: 'Share',
            onPressed: widget.onShare,
            themeService: themeService,
          ),

          const Spacer(),

          // Educational badge
          if (widget.post.isEducational)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.school,
                    size: 16,
                    color: Colors.green[700],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Educational',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: 600.ms)
                .scale(begin: const Offset(0.5, 0.5)),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required ThemeService themeService,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? (themeService.currentTheme == AppTheme.western
                  ? const Color(0xFFD2B48C)
                  : const Color(0xFFFFD700))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _likeController,
              builder: (context, child) {
                return Transform.scale(
                  scale: isActive ? 1.0 + (_likeController.value * 0.3) : 1.0,
                  child: Icon(
                    icon,
                    size: 20,
                    color: isActive
                        ? (themeService.currentTheme == AppTheme.western
                            ? const Color(0xFF8B4513)
                            : const Color(0xFFFF6B35))
                        : Colors.grey[600],
                  ),
                );
              },
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? (themeService.currentTheme == AppTheme.western
                        ? const Color(0xFF8B4513)
                        : const Color(0xFFFF6B35))
                    : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsPreview(ThemeService themeService) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.post.comments.isNotEmpty) ...[
            Text(
              'Comments',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: themeService.currentTheme == AppTheme.western
                    ? const Color(0xFF8B4513)
                    : const Color(0xFFFF6B35),
              ),
            ),
            const SizedBox(height: 8),
            ...widget.post.comments
                .take(2)
                .map((comment) => _buildCommentItem(comment)),
            if (widget.post.comments.length > 2)
              TextButton(
                onPressed: widget.onComment,
                child: Text(
                  'View all ${widget.post.comments.length} comments',
                  style: TextStyle(
                    color: themeService.currentTheme == AppTheme.western
                        ? const Color(0xFF8B4513)
                        : const Color(0xFFFF6B35),
                  ),
                ),
              ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: 700.ms);
  }

  Widget _buildCommentItem(Comment comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            comment.userAvatar,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.userName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  comment.content,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
