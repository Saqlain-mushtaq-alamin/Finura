import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String userFirstName;
  final String userProfilePicUrl;

  const HomePage({
    Key? key,
    required this.userFirstName,
    required this.userProfilePicUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: Row(
          children: [
            // User profile picture
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(userProfilePicUrl),
                backgroundColor: Colors.grey[200],
              ),
            ),
            // User first name
            Text(
              userFirstName,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const Spacer(),
            // Target icon (rightmost)
            IconButton(
              icon: const Icon(Icons.track_changes, color: Colors.black),
              onPressed: () {
                // Handle target icon tap
              },
            ),
          ],
        ),
      ),
      body: Container(), // No body content for now 
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // QR Scanner icon (left)
              IconButton(
                icon: const Icon(Icons.qr_code_scanner, size: 28),
                onPressed: () {
                  // Handle QR scanner tap
                },
              ),
              // Home icon (center)
              IconButton(
                icon: const Icon(Icons.home, size: 32),
                onPressed: () {
                  // Handle home tap
                },
              ),
              // Notification icon (right)
              IconButton(
                icon: const Icon(Icons.notifications, size: 28),
                onPressed: () {
                  // Handle notification tap
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
