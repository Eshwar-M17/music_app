import 'package:c_lient/core/providers/current_song_notifiier.dart';
import 'package:c_lient/core/theme/app_pallete.dart';
import 'package:c_lient/core/utils/utils.dart';
import 'package:c_lient/features/homepage/model/song_model.dart';
import 'package:c_lient/features/homepage/view/widgets/favorite_widget.dart';
import 'package:c_lient/features/homepage/view/widgets/music_player.dart';
import 'package:c_lient/features/homepage/viewmodel/home_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SongModel? currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);

    if (currentSong == null) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return const MusicPlayer();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  final tween = Tween(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).chain(CurveTween(curve: Curves.easeIn));
                  final offSetAnimation = animation.drive(tween);
                  return SlideTransition(
                    position: offSetAnimation,
                    child: child,
                  );
                },
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 16,
            height: 66,
            decoration: BoxDecoration(
              color: hexToColor(currentSong.hex_code),
              borderRadius: BorderRadius.circular(10),
            ),

            padding: const EdgeInsets.all(9),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Hero(
                      tag: 'song-thumbnail',
                      child: Container(
                        width: 55,
                        height: 55,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(currentSong.thumbnail_url),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        Text(
                          currentSong.song_name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          currentSong.artist,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Row(
                  children: [
                    FavoriteWidget(currentSong: currentSong),
                    IconButton(
                      onPressed: () {
                        songNotifier.pausePlay();
                      },
                      icon: Icon(
                        songNotifier.isPlaying
                            ? Icons.pause_outlined
                            : Icons.play_arrow_rounded,
                        color: Pallete.whiteColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream: songNotifier.audioPlayer?.positionStream,
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }
              double sliderValue = 0.0;

              if (asyncSnapshot.data?.inMilliseconds != null &&
                  songNotifier.audioPlayer?.duration != null) {
                sliderValue =
                    asyncSnapshot.data!.inMilliseconds /
                    songNotifier.audioPlayer!.duration!.inMilliseconds;
              }
              return Positioned(
                bottom: 0,
                left: 8,
                child: Container(
                  height: 3,
                  width: sliderValue * (MediaQuery.of(context).size.width - 32),

                  decoration: BoxDecoration(
                    color: Pallete.whiteColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 8,
            child: Container(
              height: 3,
              width: MediaQuery.of(context).size.width - 32,

              decoration: BoxDecoration(
                color: Pallete.inactiveSeekColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
