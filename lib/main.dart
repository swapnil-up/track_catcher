import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Track Catcher',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ShareReceiver(),
    );
  }
}

class ShareReceiver extends StatefulWidget {
  const ShareReceiver({super.key});

  @override
  State<ShareReceiver> createState() => _ShareReceiverState();
}

class _ShareReceiverState extends State<ShareReceiver> {
  static const platform = MethodChannel('com.trackcatcher/share');
  String sharedText = 'No song shared yet';

  void initState() {
    super.initState();
    _getSharedContent();
  }

  Future<void> _getSharedContent() async {
    try {
      final String result = await platform.invokeMethod('getShareData');
      setState(() {
        sharedText = result;
      });
    } on PlatformException catch (e) {
      print("failed to get shared content: ${e.message}");
    }
  }

  Map<String, String> parseSharedData(String data) {
    final parts = data.split(' by ');

    if (parts.length < 2) {
      return {'title': 'Unknown', 'artist': 'Unknown', 'link': 'Unknown'};
    }

    final title = parts[0].trim();
    final remainingParts = parts[1].split(' ');

    String artist = '';
    String link = 'Unknown';

    for (var part in remainingParts) {
      if (part.startsWith('https://')) {
        link = part.trim();
        break;
      } else {
        artist += (artist == 'Unknown' ? '' : ' ') + part.trim();
      }
    }

    return {
      'title': title,
      'artist': artist,
      'link': link,
    };
  }

  @override
  Widget build(BuildContext context) {
    final songData = parseSharedData(sharedText);
    return Scaffold(
      appBar: AppBar(title: Text("Track Catcher")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SelectableText(
              songData['title'] ?? 'N/A',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Artist:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SelectableText(
              songData['artist'] ?? 'N/A',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Link:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                // Open the link (optional step for later)
              },
              child: Text(
                songData['link'] ?? 'N/A',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
