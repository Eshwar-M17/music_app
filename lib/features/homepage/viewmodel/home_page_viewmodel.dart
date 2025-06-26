import 'dart:io';
import 'dart:ui';
import 'package:c_lient/core/failure/failure.dart';
import 'package:c_lient/core/providers/current_user_provider.dart';
import 'package:c_lient/features/homepage/model/song_model.dart';
import 'package:c_lient/features/homepage/repositories/home_repositery.dart';
import 'package:c_lient/features/homepage/repositories/local_home_repositery.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:c_lient/core/utils/utils.dart';
import 'package:collection/collection.dart';

part 'home_page_viewmodel.g.dart';

@riverpod
class FavoriteSongNotifier extends _$FavoriteSongNotifier {
  late HomePageRepositery _homePageRepositery;
  late LocalHomeRepositery _localhomeRepositery;

  @override
  AsyncValue<List<SongModel>> build() {
    _homePageRepositery = ref.watch(homePageRepositeryProvider);
    _localhomeRepositery = ref.watch(localHomeRepositeryProvider);
    final res = _localhomeRepositery.getFavSongs();
    print("from local repo length ${res.length}");

    return AsyncValue.data(res);
  }

  bool cointainsSong(String songId) {
    final currentState = state;
    List<SongModel> currentFavorites = [];
    if (currentState is AsyncData<List<SongModel>>) {
      currentFavorites = List<SongModel>.from(currentState.value);
    }

    // Check if song is already a favorite
    final existing = currentFavorites.firstWhereOrNull((e) => e.id == songId);
    if (existing != null) {
      return true;
    }
    return false;
  }

  Future<void> toggleFavorite(SongModel song) async {
    print('toggleFavorite called with songId: ${song.id}');
        print("length in state ${state.value!.length}");


    final currentState = state;
    state = const AsyncValue.loading();

    List<SongModel> currentFavorites = [];
    if (currentState is AsyncData<List<SongModel>>) {
      currentFavorites = List<SongModel>.from(currentState.value);
    }
    print("before call");
    print(currentFavorites.length);

    // Call the repository
    final res = await _homePageRepositery.favoriteIt(
      songId: song.id,
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    res.fold(
      (Failure exc) {
        print('favoriteIt response error ${exc.message}');
        state = AsyncValue.error(exc.message, StackTrace.current);
      },
      (String status) async {
        print('favoriteIt response success $status');
        List<SongModel> updatedFavorites;
        if (status == "true") {
          // Add to favorites
          await _localhomeRepositery.addSongToFav(song);
          updatedFavorites = [...currentFavorites, song];
        } else {
          // Remove from favorites
          await _localhomeRepositery.removeSongFromFav(song);
          updatedFavorites = currentFavorites
              .where((e) => e.id != song.id)
              .toList();
        }
        print("after call update favorites");
        print(updatedFavorites.length);
        this.state = AsyncValue.data(updatedFavorites);
        print("after call state ");
        print(state.value!.length);
      },
    );
  }
}

@riverpod
class FavoriteStatus extends _$FavoriteStatus {
  late HomePageRepositery _homePageRepositery;

  @override
  AsyncValue<String>? build() {
    _homePageRepositery = ref.watch(homePageRepositeryProvider);
    return null;
  }

  Future<void> favoriteIt(String songId) async {
    print('favoriteIt called with songId: $songId');

    state = const AsyncValue.loading();
    final res = await _homePageRepositery.favoriteIt(
      songId: songId,
      token: ref.read(currentUserNotifierProvider)!.token,
    );
    res.fold(
      (Failure exc) {
        print('favoriteIt response error ${exc.message}');

        state = AsyncValue.error(exc.message, StackTrace.current);
      },
      (String status) {
        print('favoriteIt response sucess ${status}');
        state = AsyncValue.data(status);
      },
    );
  }
}

@riverpod
Future<List<SongModel>> getAllSongs(Ref ref) async {
  final token = ref.watch(currentUserNotifierProvider)!.token;
  final res = await ref
      .read(homePageRepositeryProvider)
      .getAllSongs(token: token);

  return res.fold(
    (error) {
      throw error.message;
    },
    (songList) {
      return songList;
    },
  );
}

@riverpod
Future<List<SongModel>> getFavSongs(Ref ref) async {
  print("get fav songes called");
  final token = ref.watch(currentUserNotifierProvider)!.token;
  final res = await ref
      .read(homePageRepositeryProvider)
      .getAllFavSongs(token: token);

  print(res.toString());
  return res.fold(
    (error) {
      throw error.message;
    },
    (songList) {
      return songList;
    },
  );
}

@riverpod
class HomePageViewModel extends _$HomePageViewModel {
  late HomePageRepositery _homePageRepositery;
  late LocalHomeRepositery _localHomeRepositery;

  @override
  AsyncValue<SongModel>? build() {
    _homePageRepositery = ref.watch(homePageRepositeryProvider);
    _localHomeRepositery = ref.watch(localHomeRepositeryProvider);

    return null;
  }

  List<SongModel>? getRecentSongs() {
    return _localHomeRepositery.getRecentSongs();
  }

  Future<void> uploadSong({
    required File song,
    required File thumbnail,
    required String songName,
    required String artist,
    required Color hexCode,
  }) async {
    state = const AsyncValue.loading();
    final res = await _homePageRepositery.uploadSong(
      song: song,
      thumbnail: thumbnail,
      songName: songName,
      artist: artist,
      hexCode: colorToHex(hexCode),
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    res.fold(
      (Failure exc) {
        state = AsyncValue.error(exc.message, StackTrace.current);
      },
      (SongModel song) {
        state = AsyncValue.data(song);
      },
    );
  }
}
