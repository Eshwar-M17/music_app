import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:c_lient/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AudioWaveForm extends StatefulWidget {
  const AudioWaveForm({super.key, required String audioPath})
    : _audioPath = audioPath;
  final String _audioPath;

  @override
  State<AudioWaveForm> createState() => _AudioWaveFormState();
}

class _AudioWaveFormState extends State<AudioWaveForm> {
  late PlayerController _audioPlayerController;

  @override
  void initState() {
    super.initState();
    _audioPlayerController = PlayerController();
    preparePlayer();
    _audioPlayerController.onPlayerStateChanged.listen((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _audioPlayerController.dispose();

    super.dispose();
  }

  void preparePlayer() async {
    await _audioPlayerController.preparePlayer(path: widget._audioPath);
    _audioPlayerController.setFinishMode(finishMode: FinishMode.loop);
  }

  void playAndPause() async {
    if (_audioPlayerController.playerState.isPlaying) {
      await _audioPlayerController.pausePlayer();
    } else {
      await _audioPlayerController.startPlayer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: playAndPause,
          icon: Icon(
            _audioPlayerController.playerState.isPlaying
                ? Icons.pause
                : Icons.play_arrow_rounded,
          ),
        ),
        Expanded(
          child: AudioFileWaveforms(
            playerWaveStyle: PlayerWaveStyle(
              fixedWaveColor: Pallete.borderColor,
              liveWaveColor: Pallete.gradient3,
              showSeekLine: false,
              spacing: 6,
            ),
            size: Size(double.infinity, 100),
            playerController: _audioPlayerController,
          ),
        ),
      ],
    );
  }
}
