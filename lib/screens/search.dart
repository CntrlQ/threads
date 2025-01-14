import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thread_clone_flutter/model/user.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();
  String searchQuery = "";
  List<Map<String, dynamic>> fakeUsers = [
    {
      'username': 'thedesignely',
      'name': 'UI UX Designer | Agatha',
      'followers': '11.3K',
      'profileImageUrl': 'https://i.pravatar.cc/150?img=1',
      'isVerified': false,
    },
    {
      'username': 'lets_desgyn',
      'name': "Let's Design",
      'followers': '44.9K',
      'profileImageUrl': 'https://i.pravatar.cc/150?img=2',
      'isVerified': false,
    },
    {
      'username': 'muslimgirl',
      'name': 'Muslim Girl',
      'followers': '74K',
      'profileImageUrl': 'https://i.pravatar.cc/150?img=3',
      'isVerified': true,
    },
    {
      'username': 'iqonicdesign',
      'name': 'Iqonic Design',
      'followers': '26.9K',
      'profileImageUrl': 'https://i.pravatar.cc/150?img=4',
      'isVerified': false,
    },
    {
      'username': 'logo.tutorials',
      'name': 'logo tutorials',
      'followers': '117K',
      'profileImageUrl': 'https://i.pravatar.cc/150?img=5',
      'isVerified': false,
    },
    {
      'username': 'graphicdesign.tutorials',
      'name': 'graphic design tutorials',
      'followers': '197K',
      'profileImageUrl': 'https://i.pravatar.cc/150?img=6',
      'isVerified': false,
    },
    {
      'username': 'females',
      'name': 'Females',
      'followers': '535K',
      'profileImageUrl': 'https://i.pravatar.cc/150?img=7',
      'isVerified': true,
    },
  ];

  List<Map<String, dynamic>> get filteredUsers {
    if (searchQuery.isEmpty) return fakeUsers;
    return fakeUsers.where((user) {
      return user['username'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          user['name'].toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(user['profileImageUrl']),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    user['username'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (user['isVerified'])
                                    const Padding(
                                      padding: EdgeInsets.only(left: 4.0),
                                      child: Icon(Icons.verified, color: Colors.blue, size: 16),
                                    ),
                                ],
                              ),
                              Text(
                                user['name'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                '${user['followers']} followers',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Follow',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

