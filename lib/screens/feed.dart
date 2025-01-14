import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:thread_clone_flutter/model/thread_message.dart';
import 'package:thread_clone_flutter/screens/post_comment_screen.dart';
import 'package:thread_clone_flutter/widgets/thread_message.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final ScrollController _scrollController = ScrollController();
  String threadDoc = '';
  PanelController panelController = PanelController();
  bool _isLoading = false;

  final List<ThreadMessage> _fakePosts = [
    ThreadMessage(
      id: '1',
      senderId: 'user1',
      senderName: 'nuui.h',
      senderProfileImageUrl: 'https://i.pravatar.cc/150?img=1',
      message: "What's new?",
      imageUrl: 'https://picsum.photos/500/300?random=1',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      likes: [],
      comments: [],
    ),
    ThreadMessage(
      id: '2',
      senderId: 'user2',
      senderName: 'ghibliarchives',
      senderProfileImageUrl: 'https://i.pravatar.cc/150?img=2',
      message: "Film: Kiki's Delivery Service (1989)",
      imageUrl: 'https://picsum.photos/500/300?random=2',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      likes: [],
      comments: [],
    ),
    ThreadMessage(
      id: '3',
      senderId: 'user3',
      senderName: 'norhudaifha0713',
      senderProfileImageUrl: 'https://i.pravatar.cc/150?img=3',
      message: "Yo, ooh this drama breaks me everyday. I want your buy 🥲",
      imageUrl: 'https://picsum.photos/500/300?random=3',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      likes: [],
      comments: [],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading) {
      // Load more posts if needed
    }
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 3,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120,
                          height: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 12,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        ),
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
        title: Image.asset(
          'assets/threads_logo.png',
          height: 32,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SlidingUpPanel(
          controller: panelController,
          minHeight: 0,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          panelBuilder: (ScrollController sc) {
            return PostCommentScreen(
              threadDoc: threadDoc,
              panelController: panelController,
            );
          },
          body: RefreshIndicator(
            color: Colors.black,
            onRefresh: () async {
              setState(() {});
              return Future.delayed(const Duration(seconds: 1));
            },
            child: AnimationLimiter(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _fakePosts.length,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: ThreadMessageWidget(
                            message: _fakePosts[index],
                            onLike: () {},
                            onDisLike: () {},
                            onComment: () {
                              setState(() {
                                threadDoc = _fakePosts[index].id;
                              });
                              panelController.open();
                            },
                            panelController: panelController,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
