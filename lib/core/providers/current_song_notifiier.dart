import 'package:c_lient/features/homepage/model/song_model.dart';
import 'package:c_lient/features/homepage/repositories/local_home_repositery.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';

part 'current_song_notifiier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  AudioPlayer? audioPlayer;
  bool isPlaying = false;
  late LocalHomeRepositery localHomeRepositery;

  @override
  SongModel? build() {
    localHomeRepositery = ref.watch(localHomeRepositeryProvider);
    return null;
  }

  void updateSong(SongModel song) async {
    try {
      // Dispose any previously-created player to avoid multiple instances running
      await audioPlayer?.dispose();
      // Basic sanity-check – if the url is empty we cannot proceed
      if (song.song_url.trim().isEmpty) {
        print('[CurrentSongNotifier] ⚠️  The provided songUrl is empty.');
        return;
      }
      print('[CurrentSongNotifier] 🚀 Attempting to play: ${song.song_url}');
      audioPlayer = AudioPlayer();
      await audioPlayer!.setAudioSource(
        AudioSource.uri(
          Uri.parse(song.song_url),
          tag: MediaItem(
            id: song.id,
            title: song.song_name,
            artist: song.artist,
            artUri: Uri.parse(song.thumbnail_url),
          ),
        ),
      );
      // Listen to the player state so we know when the track finishes or errors
      audioPlayer!.playerStateStream.listen((state) async {
        if (state.processingState == ProcessingState.completed) {
          // Automatically rewind & update UI when track finishes
          await audioPlayer!.pause();
          await audioPlayer!.seek(Duration.zero);
          isPlaying = false;
          this.state = this.state!.copyWith(hex_code: this.state!.hex_code);
        } else if (state.processingState == ProcessingState.idle &&
            !state.playing) {
          // This usually means the url failed to load – log for debugging
          print(
            '[CurrentSongNotifier] ❌ Player is idle – unable to load the source.',
          );
        }
      });

      state = song;
      localHomeRepositery.addSongToRecent(song);
      isPlaying = true;

      await audioPlayer!.play();
    } catch (e) {
      print(
        '[CurrentSongNotifier] ❌ Error while trying to play audio: ${e.toString()}',
      );
    }
  }

  void pausePlay() async {
    if (isPlaying == true) {
      await audioPlayer!.pause();
    } else if (isPlaying == false) {
      audioPlayer!.play();
    }
    isPlaying = !isPlaying;
    state = state!.copyWith(hex_code: state!.hex_code);
  }

  void seek(double value) {
    audioPlayer!.seek(
      Duration(
        milliseconds: (value * audioPlayer!.duration!.inMilliseconds).toInt(),
      ),
    );
  }
}
