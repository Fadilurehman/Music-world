import 'package:flutter/material.dart';
import 'package:music_app/allsongs_screens/lists_view_songs.dart';
import 'package:music_app/database/favoritedb.dart';
import 'package:music_app/controller/recent_song_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class RecentlyPlayed extends StatefulWidget {
  const RecentlyPlayed({super.key});

  @override
  State<RecentlyPlayed> createState() => _RecentlyPlayedState();
}

class _RecentlyPlayedState extends State<RecentlyPlayed> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  static List<SongModel> recentSong = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async {
    await GetRecentSongController.getRecentSongs();
  }

  @override
  Widget build(BuildContext context) {
    FavoriteDb.favoriteSongs;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: FutureBuilder(
            future: GetRecentSongController.getRecentSongs(),
            builder: (context, items) {
              return ValueListenableBuilder(
                valueListenable: GetRecentSongController.recentSongNotifier,
                builder: (context, List<SongModel> value, Widget? child) {
                  if (value.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Recent Songs',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    );
                  } else {
                    final temp = value.reversed.toList();
                    recentSong = temp.toSet().toList();
                    return FutureBuilder<List<SongModel>>(
                        future: audioQuery.querySongs(
                          sortType: null,
                          orderType: OrderType.ASC_OR_SMALLER,
                          uriType: UriType.EXTERNAL,
                          ignoreCase: true,
                        ),
                        builder: (context, items) {
                          if (items.data == null) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (items.data!.isEmpty) {
                            return const Center(
                              child: Text(
                                'No songs available',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }
                          return ListViewScreen(
                            songModel: recentSong,
                            isRecent: true,
                            recentLength:
                                recentSong.length > 8 ? 8 : recentSong.length,
                          );
                        });
                  }
                },
              );
            }),
      ),
    );
  }
}
