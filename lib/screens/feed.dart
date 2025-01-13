import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:thread_clone_flutter/model/thread_message.dart';
import 'package:thread_clone_flutter/screens/comment_screen.dart';
import 'package:thread_clone_flutter/screens/post_comment_screen.dart';
import 'package:thread_clone_flutter/widgets/thread_message.dart';

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

  String threadDoc = '';
  PanelController panelController = PanelController();

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

  Widget _buildPost({
    required String profileImage,
    required String username,
    required String caption,
    required List<String> postImages,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(profileImage),
                radius: 20,
              ),
              const SizedBox(width: 10),
              Text(
                username,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            caption,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: postImages.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      postImages[index],
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
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
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              _buildPost(
                profileImage: 'https://i.pravatar.cc/150?img=1',
                username: 'nuui.h',
                caption: "New year, New me.",
                postImages: ['assets/ref1.jpg', 'assets/ref2.jpg', 'assets/ref3.jpg'],
              ),
              const SizedBox(height: 16),
              _buildPost(
                profileImage: 'https://i.pravatar.cc/150?img=2',
                username: 'ghibliarchives',
                caption: "Film: Kiki's Delivery Service (1989)",
                postImages: ['assets/oki1.jpg', 'assets/oki2.jpg'],
              ),
              const SizedBox(height: 16),
              _buildPost(
                profileImage: 'https://i.pravatar.cc/150?img=3',
                username: 'nihal',
                caption: "Yo, ooh this drama breaks me everyday. I want to eat your pancreas🥲",
                postImages: ['assets/ref1.jpg', 'assets/oki1.jpg'],
              ),
               const SizedBox(height: 16),
              // _buildPost(
              //   profileImage: 'https://i.pravatar.cc/150?img=2',
              //   username: 'ghibliarchives',
              //   caption: "Film: Kiki's Delivery Service (1989)",
              //   postImages: ['assets/oki1.jpg', 'assets/oki2.jpg'],
              // ),
              const SizedBox(height: 16),
            ],
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
