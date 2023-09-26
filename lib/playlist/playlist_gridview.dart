import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music/database/model_db.dart';
import 'package:music/playlist/dialogue.dart';
import 'package:music/playlist/playlist_list.dart';

class PlaylistGridView extends StatefulWidget {
  const PlaylistGridView({
    Key? key,
    required this.musicList,
  }) : super(key: key);
  final Box<MusicWorld> musicList;
  @override
  State<PlaylistGridView> createState() => _PlaylistGridViewState();
}

class _PlaylistGridViewState extends State<PlaylistGridView> {
  final TextEditingController playlistnamectrl = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void initState() {
    // playlistnamectrl.text = widget.musicList.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int imagechanger = 1;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        shrinkWrap: true,
        itemCount: widget.musicList.length,
        itemBuilder: (context, index) {
          final data = widget.musicList.values.toList()[index];
          imagechanger = Random().nextInt(3) + 1;
          return ValueListenableBuilder(
            valueListenable: Hive.box<MusicWorld>('playlistDb').listenable(),
            builder: (BuildContext context, Box<MusicWorld> musicList,
                Widget? child) {
              return Padding(
                padding: const EdgeInsets.all(4),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SinglePlaylist(
                            playlist: data,
                            findex: index,
                            String:
                                'assets/playlist/playlistcover$imagechanger.jpg',
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/listtile3.jpg'),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/playlist/playlistcover$imagechanger.jpg'),
                                    fit: BoxFit.cover)),
                            height: MediaQuery.of(context).size.height * 2 / 10,
                            width: MediaQuery.of(context).size.height * 2 / 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.90 /
                                      4,
                                  child: Text(
                                    data.name,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color:
                                            Color.fromARGB(255, 251, 248, 248)),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            'assets/images/listtile3.jpg'),
                                      ),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        moredialogplaylist(
                                            context,
                                            index,
                                            musicList,
                                            formkey,
                                            playlistnamectrl,
                                            data);
                                      },
                                      icon: const Icon(
                                        Icons.more_vert,
                                        color:
                                            Color.fromARGB(255, 252, 251, 251),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
