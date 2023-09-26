import 'package:flutter/material.dart';
import 'package:music/controller/get_all_song_controller.dart';
import 'package:music/home_screen.dart';
import 'package:music/playing_screen/now_playing.dart';
import 'package:provider/provider.dart';

import 'package:text_scroll/text_scroll.dart';

import '../providers/recently_provider.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({
    Key? key,
  }) : super(key: key);
  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

bool firstSong = false;

bool isPlaying = false;

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  void initState() {
    GetAllSongController.audioPlayer.currentIndexStream.listen(
      (index) {
        if (index != null && mounted) {
          setState(
            () {
              index == 0 ? firstSong = true : firstSong = false;
            },
          );
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NowPlaying(
              songModel: GetAllSongController.playingsong,
            ),
          ),
        );
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 6),
          child: Container(
            decoration: BoxDecoration(
                // image: const DecorationImage(
                //   fit: BoxFit.cover,
                //   image: AssetImage('assets/images/mini_player.jpg'),
                // ),
                color: const Color.fromARGB(255, 141, 12, 167),
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10)),
            height: 60,
            width: MediaQuery.of(context).size.width,
            // child: Container(
            // border: Border.all(color: Colors.purple, width: 3),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      // color: const Color.fromARGB(255, 223, 116, 44),
                      margin: const EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 1.5 / 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StreamBuilder<bool>(
                            stream:
                                GetAllSongController.audioPlayer.playingStream,
                            builder: (context, snapshot) {
                              bool? playingStage = snapshot.data;
                              if (playingStage != null && playingStage) {
                                return TextScroll(
                                  GetAllSongController
                                      .playingsong[GetAllSongController
                                          .audioPlayer.currentIndex!]
                                      .displayNameWOExt,
                                  textAlign: TextAlign.center,
                                  style: title,
                                  velocity: const Velocity(
                                      pixelsPerSecond: Offset(40, 0)),
                                );
                              } else {
                                return Text(
                                  GetAllSongController
                                      .playingsong[GetAllSongController
                                          .audioPlayer.currentIndex!]
                                      .displayNameWOExt,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                );
                              }
                            },
                          ),
                          TextScroll(
                            GetAllSongController
                                        .playingsong[GetAllSongController
                                            .audioPlayer.currentIndex!]
                                        .artist
                                        .toString() ==
                                    "<unknown>"
                                ? "Unknown Artist"
                                : GetAllSongController
                                    .playingsong[GetAllSongController
                                        .audioPlayer.currentIndex!]
                                    .artist
                                    .toString(),
                            style: const TextStyle(
                                fontFamily: 'poppins',
                                fontSize: 10,
                                color: Colors.white),
                            mode: TextScrollMode.endless,
                          ),
                        ],
                      ),
                    ),
// previous
                    firstSong
                        ? IconButton(
                            iconSize: 32,
                            onPressed: null,
                            icon: Icon(
                              Icons.skip_previous,
                              color: Colors.white.withOpacity(0.4),
                            ),
                          )
                        : IconButton(
                            iconSize: 32,
                            onPressed: () async {
                              Provider.of<Recentlyprovider>(context,
                                      listen: false)
                                  .addRecentlyPlayed(GetAllSongController
                                      .playingsong[GetAllSongController
                                          .audioPlayer.currentIndex!]
                                      .id);
                              if (GetAllSongController
                                  .audioPlayer.hasPrevious) {
                                await GetAllSongController.audioPlayer
                                    .seekToPrevious();
                                await GetAllSongController.audioPlayer.play();
                              } else {
                                await GetAllSongController.audioPlayer.play();
                              }
                            },
                            icon: const Icon(Icons.skip_previous),
                            color: const Color.fromARGB(255, 6, 5, 6)
                                .withOpacity(0.7),
                          ),
// play and Pause
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 8, 8, 8),
                          shape: const CircleBorder()),
                      onPressed: () async {
                        setState(() {
                          isPlaying = !isPlaying;
                        });
                        if (GetAllSongController.audioPlayer.playing) {
                          await GetAllSongController.audioPlayer.pause();
                          setState(() {});
                        } else {
                          await GetAllSongController.audioPlayer.play();
                          setState(() {});
                        }
                      },
                      child: StreamBuilder<bool>(
                        stream: GetAllSongController.audioPlayer.playingStream,
                        builder: (context, snapshot) {
                          bool? playingStage = snapshot.data;
                          if (playingStage != null && playingStage) {
                            return const Icon(
                              Icons.pause_circle,
                              color: Color.fromARGB(255, 248, 244, 244),
                              size: 35,
                            );
                          } else {
                            return const Icon(
                              Icons.play_circle,
                              color: Color.fromARGB(255, 249, 247, 247),
                              size: 35,
                            );
                          }
                        },
                      ),
                    ),
// next
                    IconButton(
                      iconSize: 35,
                      onPressed: () async {
                        Provider.of<Recentlyprovider>(context, listen: false)
                            .addRecentlyPlayed(GetAllSongController
                                .playingsong[GetAllSongController
                                    .audioPlayer.currentIndex!]
                                .id);
                        if (GetAllSongController.audioPlayer.hasNext) {
                          await GetAllSongController.audioPlayer.seekToNext();
                          await GetAllSongController.audioPlayer.play();
                        } else {
                          await GetAllSongController.audioPlayer.play();
                        }
                      },
                      icon: const Icon(
                        Icons.skip_next,
                        size: 32,
                      ),
                      color: Colors.white,
                    )
                  ],
                )
              ],
            ),
            // ),
          ),
        ),
      ),
    );
  }
}
