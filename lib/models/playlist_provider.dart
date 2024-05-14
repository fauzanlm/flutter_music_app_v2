import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
// import 'package:on_audio_query/on_audio_query.dart';

class PlaylistProvider extends ChangeNotifier {
  List<SongModel> _playlist = [];

  //audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  //duration
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  //constructor
  PlaylistProvider() {
    listenToDuration();
  }

  bool _isPlaying = false;

  //play the song
  void play() async {
    String? path = _playlist[_currentSongIndex ?? 0].data;

    // String? path = '/external/audio/media/1000006251';
    await _audioPlayer.stop();
    await _audioPlayer.play(DeviceFileSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    print('paused');
    notifyListeners();
  }

  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    print('resumed');
    notifyListeners();
  }

  //pause or resume
  void pauseOrResume() {
    if (isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  //seek to a specific position
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  //play next song
  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < playlist.length - 1) {
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        currentSongIndex = 0;
      }
    }
  }

  //play previous song
  void playPreviousSong() async {
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  //listen to duration
  void listenToDuration() {
    //listen for total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });
    //listen for current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  //currentindex
  int? _currentSongIndex;

  //getter

  List<SongModel> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  //setter

  set currentSongIndex(int? newIndex) {
    if (newIndex == currentSongIndex && _currentDuration.inSeconds > 2) {
      resume();
    } else if (newIndex != null) {
      _currentSongIndex = newIndex;
      play();
    }

    notifyListeners();
  }

  set setPlaylist(List<SongModel> pl) {
    _playlist = pl;
  }
}
