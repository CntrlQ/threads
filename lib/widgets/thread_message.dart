import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:thread_clone_flutter/model/thread_message.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:animations/animations.dart';

class ThreadMessageWidget extends StatefulWidget {
  const ThreadMessageWidget({
    super.key,
    required this.message,
    required this.onLike,
    required this.onDisLike,
    required this.onComment,
    required this.panelController,
  });

  final ThreadMessage message;
  final void Function() onLike;
  final void Function() onDisLike;
  final void Function() onComment;
  final PanelController panelController;

  @override
  State<ThreadMessageWidget> createState() => _ThreadMessageWidgetState();
}

class _ThreadMessageWidgetState extends State<ThreadMessageWidget> with SingleTickerProviderStateMixin {
  late AnimationController _likeController;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _likeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _likeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileSection(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    _buildContent(),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 32, color: Color(0xFFE0E0E0))
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        Hero(
          tag: 'profile_${widget.message.senderId}',
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 2),
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: CachedNetworkImageProvider(
                widget.message.senderProfileImageUrl,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          widget.message.senderName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.verified, size: 14, color: Colors.blue),
        const Spacer(),
        Text(
          _getTimeDifference(widget.message.timestamp),
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        IconButton(
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(),
          onPressed: () {},
          icon: const Icon(Icons.more_horiz, size: 20),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.message.message,
            style: const TextStyle(
              fontSize: 15,
              height: 1.3,
            ),
          ),
          if (widget.message.imageUrl != null) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: widget.message.imageUrl!,
                placeholder: (context, url) => Container(
                  height: 200,
                  color: Colors.grey.shade200,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          _buildAnimatedIconButton(
            onPressed: () {
              if (widget.message.likes.contains(userId)) {
                widget.onDisLike();
                _likeController.reverse();
              } else {
                widget.onLike();
                _likeController.forward();
              }
            },
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: widget.message.likes.contains(userId)
                  ? const Icon(Icons.favorite, color: Colors.red, key: ValueKey('liked'))
                  : const Icon(Icons.favorite_border, key: ValueKey('unliked')),
            ),
            count: widget.message.likes.length,
          ),
          _buildAnimatedIconButton(
            onPressed: () {
              widget.panelController.open();
              widget.onComment();
            },
            icon: const Icon(Icons.chat_bubble_outline),
            count: widget.message.comments.length,
          ),
          _buildAnimatedIconButton(
            onPressed: () {},
            icon: Image.asset('assets/retweet.png', width: 20),
            count: 0,
          ),
          _buildAnimatedIconButton(
            onPressed: () {},
            icon: Image.asset('assets/send.png', width: 20),
            count: 0,
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedIconButton({
    required VoidCallback onPressed,
    required Widget icon,
    required int count,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Row(
        children: [
          OpenContainer(
            transitionDuration: const Duration(milliseconds: 500),
            openBuilder: (context, _) => const SizedBox(),
            closedShape: const CircleBorder(),
            closedColor: Colors.transparent,
            closedElevation: 0,
            closedBuilder: (context, openContainer) => IconButton(
              onPressed: () {
                onPressed();
                // Only open container for comment button
                if (icon is Icon && (icon).icon == Icons.chat_bubble_outline) {
                  openContainer();
                }
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: icon,
              iconSize: 22,
            ),
          ),
          if (count > 0) ...[
            const SizedBox(width: 4),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getTimeDifference(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      final mins = difference.inMinutes;
      return '${mins}m';
    } else if (difference.inDays < 1) {
      final hours = difference.inHours;
      return '${hours}h';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '${days}d';
    } else {
      return '${timestamp.month}/${timestamp.day}';
    }
  }
}
