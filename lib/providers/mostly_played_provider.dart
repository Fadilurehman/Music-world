import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../sections/search.dart';

class MostlyProvider with ChangeNotifier {
  List<SongModel> mostlyPlayedNotifier = [];
  List<dynamic> mostlyPlayed = [];
  // static List<SongModel> mostlyPlayedsongs = [];

  Future<void> addMostlyPlayed(item) async {
    final mostlyplayedDb = await Hive.openBox('MostlyPlayedNotifier');
    await mostlyplayedDb.add(item);
    getMostlyplayed();
    notifyListeners();
  }

  Future<void> getMostlyplayed() async {
    final mostlyplayedDb = await Hive.openBox('MostlyPlayedNotifier');
    mostlyPlayed = mostlyplayedDb.values.toList();
    displayMostlyPlayed();
    notifyListeners();
  }

  Future<List> displayMostlyPlayed() async {
    final mostlyPlayedDb = await Hive.openBox('MostlyPlayedNotifier');
    final mostlyPlayedItems = mostlyPlayedDb.values.toList();
    mostlyPlayedNotifier.clear();
    int count = 0;
    for (var i = 0; i < mostlyPlayedItems.length; i++) {
      for (var j = 0; j < mostlyPlayedItems.length; j++) {
        if (mostlyPlayedItems[i] == mostlyPlayedItems[j]) {
          count++;
        }
      }
      if (count > 3) {
        for (var k = 0; k < allsongs.length; k++) {
          if (mostlyPlayedItems[i] == allsongs[k].id) {
            mostlyPlayedNotifier.add(allsongs[k]);
            mostlyPlayed.add(allsongs[k]);
          }
        }
        count = 0;
      }
    }
    return mostlyPlayed;
  }
}
