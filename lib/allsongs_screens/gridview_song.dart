import 'package:flutter/material.dart';
import 'package:music_app/allsongs_screens/songstoplaylist.dart';
import 'package:music_app/controller/get_all_song_controller.dart';
import 'package:music_app/database/favoritedb.dart';
import 'package:music_app/playing_screen/now_playing.dart';
import 'package:music_app/provider/song_model_provider.dart';
import 'package:music_app/controller/recent_song_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../home_screen.dart';

class GridViewScreen extends StatefulWidget {
  const GridViewScreen(
      {super.key,
      required this.songModel,
      this.isRecent = false,
      this.recentLength});
  final List<SongModel> songModel;
  final dynamic recentLength;
  final bool isRecent;

  @override
  State<GridViewScreen> createState() => _GridViewScreenState();
}

class _GridViewScreenState extends State<GridViewScreen> {
  List<SongModel> allSongs = [];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 1),
      itemBuilder: (context, index) {
        allSongs.addAll(widget.songModel);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              GetAllSongController.audioPlayer.setAudioSource(
                  GetAllSongController.createSongList(widget.songModel),
                  initialIndex: index);
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
                    count: widget.songModel.length,
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(3),
              // margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: QueryArtworkWidget(
                      id: widget.songModel[index].id,
                      type: ArtworkType.AUDIO,
                      artworkBorder: BorderRadius.circular(6),
                      artworkWidth: 80,
                      artworkHeight: 80,
                      keepOldArtwork: true,
                      artworkFit: BoxFit.cover,
                      nullArtworkWidget: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.white.withOpacity(0.3),
                        ),
                        height: MediaQuery.of(context).size.height * 1 / 12,
                        width: MediaQuery.of(context).size.height * 1 / 12,
                        child: const Icon(Icons.music_note,
                            color: Colors.white, size: 50),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.songModel[index].displayNameWOExt,
                        maxLines: 1,
                        style: title,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 1 / 4,
                            child: Text(
                              widget.songModel[index].artist.toString(),
                              maxLines: 1,
                              style: artistStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: ValueListenableBuilder(
                            valueListenable: FavoriteDb.favoriteSongs,
                            builder:
                                (context, List<SongModel> favoriteData, child) {
                              return IconButton(
                                onPressed: () {
                                  if (FavoriteDb.isFavor(
                                      widget.songModel[index])) {
                                    FavoriteDb.delete(
                                        widget.songModel[index].id);
                                    const remove = SnackBar(
                                      content:
                                          Text('Song removed from favorites'),
                                      duration: Duration(seconds: 1),
                                    );

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(remove);
                                  } else {
                                    FavoriteDb.add(widget.songModel[index]);
                                    const add = SnackBar(
                                      content: Text('Song added to favorites'),
                                      duration: Duration(seconds: 1),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(add);
                                  }
                                  FavoriteDb.favoriteSongs.notifyListeners();
                                },
                                icon:
                                    FavoriteDb.isFavor(widget.songModel[index])
                                        ? const Icon(
                                            Icons.favorite,
                                            color: Colors.redAccent,
                                          )
                                        : const Icon(
                                            Icons.favorite_outline,
                                            color: Colors.white,
                                          ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
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
                                                        context,
                                                        widget
                                                            .songModel[index]);
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
                                                              microseconds: 30),
                                                          () {
                                                        return Share.share(
                                                            'https://play.google.com/store/games');
                                                      }),
                                                      builder:
                                                          (BuildContext context,
                                                              AsyncSnapshot
                                                                  snapshot) {
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
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      itemCount:
          widget.isRecent ? widget.recentLength : widget.songModel.length,
    );
  }
}
