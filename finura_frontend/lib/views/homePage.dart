//import 'package:finura_frontend/views/finuraChatPage.dart';
import 'package:finura_frontend/views/finuraChatPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  final String userFirstName;
  final String userProfilePicUrl;

  final TextEditingController categoryController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String? selectedOption;

  HomePage({
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
        backgroundColor: const Color.fromARGB(255, 164, 245, 171),
        titleSpacing: 0,
        title: Row(
          children: [
            // User profile picture
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 16.0),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  userProfilePicUrl,
                ), // Replace with a local asset if needed
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

      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),

          width: double.infinity,
          //height: double.infinity, // Adjust height to fit the screen
          padding: const EdgeInsets.all(16.0),
          color: const Color.fromARGB(255, 235, 250, 235),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              // Box 1: Input Field
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    // Text fields for category and amount
                    TextField(
                      controller: categoryController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        hintText:
                            'Enter category here', // This should be changed when i found something better'
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: amountController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        hintText: 'Enter amount here',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: false,
                      ),
                      inputFormatters: [
                        // Allow only numbers and decimal point
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      hint: const Text('Select an option'),

                      items: const [
                        DropdownMenuItem(
                          value: 'ExpenseOption',
                          child: Text('Expense'),
                        ),
                        DropdownMenuItem(
                          value: 'IncomeOption',
                          child: Text('Income'),
                        ),
                      ],
                      onChanged: (value) {
                        selectedOption = value;
                        // Update the state or handle selection
                        // Handle selection
                      },
                    ),

                    //submit button
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle submit action
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),

              // Box 2: all app facilities icons
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 200.0, // Adjust height as needed

                  child: GridView.count(
                    shrinkWrap: true,
                    primary: false,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 16,
                    ),
                    crossAxisCount: 4,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // Icon 1: Settings icon button
                      GestureDetector(
                        onTap: () {
                          print("Icon 1 tapped"); //?need to change this
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/icons/settings.png',
                                width: 40,
                                height: 40,
                              ),
                            ),

                            const SizedBox(height: 8),
                            const Text(
                              'Setting',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      // Icon 2: Planning icon button
                      GestureDetector(
                        onTap: () {
                          print("Icon 2 tapped"); //?need to change this
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/icons/planning.png',
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Panning',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      // Icon 3: Dashboard icon button
                      GestureDetector(
                        onTap: () {
                          print("Icon 3 tapped"); //?need to change this
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/icons/dashboard.png',
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Dashboard',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      // Icon 4: histoy icon button
                      GestureDetector(
                        onTap: () {
                          print("Icon 4 tapped"); //?need to change this
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/icons/history.png',
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'History',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      // Icon 5: targeted icon button
                      GestureDetector(
                        onTap: () {
                          print("Icon 5 tapped"); //?need to change this
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/icons/targeted.png',
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Targeted',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),

                      // Icon 6: calendar icon button
                      GestureDetector(
                        onTap: () {
                          print("Icon 6 tapped"); //?need to change this
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/icons/calendar.png',
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Calendar',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      // Icon 7: help icon button
                      GestureDetector(
                        onTap: () {
                          print("Icon 7 tapped"); //?need to change this
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/icons/help-desk.png',
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(height: 8),
                            const Text('Help', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Box 3: Notification Display
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: double.infinity,
                height: 100.0, // Adjust height as needed
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  border: Border.all(color: Colors.orange),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Notification will appear here.', //?this should be changed with last notification
                  style: TextStyle(color: Colors.black87),
                ),
              ),

              // Box 4: finura chat box
              Container(
                width: double.infinity,
                height: 400.0,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    final TextEditingController _controller =
                        TextEditingController();
                    final ScrollController _scrollController =
                        ScrollController();
                    final List<String> messages = [
                      "Hi, I am Finuro. I am here to give you financial advice...",
                    ];

                    void _sendMessage() {
                      final text = _controller.text.trim();
                      if (text.isNotEmpty) {
                        setState(() {
                          messages.add(text);
                          _controller.clear();
                        });

                        // Auto-scroll to bottom
                        Future.delayed(const Duration(milliseconds: 100), () {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        });
                      }
                    }

                    return Column(
                      children: [
                        // Top Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(
                                'assets/finura_icon.webp',
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                "Finuro",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.fullscreen),
                              onPressed: () {
                                //Handle fullscreen action
                                //Optional fullscreen logic
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FinuraChatPage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Scrollable chat messages
                        Flexible(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final isBot = index == 0;
                              return Align(
                                alignment: isBot
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  constraints: const BoxConstraints(
                                    maxWidth: 250,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isBot
                                        ? Colors.grey.shade200
                                        : Colors.blue.shade100,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    messages[index],
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Input field and send button
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: TextField(
                                  controller: _controller,
                                  decoration: const InputDecoration(
                                    hintText: "Type your message...",
                                    border: InputBorder.none,
                                  ),
                                  onSubmitted: (_) => _sendMessage(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.blue,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: _sendMessage,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      // This is a simple bottom navigation bar with three icons
      // QR Scanner, Home, and Notification icons
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        color: const Color.fromARGB(255, 164, 245, 171),
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
