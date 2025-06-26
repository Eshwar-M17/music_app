import 'package:c_lient/features/homepage/model/song_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "local_home_repositery.g.dart";

@riverpod
LocalHomeRepositery localHomeRepositery(Ref ref) {
  return LocalHomeRepositery();
}

class LocalHomeRepositery {
  Box recentSongsBox = Hive.box('recent-played');
  Box favSongsBox = Hive.box('favorite-played');

  Future<void> addSongToRecent(SongModel song) async {
    await recentSongsBox.put(song.id, song.toJson());
  }

  List<SongModel> getRecentSongs() {
    List<SongModel> songs = [];
    for (String key in recentSongsBox.keys) {
      songs.add(SongModel.fromJson(recentSongsBox.get(key)));
    }
    return songs;
  }

  Future<void> addSongToFav(SongModel song) async {
    try {
      await favSongsBox.put(song.id, song.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> removeSongFromFav(SongModel song) async {
    try {
      await favSongsBox.delete(song.id);
    } catch (e) {
      print(e);
    }
  }

  List<SongModel> getFavSongs() {
    List<SongModel> songs = [];
    for (String key in favSongsBox.keys) {
      songs.add(SongModel.fromJson(favSongsBox.get(key)));
    }
    return songs;
  }
}
