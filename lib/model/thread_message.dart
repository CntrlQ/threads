// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ThreadMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String senderProfileImageUrl;
  final String message;
  final String? imageUrl;
  final DateTime timestamp;
  final List likes;
  final List comments;

  ThreadMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderProfileImageUrl,
    required this.message,
    this.imageUrl,
    required this.timestamp,
    required this.likes,
    required this.comments,
  });

  get senderId => null;

  get imageUrl => null;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'senderProfileImageUrl': senderProfileImageUrl,
      'message': message,
      'imageUrl': imageUrl,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'likes': likes,
      'comments': comments
    };
  }

  factory ThreadMessage.fromMap(Map<String, dynamic> map) {
    return ThreadMessage(
      id: map['id'] as String,
      senderId: map['senderId'] as String,
      senderName: map['senderName'] as String,
      senderProfileImageUrl: map['senderProfileImageUrl'] as String,
      message: map['message'] as String,
      imageUrl: map['imageUrl'] as String?,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      likes: List.from((map['likes'] as List)),
      comments: List.from((map['comments'] as List)),
    );
  }

  String toJson() => json.encode(toMap());

  factory ThreadMessage.fromJson(String source) =>
      ThreadMessage.fromMap(json.decode(source) as Map<String, dynamic>);

  factory ThreadMessage.empty() {
    return ThreadMessage(
        id: '',
        senderId: '',
        senderName: '',
        senderProfileImageUrl: '',
        message: '',
        timestamp: DateTime.now(),
        likes: [],
        comments: []);
  }
}
