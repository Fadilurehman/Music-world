import 'package:flutter/material.dart';
import 'package:music_app/allsongs_screens/lists_view_songs.dart';
import 'package:music_app/controller/most_played_song.dart';
import 'package:music_app/database/favoritedb.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MostlyPlayed extends StatefulWidget {
  const MostlyPlayed({super.key});

  @override
  State<MostlyPlayed> createState() => _MostlyPlayedState();
}

class _MostlyPlayedState extends State<MostlyPlayed> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  static List<SongModel> mostlyPlayed = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async {
    await GetMostlyPlayedController.getMostlyplayed();
  }

  @override
  Widget build(BuildContext context) {
    FavoriteDb.favoriteSongs;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: FutureBuilder(
            future: GetMostlyPlayedController.getMostlyplayed(),
            builder: (context, items) {
              return ValueListenableBuilder(
                  valueListenable:
                      GetMostlyPlayedController.mostlyPlayedNotifier,
                  builder: (context, List<SongModel> value, Widget? child) {
                    if (value.isEmpty) {
                      return const Center(
                        child: Text('No Mostly Songs',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      );
                    } else {
                      final temp = value.reversed.toList();
                      mostlyPlayed = temp.toSet().toList();
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
                                songModel: mostlyPlayed,
                                isMostly: true,
                                recentLength: mostlyPlayed.length > 8
                                    ? 8
                                    : mostlyPlayed.length);
                          });
                    }
                  });
            }),
      ),
    );
  }
}
