import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart%20';
import 'package:music_app/providers/favourite_db.dart';
import 'package:provider/provider.dart';

import '../database/model_db.dart';
import '../splash_screen/splash.dart';

class PlayListProvider with ChangeNotifier {
  List<MusicWorld> playlistNotifier = [];
  final playlistDb = Hive.box<MusicWorld>('playlistDb');

  Future<void> addPlaylist(MusicWorld value) async {
    final playlistDb = Hive.box<MusicWorld>('playlistDb');
    await playlistDb.add(value);
    playlistNotifier.add(value);
  }

  Future<void> getAllPlaylist() async {
    final playlistDb = Hive.box<MusicWorld>('playlistDb');
    playlistNotifier.clear();
    playlistNotifier.addAll(playlistDb.values);
    notifyListeners();
  }

  Future<void> editPlaylist(int index, MusicWorld value) async {
    final playlistDb = Hive.box<MusicWorld>('playlistDb');
    await playlistDb.putAt(index, value);
    getAllPlaylist();
  }

  Future<void> resetAPP(context) async {
    final playListDb = Hive.box<MusicWorld>('playlistDb');
    final musicDb = Hive.box<int>('FavoriteDB');
    final recentDb = Hive.box('recentSongNotifier');
    final mostlyPlayedDb = await Hive.openBox('MostlyPlayedNotifier');
    await musicDb.clear();
    await playListDb.clear();
    await recentDb.clear();
    await mostlyPlayedDb.clear();

    Provider.of<FavoriteDb>(context, listen: false).favoriteSongs.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        ),
        (route) => false);
  }
}
