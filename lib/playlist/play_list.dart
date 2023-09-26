import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music/database/model_db.dart';
import 'package:music/home_screen.dart';
import 'package:music/playlist/playlist_gridview.dart';
import 'package:music/providers/playlist_provider.dart';
import 'package:provider/provider.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<MusicWorld>('playlistDb').listenable(),
      builder: (context, Box<MusicWorld> musicList, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text('Playlist'),
            actions: [
              IconButton(
                onPressed: () {
                  nameController.clear();
                  newplaylist(context, formKey);
                },
                icon: const Icon(Icons.playlist_add),
              ),
              const SizedBox(width: 20)
            ],
          ),
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Hive.box<MusicWorld>('playlistDb').isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () {
                              nameController.clear();
                              newplaylist(context, formKey);
                            },
                            child: const Icon(
                              Icons.add_box_outlined,
                              size: 50,
                            )),
                        const Text(
                          'Add playlist',
                          style: title,
                        ),
                      ],
                    ),
                  )
                : PlaylistGridView(
                    musicList: musicList,
                  ),
          ),
        );
      },
    );
  }
}

GlobalKey<FormState> formKey = GlobalKey<FormState>();
TextEditingController nameController = TextEditingController();

Future newplaylist(BuildContext context, formKey) {
  return showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      backgroundColor: Colors.white,
      children: [
        const SimpleDialogOption(
          child: Text(
            'New to Playlist',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        SimpleDialogOption(
          child: Form(
            key: formKey,
            child: TextFormField(
              controller: nameController,
              maxLength: 10,
              decoration: InputDecoration(
                  counterStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  fillColor: const Color.fromARGB(90, 158, 158, 158),
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(25)),
                  contentPadding: const EdgeInsets.only(left: 15, top: 5)),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter your playlist name";
                } else {
                  return null;
                }
              },
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                nameController.clear();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  saveButtonPressed(context);
                }
              },
              child: const Text(
                'Create',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// Save Button Pressed
Future<void> saveButtonPressed(context) async {
  final name = nameController.text.trim();
  final music = MusicWorld(name: name, songId: []);
  final datas = Provider.of<PlayListProvider>(context, listen: false)
      .playlistDb
      .values
      .map((e) => e.name.trim())
      .toList();
  if (name.isEmpty) {
    return;
  } else if (datas.contains(music.name)) {
    final snackbar3 = SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        width: MediaQuery.of(context).size.width * 3.5 / 5,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 750),
        backgroundColor: Colors.black,
        content: const Text(
          'playlist already exist',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackbar3);
    Navigator.of(context).pop();
  } else {
    Provider.of<PlayListProvider>(context, listen: false).addPlaylist(music);
    final snackbar4 = SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        width: MediaQuery.of(context).size.width * 3.5 / 5,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 750),
        backgroundColor: Colors.black,
        content: const Text(
          'playlist created successfully',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackbar4);
    Navigator.of(context).pop();
    nameController.clear();
  }
}
