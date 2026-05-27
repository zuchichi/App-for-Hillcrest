import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final _messageController = TextEditingController();
  String selectedAttachment = 'No file attached';

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendSupportEmail() async {
    final body = Uri.encodeComponent(_messageController.text.trim());
    final uri = Uri.parse(
      'mailto:support@hillcrest.org?subject=Ride App Help&body=$body',
    );
    if (!await launchUrl(uri)) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open email app.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Need help with rides? Send support details below.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _messageController,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: 'Support message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      selectedAttachment =
                          'Attachment selected (demo placeholder)';
                    });
                  },
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Attach file'),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(selectedAttachment)),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _sendSupportEmail,
                icon: const Icon(Icons.send),
                label: const Text('Send to support email'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
