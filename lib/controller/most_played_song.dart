import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_app/allsongs_screens/all_songs.dart';
import 'package:on_audio_query/on_audio_query.dart';

class GetMostlyPlayedController {
  static ValueNotifier<List<SongModel>> mostlyPlayedNotifier =
      ValueNotifier([]);
  static List<dynamic> mostlyPlayed = [];
  // static List<SongModel> mostlyPlayedsongs = [];

  static Future<void> addMostlyPlayed(item) async {
    final mostlyplayedDb = await Hive.openBox('MostlyPlayedNotifier');
    await mostlyplayedDb.add(item);
    getMostlyplayed();
    mostlyPlayedNotifier.notifyListeners();
  }

  static Future<void> getMostlyplayed() async {
    final mostlyplayedDb = await Hive.openBox('MostlyPlayedNotifier');
    mostlyPlayed = mostlyplayedDb.values.toList();
    displayMostlyPlayed();
    mostlyPlayedNotifier.notifyListeners();
  }

  static Future<List> displayMostlyPlayed() async {
    final mostlyPlayedDb = await Hive.openBox('MostlyPlayedNotifier');
    final mostlyPlayedItems = mostlyPlayedDb.values.toList();
    mostlyPlayedNotifier.value.clear();
    int count = 0;
    for (var i = 0; i < mostlyPlayedItems.length; i++) {
      for (var j = 0; j < mostlyPlayedItems.length; j++) {
        if (mostlyPlayedItems[i] == mostlyPlayedItems[j]) {
          count++;
        }
      }
      if (count > 3) {
        for (var k = 0; k < startSongs.length; k++) {
          if (mostlyPlayedItems[i] == startSongs[k].id) {
            mostlyPlayedNotifier.value.add(startSongs[k]);
            mostlyPlayed.add(startSongs[k]);
          }
        }
        count = 0;
      }
    }
    return mostlyPlayed;
  }
}
