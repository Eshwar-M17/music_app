// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class SongModel {
  final String id;
  final String song_name;
  final String artist;
  final String hex_code;
  final String song_url;
  final String thumbnail_url;
  SongModel({
    required this.id,
    required this.song_name,
    required this.artist,
    required this.hex_code,
    required this.song_url,
    required this.thumbnail_url,
  });

  SongModel copyWith({
    String? id,
    String? song_name,
    String? artist,
    String? hex_code,
    String? song_url,
    String? thumbnail_url,
  }) {
    return SongModel(
      id: id ?? this.id,
      song_name: song_name ?? this.song_name,
      artist: artist ?? this.artist,
      hex_code: hex_code ?? this.hex_code,
      song_url: song_url ?? this.song_url,
      thumbnail_url: thumbnail_url ?? this.thumbnail_url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'song_name': song_name,
      'artist': artist,
      'hex_code': hex_code,
      'song_url': song_url,
      'thumbnail_url': thumbnail_url,
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      id: map['id'] ??"",
      song_name: map['song_name'] ??"",
      artist: map['artist']  ??"",
      hex_code: map['hex_code']  ??"",
      song_url: map['song_url']  ??"",
      thumbnail_url: map['thumbnail_url']  ??"",
    );
  }

  String toJson() => json.encode(toMap());

  factory SongModel.fromJson(String source) =>
      SongModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SongModel(id: $id, song_name: $song_name, artist: $artist, hex_code: $hex_code, song_url: $song_url, thumbnail_url: $thumbnail_url)';
  }

  @override
  bool operator ==(covariant SongModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.song_name == song_name &&
      other.artist == artist &&
      other.hex_code == hex_code &&
      other.song_url == song_url &&
      other.thumbnail_url == thumbnail_url;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      song_name.hashCode ^
      artist.hashCode ^
      hex_code.hashCode ^
      song_url.hashCode ^
      thumbnail_url.hashCode;
  }
}
