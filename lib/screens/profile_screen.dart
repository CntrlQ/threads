import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:thread_clone_flutter/model/thread_message.dart';
import 'package:thread_clone_flutter/model/user.dart';
import 'package:thread_clone_flutter/screens/edit_profile.dart';
import 'package:thread_clone_flutter/widgets/thread_message.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  PanelController panelController = PanelController();
  late TabController _tabController;
  bool isPanelOpen = false;

  final UserModel _fakeUser = UserModel(
    id: '1',
    name: 'John Doe',
    username: 'johndoe',
    profileImageUrl: 'https://i.pravatar.cc/150?img=3',
    bio: 'Flutter Developer | Coffee Lover ☕️ | Building awesome apps',
    followers: ['user1', 'user2', 'user3'],
    following: ['user4', 'user5'],
  );

  final List<ThreadMessage> _fakeThreads = [
    ThreadMessage(
      id: '1',
      senderId: '1',
      senderName: 'John Doe',
      senderProfileImageUrl: 'https://i.pravatar.cc/150?img=3',
      message: 'Just shipped a new feature! 🚀',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      likes: ['user1', 'user2'],
      comments: ['Great job!', 'Amazing work!'],
    ),
    ThreadMessage(
      id: '2',
      senderId: '1',
      senderName: 'John Doe',
      senderProfileImageUrl: 'https://i.pravatar.cc/150?img=3',
      message: 'Flutter is amazing for building cross-platform apps 💙',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      likes: ['user3'],
      comments: ['Totally agree!'],
    ),
    ThreadMessage(
      id: '3',
      senderId: '1',
      senderName: 'John Doe',
      senderProfileImageUrl: 'https://i.pravatar.cc/150?img=3',
      message: 'Working on something exciting! Stay tuned 👨‍💻',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      likes: [],
      comments: [],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SlidingUpPanel(
          controller: panelController,
          minHeight: 0,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          panelBuilder: (ScrollController sc) {
            return EditProfile(
              panelController: panelController,
              user: _fakeUser,
            );
          },
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      _fakeUser.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '@${_fakeUser.username}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    trailing: CircleAvatar(
                      backgroundImage: NetworkImage(_fakeUser.profileImageUrl ?? 'https://i.pravatar.cc/150?img=3'),
                      radius: 25,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _fakeUser.bio ?? 'User Bio',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        '${_fakeUser.followers.length} followers',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${_fakeUser.following.length} following',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            if (isPanelOpen) {
                              panelController.close();
                            } else {
                              panelController.open();
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Edit profile',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Share profile',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.black,
                    tabs: const [
                      Tab(text: 'Threads'),
                      Tab(text: 'Replies'),
                      Tab(text: 'Reposts'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Threads Tab
                        ListView.builder(
                          itemCount: _fakeThreads.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: ThreadMessageWidget(
                                message: _fakeThreads[index],
                                onLike: () {},
                                onDisLike: () {},
                                onComment: () {},
                                panelController: panelController,
                              ),
                            );
                          },
                        ),
                        // Replies Tab
                        const Center(
                          child: Text(
                            'No replies yet',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        // Reposts Tab
                        const Center(
                          child: Text(
                            'No reposts yet',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
