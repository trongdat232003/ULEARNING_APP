import 'package:flutter/material.dart';
import 'package:ulearning_app/common/service/friendService.dart';
import 'package:ulearning_app/common/service/userService.dart';
import 'package:ulearning_app/page/chat/pages/chat_page.dart';

class FriendListPage extends StatefulWidget {
  @override
  _FriendListPageState createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {
  late Future<List<Map<String, dynamic>>> _friendsFuture;
  String? _currentUserId; // Store the current user ID

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load current user's data and friends list
  Future<void> _loadUserData() async {
    String? token = await UserService.getToken();
    if (token == null) {
      print("Token không tồn tại!");
      return;
    }

    var userData = await UserService.getuserProfile(token);
    if (userData['success']) {
      setState(() {
        _currentUserId = userData['data']['_id']; // Fetch current user ID
        _friendsFuture = FriendService.getFriends(token); // Fetch friends list
      });
    } else {
      print("Lỗi khi lấy thông tin người dùng!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Friends",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                  offset: Offset(1, 1), blurRadius: 4, color: Colors.black38),
            ],
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 4.0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, size: 28),
            onPressed: () {
              // This action could be used for a search functionality if needed
              print("Search action triggered");
            },
          ),
        ],
      ),
      body: _currentUserId == null
          ? _buildLoadingState()
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: _friendsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingState();
                } else if (snapshot.hasError) {
                  return _buildErrorState();
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState();
                }

                List<Map<String, dynamic>> friends = snapshot.data!;

                return _buildFriendList(friends);
              },
            ),
    );
  }

  // Widget to display loading state
  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  // Widget to display error state
  Widget _buildErrorState() {
    return Center(
      child: Text(
        "Error loading friends list!",
        style: TextStyle(color: Colors.red, fontSize: 16),
      ),
    );
  }

  // Widget to display empty state when no friends
  Widget _buildEmptyState() {
    return Center(
      child: Text(
        "You have no friends yet.",
        style: TextStyle(color: Colors.grey, fontSize: 16),
      ),
    );
  }

  // Widget to build the list of friends
  Widget _buildFriendList(List<Map<String, dynamic>> friends) {
    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Rounded corners
          ),
          elevation: 6, // Subtle shadow effect
          child: ListTile(
            contentPadding: EdgeInsets.all(16.0),
            leading: CircleAvatar(
              radius: 30.0,
              backgroundImage: friends[index]['avatar'].isNotEmpty
                  ? NetworkImage(friends[index]['avatar'])
                  : AssetImage("assets/icons/person.png")
                      as ImageProvider, // Default avatar if no image
            ),
            title: Text(
              friends[index]['name'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            subtitle: Text(
              friends[index]['email'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    senderId: _currentUserId!, // Correct senderId
                    receiverId: friends[index]['_id'], // Friend's ID
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
