import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/allsongs_screens/gridview_song.dart';
import 'package:music/allsongs_screens/lists_view_songs.dart';
import 'package:music/providers/all_song_provider.dart';
import 'package:music/controller/get_all_song_controller.dart';
import 'package:music/home_screen.dart';
import 'package:music/providers/favourite_db.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'mini_player.dart';

List<SongModel> startSongs = [];

// ignore: must_be_immutable
class AllSongs extends StatelessWidget {
  AllSongs({super.key});

  bool isGrid = false;

  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isFavorite = false;
  bool isFav = false;
  List<SongModel> allSongs = [];

  // @override
  // void initState() {
  //   super.initState();
  //   requestPermission();
  // }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AllsongsProvider>(context, listen: false).requestPermission();
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 141, 12, 167),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<FavoriteDb>(context, listen: false).gridList();
                // setState(() {
                //   isGrid = !isGrid;
                // });
              },
              icon: isGrid
                  ? const Icon(
                      Icons.format_list_bulleted,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.grid_view,
                      color: Colors.white,
                    )),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: bodyDecoration,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder<List<SongModel>>(
              future: audioQuery.querySongs(
                sortType: null,
                orderType: OrderType.ASC_OR_SMALLER,
                uriType: UriType.EXTERNAL,
                ignoreCase: true,
              ),
              builder: (context, item) {
                if (item.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (item.data!.isEmpty) {
                  return const Center(child: Text("No Songs Found!!"));
                }
                startSongs = item.data!;
                if (!Provider.of<FavoriteDb>(context, listen: false)
                    .isInitialized) {
                  Provider.of<FavoriteDb>(context, listen: false)
                      .initialize(item.data!);
                }
                GetAllSongController.songscopy = item.data!;
                return !isGrid
                    ? ListViewScreen(songModel: item.data!)
                    : GridViewScreen(songModel: item.data!);
              },
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Column(
              children: [
                if (GetAllSongController.audioPlayer.currentIndex != null)
                  Column(
                    children: const [MiniPlayer()],
                  )
                else
                  const SizedBox()
              ],
            ),
          )
        ],
      ),
    );
  }
}
