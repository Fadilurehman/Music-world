import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:music_app/database/favoritedb.dart';
import 'package:music_app/database/model_db.dart';
import 'package:music_app/splash_screen/splash.dart';

class PlaylistDb extends ChangeNotifier {
  static ValueNotifier<List<MusicWorld>> playlistNotifier = ValueNotifier([]);
  static final playlistDb = Hive.box<MusicWorld>('playlistDb');

  static Future<void> addPlaylist(MusicWorld value) async {
    final playlistDb = Hive.box<MusicWorld>('playlistDb');
    await playlistDb.add(value);
    playlistNotifier.value.add(value);
  }

  static Future<void> getAllPlaylist() async {
    final playlistDb = Hive.box<MusicWorld>('playlistDb');
    playlistNotifier.value.clear();
    playlistNotifier.value.addAll(playlistDb.values);
    playlistNotifier.notifyListeners();
  }

  // static Future<void> deletePlaylist(int index) async {
  //   final playlistDb = Hive.box<MusicWorld>('playlistDb');
  //   await playlistDb.deleteAt(index);
  //   getAllPlaylist();
  // }

  static Future<void> editPlaylist(int index, MusicWorld value) async {
    final playlistDb = Hive.box<MusicWorld>('playlistDb');
    await playlistDb.putAt(index, value);
    getAllPlaylist();
  }

  static Future<void> resetAPP(context) async {
    final playListDb = Hive.box<MusicWorld>('playlistDb');
    final musicDb = Hive.box<int>('FavoriteDB');
    final recentDb = Hive.box('recentSongNotifier');
    final mostlyPlayedDb = await Hive.openBox('MostlyPlayedNotifier');
    await musicDb.clear();
    await playListDb.clear();
    await recentDb.clear();
    await mostlyPlayedDb.clear();

    FavoriteDb.favoriteSongs.value.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        ),
        (route) => false);
  }
}
