import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GetHelpPage extends StatefulWidget {
  @override
  _GetHelpPageState createState() => _GetHelpPageState();
}

class _GetHelpPageState extends State<GetHelpPage> {
  final TextEditingController _textController = TextEditingController();

  final String phoneNumber = '+1234567890'; // <-- Replace with your number
  final String emailAddress =
      'support@example.com'; // <-- Replace with your email

  void _makePhoneCall() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not launch phone dialer')));
    }
  }

  void _sendEmail() async {
    final String message = _textController.text.trim();
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
      query: Uri.encodeFull('subject=Help Request&body=$message'),
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not open email app')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(alignment: Alignment.centerLeft, child: Text('Get Help')),
        actions: [
          IconButton(icon: Icon(Icons.call), onPressed: _makePhoneCall),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade100, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.support_agent, size: 64, color: Colors.blue),

              //Icon(FontAwesomeIcons.userHeadset, size: 32.0, color: Colors.blue),
              SizedBox(height: 8),
              Text(
                'How can we help you?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Your TextField and button go here
              TextField(
                controller: _textController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Type your message here...',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              ElevatedButton(onPressed: _sendEmail, child: Text('Submit')),
            ],
          ),
        ),
      ),
    );
  }
}
