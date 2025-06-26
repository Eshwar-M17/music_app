import 'package:c_lient/core/theme/app_pallete.dart';
import 'package:c_lient/features/homepage/model/song_model.dart';
import 'package:c_lient/features/homepage/viewmodel/home_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteWidget extends ConsumerWidget {
  const FavoriteWidget({super.key, required this.currentSong});

  final SongModel? currentSong;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteSongNotifier = ref.watch(
      favoriteSongNotifierProvider.notifier,
    );
     ref.watch(favoriteSongNotifierProvider);

    return IconButton(
      onPressed: () async {
        await favoriteSongNotifier.toggleFavorite(currentSong!);
       
      },
      icon: favoriteSongNotifier.cointainsSong(currentSong!.id)
          ? const Icon(Icons.favorite_rounded, color: Pallete.whiteColor)
          : const Icon(
              Icons.favorite_border_rounded,
              color: Pallete.whiteColor,
            ),
    );
  }
}
