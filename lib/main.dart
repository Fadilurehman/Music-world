import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_app/database/model_db.dart';
import 'package:music_app/provider/song_model_provider.dart';
import 'package:music_app/splash_screen/splash.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!Hive.isAdapterRegistered(MusicWorldAdapter().typeId)) {
    Hive.registerAdapter(MusicWorldAdapter());
  }
  await Hive.initFlutter();
  await Hive.openBox<int>('FavoriteDb');
  await Hive.openBox('recentSongNotifier');
  await Hive.openBox<MusicWorld>('playlistDb');

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => SongModelProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Mitr',
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 141, 12, 167),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
