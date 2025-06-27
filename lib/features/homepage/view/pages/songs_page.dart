import 'package:c_lient/core/providers/current_song_notifiier.dart';
import 'package:c_lient/core/theme/app_pallete.dart';
import 'package:c_lient/core/widgets/loader.dart';
import 'package:c_lient/features/homepage/model/song_model.dart';
import 'package:c_lient/features/homepage/viewmodel/home_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SongsPage extends ConsumerWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentSongs = ref
        .watch(homePageViewModelProvider.notifier)
        .getRecentSongs();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recent Songs",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          recentSongs != null
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.29,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: recentSongs.length,

                    itemBuilder: (context, index) {
                      final song = recentSongs[index];
                      return GestureDetector(
                        onTap: () {
                          ref
                              .read(currentSongNotifierProvider.notifier)
                              .updateSong(song);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Pallete.borderColor,
                          ),
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(6),
                                width: 60,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(8),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(song.thumbnail_url),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: SizedBox(
                                  width: 250,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        maxLines: 1,
                                        song.song_name,
                                        style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        song.artist,
                                        maxLines: 1,
                                        style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,

                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              : const SizedBox(),
                        const SizedBox(height: 10),

          const Text(
            "Latest Songs",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          ref
              .watch(getAllSongsProvider)
              .when(
                data: (songList) {
                  return SizedBox(
                    height: 250,
                    child: ListView.builder(
                      itemCount: songList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        SongModel song = songList[index];
                        return Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: GestureDetector(
                            onTap: () {
                              ref
                                  .read(currentSongNotifierProvider.notifier)
                                  .updateSong(song);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 180,
                                  width: 180,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(song.thumbnail_url),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    song.song_name,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,

                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    song.artist,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Pallete.subtitleText,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                error: (error, st) {
                  return Center(child: Text(error.toString()));
                },
                loading: () => const Loader(),
              ),
        ],
      ),
    );
  }
}
