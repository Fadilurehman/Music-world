import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../allsongs_screens/all_songs.dart';

class Recentlyprovider with ChangeNotifier {
  List<SongModel> recentSongNotifier = [];
  List<dynamic> recentlyPlayed = [];

  Future<void> addRecentlyPlayed(item) async {
    final recentDb = await Hive.openBox('recentSongNotifier');
    await recentDb.add(item);
    getRecentSongs();
    notifyListeners();
  }

  Future<void> getRecentSongs() async {
    final recentDb = await Hive.openBox('recentSongNotifier');
    recentlyPlayed = recentDb.values.toList();
    displayRecents();
    notifyListeners();
  }

  Future<void> displayRecents() async {
    final recentDb = await Hive.openBox('recentSongNotifier');
    final recentSongItems = recentDb.values.toList();
    recentSongNotifier.clear();
    recentlyPlayed.clear();
    for (int i = 0; i < recentSongItems.length; i++) {
      for (int j = 0; j < startSongs.length; j++) {
        if (recentSongItems[i] == startSongs[j].id) {
          recentSongNotifier.add(startSongs[j]); //uimttmvran
          recentlyPlayed.add(startSongs[j]);
        }
      }
    }
  }
}
