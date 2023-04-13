import 'package:flutter/material.dart';
import 'package:music_app/database/model_db.dart';
import 'package:music_app/home_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

// ignore: must_be_immutable
class PlaylistAddSong extends StatelessWidget {
  PlaylistAddSong({super.key, required this.playlist});
  final MusicWorld playlist;

  bool isPlaying = true;
  final OnAudioQuery audioQuery = OnAudioQuery();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Add songs"),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: audioQuery.querySongs(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true),
        builder: (context, item) {
          if (item.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (item.data!.isEmpty) {
            return const Center(
              child: Text('No songs availble'),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
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
                  // color: const Color.fromARGB(255, 248, 247, 247),
                  child: ListTile(
                    leading: QueryArtworkWidget(
                      id: item.data![index].id,
                      type: ArtworkType.AUDIO,
                      artworkWidth: 50,
                      artworkHeight: 50,
                      keepOldArtwork: true,
                      artworkBorder: BorderRadius.circular(6),
                      nullArtworkWidget: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.black.withOpacity(0.3),
                        ),
                        height: 50,
                        width: 50,
                        child: Icon(
                          Icons.music_note,
                          color: const Color.fromARGB(255, 3, 3, 3)
                              .withOpacity(0.5),
                        ),
                      ),
                    ),
                    title: Text(item.data![index].displayNameWOExt,
                        maxLines: 1, style: title),
                    subtitle: Text(
                      item.data![index].artist.toString(),
                      maxLines: 1,
                      style: artistStyle,
                    ),
                    trailing: SizedBox(
                      height: 60,
                      width: 60,
                      child: Container(
                        child: !playlist.isValueIn(item.data![index].id)
                            ? IconButton(
                                onPressed: () {
                                  songAddToPlaylist(item.data![index], context);
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: const Color.fromARGB(255, 3, 3, 3)
                                      .withOpacity(0.5),
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  songDeleteFromPlaylist(
                                      item.data![index], context);
                                },
                                icon: Icon(
                                  Icons.remove,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: item.data!.length,
          );
        },
      ),
    );
  }

  void songAddToPlaylist(SongModel data, context) {
    playlist.add(data.id);
    final addedToPlaylist = SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      width: MediaQuery.of(context).size.width * 3.5 / 5,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black,
      content: const Text(
        'Song added to playlist',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      duration: const Duration(milliseconds: 550),
    );
    ScaffoldMessenger.of(context).showSnackBar(addedToPlaylist);
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
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      duration: const Duration(milliseconds: 550),
    );
    ScaffoldMessenger.of(context).showSnackBar(removePlaylist);
  }
}
