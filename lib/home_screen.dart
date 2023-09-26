import 'package:flutter/material.dart';
import 'package:music/Mostly_played/mostly_played.dart';
import 'package:music/allsongs_screens/all_songs.dart';
import 'package:music/playlist/play_list.dart';
import 'package:music/sections/favourites.dart';
import 'package:music/recent/recently_played.dart';
import 'package:music/sections/search.dart';
import 'package:music/setting_pages/settings.dart';

BoxDecoration bodyDecoration = const BoxDecoration(color: Colors.white);

const TextStyle title = TextStyle(
    color: Color.fromARGB(255, 253, 251, 251),
    fontWeight: FontWeight.bold,
    fontSize: 16);
const TextStyle artistStyle =
    TextStyle(color: Color.fromARGB(180, 252, 248, 248), fontSize: 14);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            labelColor: Colors.white,
            tabs: const [
              Tab(text: 'All Songs'),
              Tab(text: 'Recently Played'),
              Tab(text: 'Mosltly Played'),
              Tab(text: 'Favourites'),
              Tab(text: 'Playlist'),
              Tab(
                text: 'Settings',
              ),
            ],
            // indicatorColor: Colors.black,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white.withOpacity(0.3),
            ),
            isScrollable: true,
          ),
          title: const Text(
            'Music World',
            style: TextStyle(fontSize: 30),
          ),
          // centerTitle: true,
          // leading: IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.menu),
          // ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ));
              },
              icon: const Icon(Icons.search),
            ),
          ],
          elevation: 0,
        ),
        body: TabBarView(
          children: [
            AllSongs(),
            RecentlyPlayed(),
            const MostlyPlayed(),
            const Favourites(),
            const PlaylistPage(),
            const SettingsScreen()
          ],
        ),
      ),
    );
  }
}
