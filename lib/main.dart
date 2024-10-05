import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AudioPlayerScreen(),
    );
  }
}

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _audioPlayer;
  late Stream<Duration?> _durationStream;
  late Stream<Duration> _positionStream;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setUrl(
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
    _durationStream = _audioPlayer.durationStream;
    _positionStream = _audioPlayer.positionStream;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest2<Duration, Duration?, PositionData>(
        _positionStream,
        _durationStream,
        (position, duration) =>
            PositionData(position, duration ?? Duration.zero),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Player'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return Column(
                  children: [
                    if (positionData != null) ...[
                      Slider(
                        min: 0.0,
                        max: positionData.duration.inMilliseconds.toDouble(),
                        value: positionData.position.inMilliseconds.toDouble(),
                        onChanged: (value) {
                          _audioPlayer
                              .seek(Duration(milliseconds: value.toInt()));
                        },
                      ),
                      Text(
                        '${positionData.position.inSeconds} / ${positionData.duration.inSeconds} сек',
                      ),
                    ]
                  ],
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _audioPlayer.seek(Duration.zero);
                    _audioPlayer.stop();
                  },
                  child: const Text('Stop'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_audioPlayer.playing) {
                      await _audioPlayer.pause();
                    } else {
                      await _audioPlayer.play();
                    }
                  },
                  child: StreamBuilder<bool>(
                    stream: _audioPlayer.playingStream,
                    builder: (context, snapshot) {
                      bool isPlaying = snapshot.data ?? false;
                      return Text(isPlaying ? 'Pause' : 'Play');
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PositionData {
  final Duration position;
  final Duration duration;

  PositionData(this.position, this.duration);
}
