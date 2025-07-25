import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';



class GetHelpPage extends StatefulWidget {
  @override
  _GetHelpPageState createState() => _GetHelpPageState();
}

class _GetHelpPageState extends State<GetHelpPage> {
  final TextEditingController _textController = TextEditingController();

  final String phoneNumber = '+1234567890'; // <-- Replace with your number
  final String emailAddress = 'support@example.com'; // <-- Replace with your email

  void _makePhoneCall() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch phone dialer')),
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open email app')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text('Get Help'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: _makePhoneCall,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Type your message here...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _sendEmail,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
