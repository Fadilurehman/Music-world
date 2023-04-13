// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:music_app/allsongs_screens/all_songs.dart';
// import 'package:on_audio_query/on_audio_query.dart';

// class GetRecentSongController extends ChangeNotifier {
//   static ValueNotifier<List<SongModel>> recentSongNotifier = ValueNotifier([]);
//   static List<dynamic> recentlyPlayed = [];

//   static Future<void> addRecentlyPlayed(item) async {
//     final recentDb = await Hive.openBox('recentSongNotifier');
//     await recentDb.add(item);
//     getRecentSongs();
//     recentSongNotifier.notifyListeners();
//   }

//   static Future<void> getRecentSongs() async {
//     final recentDb = await Hive.openBox('recentSongNotifier');
//     recentlyPlayed = recentDb.values.toList();
//     displayRecents();
//     recentSongNotifier.notifyListeners();
//   }

//   static Future<void> displayRecents() async {
//     final recentDb = await Hive.openBox('recentSongNotifier');
//     final recentSongItems = recentDb.values.toList();
//     recentSongNotifier.value.clear();
//     recentlyPlayed.clear();
//     for (int i = 0; i < recentSongItems.length; i++) {
//       for (int j = 0; j < startSongs.length; j++) {
//         if (recentSongItems[i] == startSongs[j].id) {
//           recentSongNotifier.value.add(startSongs[j]); //uimttmvran
//           recentlyPlayed.add(startSongs[j]);
//         }
//       }
//     }
//   }
// }
