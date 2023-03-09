import 'package:flutter/material.dart';
import 'package:music_app/allsongs_screens/songstoplaylist.dart';
import 'package:music_app/controller/get_all_song_controller.dart';
import 'package:music_app/controller/most_played_song.dart';
import 'package:music_app/database/favoritedb.dart';
import 'package:music_app/home_screen.dart';
import 'package:music_app/provider/song_model_provider.dart';
import 'package:music_app/controller/recent_song_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../playing_screen/now_playing.dart';

class ListViewScreen extends StatefulWidget {
  const ListViewScreen(
      {super.key,
      required this.songModel,
      this.recentLength,
      this.isRecent = false,
      this.isMostly = false});
  final List<SongModel> songModel;
  final dynamic recentLength;
  final bool isRecent;
  final bool isMostly;

  @override
  State<ListViewScreen> createState() => _ListViewScreenState();
}

class _ListViewScreenState extends State<ListViewScreen> {
  List<SongModel> allSongs = [];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        allSongs.addAll(widget.songModel);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white70,
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/listtile3.jpg'),
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.white.withOpacity(1),
                    spreadRadius: 1,
                    blurRadius: 8),
              ],
            ),
            child: ListTile(
              leading: QueryArtworkWidget(
                id: widget.songModel[index].id,
                type: ArtworkType.AUDIO,
                artworkWidth: 50,
                artworkHeight: 50,
                keepOldArtwork: true,
                artworkBorder: BorderRadius.circular(6),
                nullArtworkWidget: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color:
                        const Color.fromARGB(255, 240, 121, 0).withOpacity(0.3),
                  ),
                  height: 50,
                  width: 50,
                  child: Icon(
                    Icons.music_note,
                    color:
                        const Color.fromARGB(255, 240, 121, 0).withOpacity(0.6),
                  ),
                ),
              ),
              title: Text(
                widget.songModel[index].displayNameWOExt,
                style: title,
                maxLines: 1,
              ),
              subtitle: Text(
                widget.songModel[index].artist.toString(),
                style: artistStyle,
                maxLines: 1,
              ),
              trailing: Wrap(
                children: [
                  ValueListenableBuilder(
                    valueListenable: FavoriteDb.favoriteSongs,
                    builder: (context, List<SongModel> favoriteData, child) {
                      return IconButton(
                        onPressed: () {
                          if (FavoriteDb.isFavor(widget.songModel[index])) {
                            FavoriteDb.delete(widget.songModel[index].id);
                            const remove = SnackBar(
                              content: Text('Song removed from favorites'),
                              duration: Duration(seconds: 1),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(remove);
                          } else {
                            FavoriteDb.add(widget.songModel[index]);
                            const addFav = SnackBar(
                              content: Text('Song added to favorites'),
                              duration: Duration(seconds: 1),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(addFav);
                          }
                          FavoriteDb.favoriteSongs.notifyListeners();
                        },
                        icon: FavoriteDb.isFavor(widget.songModel[index])
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_outline,
                                color: Colors.white,
                              ),
                      );
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: 180,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            playlistDialogue(context,
                                                widget.songModel[index]);
                                          },
                                          icon: const Icon(
                                            Icons.playlist_add,
                                            size: 30,
                                          )),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      const Text(
                                        "Add to playlist",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            FutureBuilder(
                                              future: Future.delayed(
                                                  const Duration(
                                                      microseconds: 30), () {
                                                return Share.share(
                                                    'https://play.google.com/store/games');
                                              }),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot snapshot) {
                                                return snapshot.data;
                                              },
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.share,
                                            size: 30,
                                          )),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      const Text(
                                        "Share",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.info_outline,
                                            size: 30,
                                          )),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      const Text(
                                        "About Song",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.more_vert),
                    color: Colors.white,
                  ),
                ],
              ),
              onTap: () {
                GetAllSongController.audioPlayer.setAudioSource(
                  GetAllSongController.createSongList(widget.songModel),
                  initialIndex: index,
                );
                GetMostlyPlayedController.addMostlyPlayed(
                    widget.songModel[index].id);
                GetRecentSongController.addRecentlyPlayed(
                    widget.songModel[index].id);
                context
                    .read<SongModelProvider>()
                    .setId(widget.songModel[index].id);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NowPlaying(
                      songModel: widget.songModel,
                      // audioPlayer: _audioPlayer,
                      count: widget.songModel.length,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      itemCount: widget.isRecent || widget.isMostly
          ? widget.recentLength
          : widget.songModel.length,
    );
  }
}
