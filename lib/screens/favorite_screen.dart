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
  int _currentIndexTab = 0;
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
    ActivityItem(
      userId: '4',
      username: 'y__k65q__',
      profileImage: 'https://i.pravatar.cc/150?img=4',
      subtitle: 'Picked for you',
      timeAgo: '3d',
      content: "Princess treatment 😒 WhenThePhoneRings",
      likes: 10,
      comments: 3,
    ),
    ActivityItem(
      userId: '5',
      username: 'nisma_navas',
      profileImage: 'https://i.pravatar.cc/150?img=5',
      subtitle: 'Follow suggestion',
      timeAgo: '1w',
      isFollowing: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndexTab = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          preferredSize: const Size.fromHeight(50),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              indicator: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              dividerColor: Colors.transparent,
              tabs: [
                _buildTab('All'),
                _buildTab('Follows'),
                _buildTab('Replies'),
                _buildTab('Mentions'),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
            child: Text(
              'Previous',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _allActivities.length,
              itemBuilder: (context, index) {
                final activity = _allActivities[index];
                return _buildActivityItem(activity);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text),
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
                      const SizedBox(height: 4),
                      Text(
                        activity.content!,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (activity.isFollowing) ...[
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size.zero,
                  ),
                  child: Text(
                    'Following',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (activity.likes != null || activity.comments != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                _buildInteractionButton(Icons.favorite_border, activity.likes),
                const SizedBox(width: 16),
                _buildInteractionButton(Icons.chat_bubble_outline, activity.comments),
                const SizedBox(width: 16),
                _buildInteractionButton(Icons.repeat, null),
                const SizedBox(width: 16),
                _buildInteractionButton(Icons.send, null),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInteractionButton(IconData icon, int? count) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.black54),
        if (count != null && count > 0) ...[
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ],
      ],
    );
  }
}
