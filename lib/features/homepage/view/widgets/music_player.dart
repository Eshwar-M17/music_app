import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:c_lient/core/providers/current_song_notifiier.dart';
import 'package:c_lient/core/theme/app_pallete.dart';
import 'package:c_lient/core/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final song = ref.watch(currentSongNotifierProvider);
    final currentSongNotifier = ref.watch(currentSongNotifierProvider.notifier);
    Duration? songDuration = currentSongNotifier.audioPlayer?.duration;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,

          colors: [hexToColor(song!.hex_code), Colors.black],
        ),
      ),
      child: Scaffold(
        backgroundColor: Pallete.transparentColor,
        appBar: AppBar(
          backgroundColor: Pallete.transparentColor,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset('assets/images/pull-down-arrow.png'),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Hero(
                tag: 'song-thumbnail',
                child: Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(song.thumbnail_url),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            song.song_name,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            song.song_name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.favorite),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  StreamBuilder(
                    stream: currentSongNotifier.audioPlayer!.positionStream,
                    builder: (context, asyncSnapshot) {
                      double sliderValue = 0;
                      Duration? currentTime = asyncSnapshot.data;

                      if (currentTime?.inMilliseconds != null &&
                          songDuration?.inMilliseconds != null) {
                        sliderValue =
                            currentTime!.inMilliseconds /
                            songDuration!.inMilliseconds;
                      }

                      return Column(
                        children: [
                          SliderTheme(
                            data: SliderThemeData(
                              overlayShape: SliderComponentShape.noOverlay,
                              thumbColor: Pallete.whiteColor,
                              activeTrackColor: Pallete.whiteColor,
                              inactiveTrackColor: Colors.white.withAlpha(50),
                            ),
                            child: Slider(
                              min: 0,
                              max: 1,
                              value: sliderValue,
                              onChanged: (value) {
                                sliderValue = value;
                              },
                              onChangeEnd: (value) {
                                currentSongNotifier.seek(value);
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(currentTime?.inSeconds.toMMSS() ?? '00:00'),
                              Text(songDuration!.inSeconds.toMMSS()),
                            ],
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/images/shuffle.png'),
                      Image.asset('assets/images/previus-song.png'),
                      IconButton(
                        onPressed: () {
                          currentSongNotifier.pausePlay();
                        },
                        icon: Icon(
                          currentSongNotifier.isPlaying
                              ? CupertinoIcons.pause_circle_fill
                              : CupertinoIcons.play_circle_fill,
                          color: Pallete.whiteColor,
                          size: 80,
                        ),
                      ),

                      Image.asset('assets/images/next-song.png'),
                      Image.asset('assets/images/repeat.png'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/images/connect-device.png'),

                      Image.asset('assets/images/playlist.png'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
