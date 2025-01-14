import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:thread_clone_flutter/model/thread_message.dart';
// import 'package:thread_clone_flutter/model/thread_message.dart';
// import 'package:thread_clone_flutter/screens/comment_screen.dart';
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
  final CollectionReference threadCollection =
      FirebaseFirestore.instance.collection('threads');
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final ScrollController _scrollController = ScrollController();
  final bool _isLoading = false;

  String threadDoc = '';
  PanelController panelController = PanelController();

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
      // Load more posts
      _loadMorePosts();
    }
  }

  Future<void> _loadMorePosts() async {
    // Implement pagination logic here
  }

  Future<String> getSenderImageUrl(String id) async {
    try {
      final userDoc = await userCollection.doc(id).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        return (userData['profileImageUrl'] ?? 'assets/dp.jpeg').toString();
      } else {
        return 'assets/dp.jpeg';
      }
    } catch (e) {
      debugPrint('Error fetching sender image URL: $e');
      return 'assets/dp.jpeg';
    }
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
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
                          width: 100,
                          height: 12,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 8,
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
                height: 200,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              const Divider(),
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
            onRefresh: () async {
              // Implement refresh logic
            },
            child: StreamBuilder<QuerySnapshot>(
              stream: threadCollection
                  .orderBy('timestamp', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingShimmer();
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No threads yet'),
                  );
                }

                return AnimationLimiter(
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final threadMessage = ThreadMessage.fromMap(data);

                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: ThreadMessageWidget(
                              message: threadMessage,
                              onLike: () => likeThreadMessage(doc.id),
                              onDisLike: () => dislikeThreadMessage(doc.id),
                              onComment: () => setState(() => threadDoc = doc.id),
                              panelController: panelController, senderId: threadMessage.senderId,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: OpenContainer(
        transitionDuration: const Duration(milliseconds: 500),
        openBuilder: (context, _) => PostCommentScreen(
          threadDoc: '',
          panelController: panelController,
        ),
        closedShape: const CircleBorder(),
        closedColor: Colors.black,
        closedBuilder: (context, openContainer) => FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: openContainer,
          child: const Icon(
            Icons.edit,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> likeThreadMessage(String id) async {
    try {
      await threadCollection.doc(id).update({
        'likes': FieldValue.arrayUnion([userId])
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> dislikeThreadMessage(String id) async {
    try {
      await threadCollection.doc(id).update({
        'likes': FieldValue.arrayRemove([userId])
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
