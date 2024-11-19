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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Track Catcher")),
      body: Center(child: Text(sharedText)),
    );
  }
}
