import 'package:flutter/material.dart';
import 'package:flutter_music_player_app_v2/components/neu_box.dart';
import 'package:flutter_music_player_app_v2/models/playlist_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class SongPage extends StatefulWidget {
  const SongPage({super.key});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  String formatTime(Duration duration) {
    String twoDigitsSeconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    String formattedTime = "${duration.inMinutes}:$twoDigitsSeconds";
    return formattedTime;
  }

  // final OnAudioQuery _audioQuery = OnAudioQuery();
  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, value, child) {
        final playlist = value.playlist;

        final currentSong = playlist[value.currentSongIndex ?? 0];

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
                bottom: 25,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const Text(
                        'P L A Y L I S T',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.menu),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  NeuBox(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Icon(
                            Icons.music_note,
                            size: 150,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentSong.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                      // maxLines: 1,
                                      // overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(currentSong.artist ?? 'No Artist'),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //current time
                            Text(formatTime(value.currentDuration)),

                            const Icon(Icons.shuffle),
                            const Icon(Icons.repeat),
                            //end time
                            Text(formatTime(value.totalDuration)),
                          ],
                        ),

                        //progress
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 0,
                            ),
                          ),
                          child: Slider(
                            min: 0,
                            max: value.totalDuration.inSeconds.toDouble(),
                            value: value.currentDuration.inSeconds.toDouble(),
                            activeColor: Colors.green,
                            onChanged: (double val) {},
                            onChangeEnd: (double val) {
                              value.seek(
                                Duration(seconds: val.toInt()),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: value.playPreviousSong,
                                child: const NeuBox(
                                  child: Icon(Icons.skip_previous),
                                ),
                              ),
                            ),
                            const SizedBox(width: 25),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: value.pauseOrResume,
                                child: NeuBox(
                                  child: Icon(value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow),
                                ),
                              ),
                            ),
                            const SizedBox(width: 25),
                            Expanded(
                              child: GestureDetector(
                                onTap: value.playNextSong,
                                child: const NeuBox(
                                  child: Icon(Icons.skip_next),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
