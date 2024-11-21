import 'dart:async';
import 'dart:convert';
import 'dart:io';

class YoutubeLinkFetcher {
  Future<String> fetchYoutubeLink(String songName, String artistName) async {
    try {
      final process = await Process.start(
        'python3',
        ['lib/get_youtube_link.py', songName, artistName],
        runInShell: true,
      );

      final output = await process.stdout.transform(utf8.decoder).join();
      final error = await process.stderr.transform(utf8.decoder).join();

      if (error.isNotEmpty) {
        throw Exception('Error running script: $error');
      }

      return output.trim();
    } catch (e) {
      print('Error fetching YouTube link: $e');
      return 'Error';
    }
  }
}
