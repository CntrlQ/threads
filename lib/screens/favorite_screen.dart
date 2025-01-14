import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ActivityItem {
  final String userId;
  final String username;
  final String profileImage;
  final String? subtitle;
  final String timeAgo;
  final String? content;
  final bool isFollowing;
  final int? likes;
  final int? comments;
  final bool isVerified;

  ActivityItem({
    required this.userId,
    required this.username,
    required this.profileImage,
    this.subtitle,
    required this.timeAgo,
    this.content,
    this.isFollowing = false,
    this.likes,
    this.comments,
    this.isVerified = false,
  });
}

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<ActivityItem> _allActivities = [
    ActivityItem(
      userId: '1',
      username: 'xsungjinwoo_',
      profileImage: 'https://i.pravatar.cc/150?img=1',
      subtitle: 'Picked for you',
      timeAgo: '10h',
      content: "Sakamoto's afraid to his wife 😂🤣",
      likes: 53,
      comments: 12,
    ),
    ActivityItem(
      userId: '2',
      username: 'camcasey',
      profileImage: 'https://i.pravatar.cc/150?img=2',
      subtitle: 'Picked for you',
      timeAgo: '1d',
      content: "So sad to see 💔",
      likes: 2,
      comments: 0,
      isVerified: true,
    ),
    ActivityItem(
      userId: '3',
      username: 'logifestyle',
      profileImage: 'https://i.pravatar.cc/150?img=3',
      subtitle: "You're now following",
      timeAgo: '2d',
      isFollowing: true,
    ),
  ];

  final List<ActivityItem> _followActivities = [
    ActivityItem(
      userId: '3',
      username: 'logifestyle',
      profileImage: 'https://i.pravatar.cc/150?img=3',
      subtitle: "Started following you",
      timeAgo: '2d',
      isFollowing: true,
    ),
    ActivityItem(
      userId: '5',
      username: 'nisma_navas',
      profileImage: 'https://i.pravatar.cc/150?img=5',
      subtitle: 'Started following you',
      timeAgo: '1w',
      isFollowing: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Activity',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFE0E0E0),
                  width: 0.5,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
                insets: EdgeInsets.symmetric(horizontal: 16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              labelPadding: const EdgeInsets.symmetric(horizontal: 24),
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Follows'),
                Tab(text: 'Replies'),
                Tab(text: 'Mentions'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // All Tab
          _allActivities.isEmpty
              ? _buildEmptyState('No activity yet')
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 16),
                  itemCount: _allActivities.length,
                  itemBuilder: (context, index) {
                    return _buildActivityItem(_allActivities[index]);
                  },
                ),
          // Follows Tab
          _followActivities.isEmpty
              ? _buildEmptyState('No follows yet')
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 16),
                  itemCount: _followActivities.length,
                  itemBuilder: (context, index) {
                    return _buildActivityItem(_followActivities[index]);
                  },
                ),
          // Replies Tab
          _buildEmptyState('No replies yet'),
          // Mentions Tab
          _buildEmptyState('No mentions yet'),
        ],
      ),
    );
  }

  Widget _buildActivityItem(ActivityItem activity) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: activity.profileImage,
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  backgroundImage: imageProvider,
                  radius: 20,
                ),
                placeholder: (context, url) => CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade200,
                ),
                errorWidget: (context, url, error) => CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(Icons.error),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          activity.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        if (activity.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified, size: 14, color: Colors.blue),
                        ],
                        const SizedBox(width: 4),
                        Text(
                          activity.timeAgo,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    if (activity.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        activity.subtitle!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                    if (activity.content != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        activity.content!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                    if (activity.likes != null || activity.comments != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (activity.likes != null) ...[
                            Icon(Icons.favorite_border, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              '${activity.likes}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                          if (activity.likes != null && activity.comments != null)
                            const SizedBox(width: 16),
                          if (activity.comments != null) ...[
                            Icon(Icons.chat_bubble_outline, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              '${activity.comments}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (activity.isFollowing)
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text(
                    'Following',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
