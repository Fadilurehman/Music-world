import 'package:flutter/material.dart';
import 'package:music/allsongs_screens/songstoplaylist.dart';
import 'package:music/controller/get_all_song_controller.dart';
import 'package:music/home_screen.dart';
import 'package:music/providers/favourite_db.dart';
import 'package:music/providers/mostly_played_provider.dart';
import 'package:music/providers/recently_provider.dart';
import 'package:music/song_provider/song_model_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../playing_screen/now_playing.dart';

// ignore: must_be_immutable
class ListViewScreen extends StatelessWidget {
  ListViewScreen(
      {super.key,
      required this.songModel,
      this.recentLength,
      this.isRecent = false,
      this.isMostly = false});
  final List<SongModel> songModel;
  final dynamic recentLength;
  final bool isRecent;
  final bool isMostly;

  List<SongModel> allSongs = [];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        allSongs.addAll(songModel);
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
                id: songModel[index].id,
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
                songModel[index].displayNameWOExt,
                style: title,
                maxLines: 1,
              ),
              subtitle: Text(
                songModel[index].artist.toString(),
                style: artistStyle,
                maxLines: 1,
              ),
              trailing: Wrap(
                children: [
                  Consumer<FavoriteDb>(
                    builder: (context, favorite, child) {
                      return IconButton(
                        onPressed: () {
                          if (favorite.isFavor(songModel[index])) {
                            favorite.delete(songModel[index].id);
                            const remove = SnackBar(
                              content: Text('Song removed from favorites'),
                              duration: Duration(seconds: 1),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(remove);
                          } else {
                            favorite.add(songModel[index]);
                            const addFav = SnackBar(
                              content: Text('Song added to favorites'),
                              duration: Duration(seconds: 1),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(addFav);
                          }
                        },
                        icon: favorite.isFavor(songModel[index])
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
                                            playlistDialogue(
                                                context, songModel[index]);
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
                  GetAllSongController.createSongList(songModel),
                  initialIndex: index,
                );
                Provider.of<MostlyProvider>(context, listen: false)
                    .addMostlyPlayed(songModel[index].id);
                Provider.of<Recentlyprovider>(context, listen: false)
                    .addRecentlyPlayed(songModel[index].id);
                context.read<SongModelProvider>().setId(songModel[index].id);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NowPlaying(
                      songModel: songModel,
                      // audioPlayer: _audioPlayer,
                      count: songModel.length,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      itemCount: isRecent || isMostly ? recentLength : songModel.length,
    );
  }
}
