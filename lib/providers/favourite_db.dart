import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoriteDb with ChangeNotifier {
  bool isInitialized = false;
  final musicDb = Hive.box<int>('FavoriteDB');
  List<SongModel> favoriteSongs = [];

  initialize(List<SongModel> songs) {
    for (SongModel song in songs) {
      if (isFavor(song)) {
        favoriteSongs.add(song);
      }
    }
    isInitialized = true;
  }

  bool _isGrid = false;
  bool get isGrid => _isGrid;

  void gridList() {
    _isGrid = !_isGrid;
    notifyListeners();
  }

  isFavor(SongModel song) {
    if (musicDb.values.contains(song.id)) {
      return true;
    }
    return false;
  }

  add(SongModel song) async {
    musicDb.add(song.id);
    favoriteSongs.add(song);
    notifyListeners();
  }

  delete(int id) async {
    int deletekey = 0;
    if (!musicDb.values.contains(id)) {
      return;
    }
    final Map<dynamic, int> favorMap = musicDb.toMap();
    favorMap.forEach((key, value) {
      if (value == id) {
        deletekey = key;
      }
    });
    musicDb.delete(deletekey);
    favoriteSongs.removeWhere((song) => song.id == id);
    notifyListeners();
  }

  // static clear() async {
  //   FavoriteDb.favoriteSongs.clear();
  // }
}
