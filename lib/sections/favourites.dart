import 'package:flutter/material.dart';
import 'package:music_app/allsongs_screens/lists_view_songs.dart';
import 'package:music_app/database/favoritedb.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: FavoriteDb.favoriteSongs,
      builder: (context, List<SongModel> favoriteData, Widget? child) {
        return Scaffold(
          body: ValueListenableBuilder(
            valueListenable: FavoriteDb.favoriteSongs,
            builder: (ctx, List<SongModel> favoriteData, Widget? child) {
              if (favoriteData.isEmpty) {
                return const Center(
                  child: Text('No Favorite Data',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                );
              } else {
                final temp = favoriteData.reversed.toList();
                favoriteData = temp.toSet().toList();
                return ListViewScreen(songModel: favoriteData);
              }
            },
          ),
        );
      },
    );
  }
}
