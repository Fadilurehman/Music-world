import 'package:flutter/material.dart';
import 'package:music_app/allsongs_screens/lists_view_songs.dart';
import 'package:music_app/providers/favourite_db.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteDb>(
      builder: (context, favoriteData, Widget? child) {
        return Scaffold(
          body: Consumer<FavoriteDb>(
            builder: (context, favoriteData, Widget? child) {
              if (favoriteData.favoriteSongs.isEmpty) {
                return const Center(
                  child: Text('No Favorite Data',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                );
              } else {
                final temp = favoriteData.favoriteSongs.reversed.toList();
                List<SongModel> favoriteDatas = temp.toSet().toList();
                return ListViewScreen(songModel: favoriteDatas);
              }
            },
          ),
        );
      },
    );
  }
}
