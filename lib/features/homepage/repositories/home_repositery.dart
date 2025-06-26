import 'dart:convert';
import 'dart:io';
import 'package:c_lient/core/failure/failure.dart';
import 'package:c_lient/features/homepage/model/song_model.dart';
import 'package:c_lient/core/constants/server_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repositery.g.dart';

@riverpod
HomePageRepositery homePageRepositery(Ref ref) {
  return HomePageRepositery();
}

class HomePageRepositery {
  Future<Either<Failure, SongModel>> uploadSong({
    required File song,
    required File thumbnail,
    required String songName,
    required String artist,
    required String hexCode,
    required String token,
  }) async {
    try {
      final uri = Uri.parse("${ServerConstants.baseUrl}/song/upload");

      final request = http.MultipartRequest('POST', uri);
      request.files.addAll([
        await http.MultipartFile.fromPath("song", song.path),
        await http.MultipartFile.fromPath('thumbnail', thumbnail.path),
      ]);
      request.fields.addAll({
        "song_name": songName,
        "artist": artist,
        "hex_code": hexCode,
      });
      request.headers.addAll({"x-auth-token": token});
      final response = await request.send();
      if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        return Right(SongModel.fromJson(responseBody));
      } else {
        final responseBody = await response.stream.bytesToString();
        return Left(Failure(message: responseBody));
      }
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, String>> favoriteIt({
    required String token,
    required String songId,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse("${ServerConstants.baseUrl}/song/favorite"),
        headers: {"x-auth-token": token, "Content-Type": "application/json"},
        body: jsonEncode({"song_id": songId}),
      );
      final resbody = jsonDecode(res.body);
      print("response ${res.body}");
      if (res.statusCode != 200) {
        return Left(Failure(message: resbody['detail']));
      }
      return Right(resbody['message']);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<SongModel>>> getAllSongs({
    required String token,
  }) async {
    try {
      http.Response res = await http.get(
        Uri.parse("${ServerConstants.baseUrl}/song/list"),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );
      List<SongModel> songsList = [];
      var resBody = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final resBodyMap = resBody as List;

        songsList = resBodyMap.map((e) {
          return SongModel.fromMap(e);
        }).toList();

        return Right(songsList);
      }
      return Left(Failure(message: resBody['detail']));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<SongModel>>> getAllFavSongs({
    required String token,
  }) async {
    try {
      http.Response res = await http.get(
        Uri.parse("${ServerConstants.baseUrl}/song/list/favorite"),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );
      List<SongModel> favSongsList = [];
      var resBody = jsonDecode(res.body);
      if (res.statusCode == 200) {
        print(res.body);
        final resBodyMap = resBody as List;

        favSongsList = resBodyMap.map((e) {
          return SongModel.fromMap(e["song"]);
        }).toList();

        return Right(favSongsList);
      }
      return Left(Failure(message: resBody['detail']));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
