import 'package:flutter/material.dart';
import 'package:music_app/allsongs_screens/lists_view_songs.dart';
import 'package:music_app/providers/mostly_played_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../providers/favourite_db.dart';

class MostlyPlayed extends StatefulWidget {
  const MostlyPlayed({super.key});

  @override
  State<MostlyPlayed> createState() => _MostlyPlayedState();
}

class _MostlyPlayedState extends State<MostlyPlayed> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  static List<SongModel> mostlyPlayed = [];

  // @override
  // void initState() {
  //   init();
  //   super.initState();
  // }

  // Future init() async {
  //   await GetMostlyPlayedController.getMostlyplayed();
  // }

  @override
  Widget build(BuildContext context) {
    Provider.of<FavoriteDb>(context, listen: false).favoriteSongs;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: FutureBuilder(
            future: Provider.of<MostlyProvider>(context, listen: false)
                .getMostlyplayed(),
            builder: (context, items) {
              return Consumer<MostlyProvider>(
                  builder: (context, value, Widget? child) {
                if (value.mostlyPlayedNotifier.isEmpty) {
                  return const Center(
                    child: Text('No Mostly Songs',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  );
                } else {
                  final temp = value.mostlyPlayedNotifier.reversed.toList();
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
