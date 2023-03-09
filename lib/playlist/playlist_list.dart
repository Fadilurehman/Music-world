import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart%20';
import 'package:music_app/controller/get_all_song_controller.dart';
import 'package:music_app/controller/recent_song_controller.dart';
import 'package:music_app/database/model_db.dart';
import 'package:music_app/home_screen.dart';
import 'package:music_app/playing_screen/now_playing.dart';
import 'package:music_app/playlist/playlist_add_songs.dart';
import 'package:music_app/provider/song_model_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class SinglePlaylist extends StatelessWidget {
  const SinglePlaylist({
    super.key,
    required this.playlist,
    required this.findex,
    this.String,
  });
  final MusicWorld playlist;
  final int findex;
  final String;

  @override
  Widget build(BuildContext context) {
    late List<SongModel> songPlaylist;
    return ValueListenableBuilder(
      valueListenable: Hive.box<MusicWorld>('playlistDb').listenable(),
      builder: (BuildContext context, Box<MusicWorld> music, Widget? child) {
        songPlaylist = listPlaylist(music.values.toList()[findex].songId);
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
//pop button
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: [
// Add song
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaylistAddSong(
                            playlist: playlist,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  )
                ],
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
//Title
                  title: Text(
                    playlist.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  expandedTitleScale: 2.9,
                  background: Image.asset(
                    String,
                    fit: BoxFit.cover,
                  ),
                ),
                backgroundColor: const Color.fromARGB(255, 230, 133, 41),
                pinned: true,
                expandedHeight: MediaQuery.of(context).size.width * 2.5 / 4,
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    songPlaylist.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlaylistAddSong(
                                            playlist: playlist,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Icon(
                                      Icons.add_box,
                                      size: 50,
                                    )),
                                const Center(
                                    child: Text(
                                  'Add Songs To Your playlist',
                                  style: TextStyle(fontSize: 20),
                                )),
                              ],
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white70,
                                    image: const DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'assets/images/listtile3.jpg'),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.white.withOpacity(1),
                                          spreadRadius: 1,
                                          blurRadius: 8),
                                    ],
                                  ),
                                  // color:
                                  //     const Color.fromARGB(255, 243, 170, 75),
                                  child: ListTile(
                                    leading: QueryArtworkWidget(
                                      id: songPlaylist[index].id,
                                      type: ArtworkType.AUDIO,
                                      artworkWidth: 50,
                                      artworkHeight: 50,
                                      keepOldArtwork: true,
                                      artworkBorder: BorderRadius.circular(6),
                                      nullArtworkWidget: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color:
                                              const Color.fromARGB(255, 7, 7, 7)
                                                  .withOpacity(0.3),
                                        ),
                                        height: 50,
                                        width: 50,
                                        child: Icon(
                                          Icons.music_note,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                        songPlaylist[index].displayNameWOExt,
                                        maxLines: 1,
                                        style: title),
                                    subtitle: Text(
                                      songPlaylist[index].artist.toString(),
                                      maxLines: 1,
                                      style: artistStyle,
                                    ),
                                    trailing: SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          color:
                                              const Color.fromARGB(255, 8, 8, 8)
                                                  .withOpacity(0.5),
                                        ),
                                        onPressed: () {
                                          songDeleteFromPlaylist(
                                              songPlaylist[index], context);
                                        },
                                      ),
                                    ),
                                    onTap: () {
                                      GetAllSongController.audioPlayer
                                          .setAudioSource(
                                              GetAllSongController
                                                  .createSongList(songPlaylist),
                                              initialIndex: index);
                                      GetRecentSongController.addRecentlyPlayed(
                                          songPlaylist[index].id);
                                      context
                                          .read<SongModelProvider>()
                                          .setId(songPlaylist[index].id);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => NowPlaying(
                                            songModel: songPlaylist,
                                            count: songPlaylist.length,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                            itemCount: songPlaylist.length,
                          )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void songDeleteFromPlaylist(SongModel data, context) {
    playlist.deleteData(data.id);
    final removePlaylist = SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      width: MediaQuery.of(context).size.width * 3.5 / 5,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black,
      content: const Text(
        'Song removed from Playlist',
        style: TextStyle(color: Colors.white),
      ),
      duration: const Duration(milliseconds: 550),
    );
    ScaffoldMessenger.of(context).showSnackBar(removePlaylist);
  }

  List<SongModel> listPlaylist(List<int> data) {
    List<SongModel> plsongs = [];
    for (int i = 0; i < GetAllSongController.songscopy.length; i++) {
      for (int j = 0; j < data.length; j++) {
        if (GetAllSongController.songscopy[i].id == data[j]) {
          plsongs.add(GetAllSongController.songscopy[i]);
        }
      }
    }
    return plsongs;
  }
}
