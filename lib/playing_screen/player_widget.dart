import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/allsongs_screens/songstoplaylist.dart';
import 'package:music_app/controller/get_all_song_controller.dart';
import 'package:music_app/providers/favourite_db.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class PlayingControls extends StatefulWidget {
  const PlayingControls({
    super.key,
    required this.count,
    required this.favSongModel,
    required this.lastSong,
    required this.firstSong,
  });

  final int count;
  final bool firstSong;
  final bool lastSong;
  final SongModel favSongModel;

  @override
  State<PlayingControls> createState() => _PlayingControlsState();
}

class _PlayingControlsState extends State<PlayingControls> {
  bool isPlaying = true;

  bool isShuffling = false;

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Consumer<FavoriteDb>(
              builder: (context, favoritedata, child) {
                return IconButton(
                    onPressed: () {
                      if (favoritedata.isFavor(widget.favSongModel)) {
                        favoritedata.delete(widget.favSongModel.id);
                        const remove = SnackBar(
                          content: Text('Song removed from favorites'),
                          duration: Duration(seconds: 1),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(remove);
                      } else {
                        favoritedata.add(widget.favSongModel);
                        const addFav = SnackBar(
                          content: Text('Song added to favorites'),
                          duration: Duration(seconds: 1),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(addFav);
                      }
                    },
                    icon: favoritedata.isFavor(widget.favSongModel)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_outline,
                            color: Colors.white,
                          ));
              },
            ),
            IconButton(
                onPressed: () {
                  playlistDialogue(context, widget.favSongModel);
                },
                icon: const Icon(
                  Icons.playlist_add,
                  size: 30,
                  color: Colors.white,
                )),
            const SizedBox(
              width: 15,
            ),
            IconButton(
              onPressed: () {
                isShuffling == false
                    ? GetAllSongController.audioPlayer
                        .setShuffleModeEnabled(true)
                    : GetAllSongController.audioPlayer
                        .setShuffleModeEnabled(false);
              },
              icon: StreamBuilder<bool>(
                stream:
                    GetAllSongController.audioPlayer.shuffleModeEnabledStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    isShuffling = snapshot.data;
                  }
                  if (isShuffling) {
                    return const Icon(
                      Icons.shuffle,
                      size: 30,
                      color: Colors.black,
                    );
                  } else {
                    return const Icon(
                      Icons.shuffle,
                      color: Colors.white,
                    );
                  }
                },
              ),
            ),
            IconButton(
              onPressed: () {
                GetAllSongController.audioPlayer.loopMode == LoopMode.one
                    ? GetAllSongController.audioPlayer.setLoopMode(LoopMode.all)
                    : GetAllSongController.audioPlayer
                        .setLoopMode(LoopMode.one);
              },
              icon: StreamBuilder<LoopMode>(
                stream: GetAllSongController.audioPlayer.loopModeStream,
                builder: (context, snapshot) {
                  final loopMode = snapshot.data;
                  if (LoopMode.one == loopMode) {
                    return const Icon(
                      Icons.repeat,
                      size: 30,
                      color: Color.fromARGB(255, 11, 11, 11),
                    );
                  } else {
                    return const Icon(
                      Icons.repeat,
                      color: Colors.white,
                    );
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
// skip previous
            widget.firstSong
                ? Center(
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.skip_previous,
                          color: Colors.white30,
                          size: 60,
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: IconButton(
                        onPressed: () {
                          if (GetAllSongController.audioPlayer.hasPrevious) {
                            GetAllSongController.audioPlayer.seekToPrevious();
                          }
                        },
                        icon: const Icon(
                          Icons.skip_previous,
                          color: Color.fromARGB(255, 250, 249, 249),
                          size: 60,
                        ),
                      ),
                    ),
                  ),
// play pause
            Center(
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                    onPressed: () {
                      if (mounted) {
                        setState(() {
                          if (GetAllSongController.audioPlayer.playing) {
                            GetAllSongController.audioPlayer.pause();
                          } else {
                            GetAllSongController.audioPlayer.play();
                          }
                          isPlaying = !isPlaying;
                        });
                      }
                    },
                    icon: isPlaying
                        ? const Icon(
                            Icons.pause,
                            color: Color.fromARGB(255, 5, 4, 4),
                            size: 50,
                          )
                        : const Icon(
                            Icons.play_arrow,
                            color: Colors.black,
                            size: 50,
                          )),
              ),
            ),
// skip next
            widget.lastSong
                ? Center(
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.skip_next,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: IconButton(
                        onPressed: () {
                          if (GetAllSongController.audioPlayer.hasNext) {
                            GetAllSongController.audioPlayer.seekToNext();
                          }
                        },
                        icon: const Icon(
                          Icons.skip_next,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                    ),
                  )
          ],
        )
      ],
    );
  }
}
