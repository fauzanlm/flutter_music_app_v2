import 'package:flutter/material.dart';
import 'package:flutter_music_player_app_v2/components/my_drawer.dart';
import 'package:flutter_music_player_app_v2/models/playlist_provider.dart';
import 'package:flutter_music_player_app_v2/pages/song_page.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  bool _hasPermission = false;
  late final dynamic playlistProvider;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();

  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);

    LogConfig logConfig = LogConfig(logType: LogType.DEBUG);
    _audioQuery.setLogConfig(logConfig);

    checkAndRequestPermission();
  }

  checkAndRequestPermission({bool retry = false}) async {
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );

    _hasPermission ? setState(() {}) : null;
  }

  void goToSong(int songIndex) {
    playlistProvider.currentSongIndex = songIndex;
    // playlistProvider.play();
    // navigate to the song page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SongPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('P L A Y L I S T'),
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      body: Center(
        child: !_hasPermission
            ? noAccessToLibraryWidget()
            : FutureBuilder<List<SongModel>>(
                future: _audioQuery.querySongs(
                  sortType: null,
                  orderType: OrderType.ASC_OR_SMALLER,
                  uriType: UriType.EXTERNAL,
                  ignoreCase: true,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }

                  if (snapshot.data == null) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.data!.isEmpty) {
                    return const Text('Nothing found!');
                  }

                  // print('INI DATANYA' + snapshot.data![0].toString());
                  playlistProvider.setPlaylist = snapshot.data!;

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final item = snapshot.data![index];
                      return ListTile(
                        title: Text(
                          item.title,
                          // Uri.parse(item.uri.toString()).path.toString(),
                          // item.data,
                        ),
                        subtitle: Text(item.artist ?? 'No Artist'),
                        leading: QueryArtworkWidget(
                          // controller: _audioQuery,
                          id: item.id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: Icon(
                            Icons.music_note,
                            color: Theme.of(context).colorScheme.primary,
                            size: 40,
                          ),
                          keepOldArtwork: true,
                        ),
                        onTap: () {
                          goToSong(index);
                        },
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  Widget noAccessToLibraryWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.secondary,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Application doesn't have access to the library"),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => checkAndRequestPermission(retry: true),
            child: const Text("Allow"),
          ),
        ],
      ),
    );
  }
}
