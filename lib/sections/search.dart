import 'package:flutter/material.dart';
import 'package:music_app/allsongs_screens/lists_view_songs.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

List<SongModel> allsongs = [];
List<SongModel> foundSongs = [];
final audioQuery = OnAudioQuery();

@override
class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    songsLoading();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: TextField(
          textAlign: TextAlign.start,
          onChanged: (value) => updateList(value),
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
              counterStyle: const TextStyle(
                  // color: Colors.white,
                  ),
              fillColor: Colors.transparent,
              filled: true,
              hintText: 'Search Song',
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none)),
        ),
      ),
      body: foundSongs.isNotEmpty
          ? ListViewScreen(songModel: foundSongs)
          : const Center(child: Text("No Songs Found")),
    );
  }

// if (foundSongs.isEmpty) {
//   return Container(
//     child: Center(
//       child: Text("No data found"),
//     ),
//   );
// } else {
//   return Listtiles(songModel: foundSongs);
// }
  void songsLoading() async {
    allsongs = await audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    setState(() {
      foundSongs = allsongs;
    });
  }

  void updateList(String enteredText) {
    List<SongModel> results = [];
    if (enteredText.isEmpty) {
      results = allsongs;
    } else {
      results = allsongs
          .where((element) => element.displayNameWOExt
              .toLowerCase()
              .trim()
              .contains(enteredText.toLowerCase().trim()))
          .toList();
    }
    setState(() {
      foundSongs = results;
    });
  }
}
