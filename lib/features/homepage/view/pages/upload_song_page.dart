import 'dart:io';
import 'package:c_lient/core/utils/utils.dart';
import 'package:c_lient/core/widgets/custom_text_field.dart';
import 'package:c_lient/core/widgets/loader.dart';
import 'package:c_lient/features/homepage/view/widgets/audio_wave_form.dart';
import 'package:c_lient/features/homepage/viewmodel/home_page_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:c_lient/core/theme/app_pallete.dart';
import "package:flex_color_picker/flex_color_picker.dart";
import 'package:audio_waveforms/audio_waveforms.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<UploadSongPage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<UploadSongPage> {
  late TextEditingController _artistNameContrller;
  late TextEditingController _songNameController;
  late PlayerController _audioPlayerController;
  Color selectedColor = Pallete.greenColor;
  File? selectedImage;
  File? selectedSong;

  @override
  void initState() {
    super.initState();
    _artistNameContrller = TextEditingController();
    _songNameController = TextEditingController();
    _audioPlayerController = PlayerController();
  }

  @override
  void dispose() {
    _artistNameContrller.dispose();
    _songNameController.dispose();
    _audioPlayerController.dispose();
    super.dispose();
  }

  void selectImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        selectedImage = res;
      });
    } else {
      if (!mounted) return;
      showSnackBar(context, "Did not recive file");
    }
  }

  Future<void> selectAudio() async {
    final res = await pickSong();

    if (res != null) {
      setState(() {
        selectedSong = res;
        _audioPlayerController.preparePlayer(path: selectedSong!.path);
      });
    } else {
      if (!mounted) return;
      showSnackBar(context, "Did not recive file");
    }
  }

  Future<void> uploadData() async {
    await ref
        .read(homePageViewModelProvider.notifier)
        .uploadSong(
          song: selectedSong!,
          thumbnail: selectedImage!,
          songName: _songNameController.text.trim(),
          artist: _artistNameContrller.text.trim(),
          hexCode: selectedColor,
        );
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(
      homePageViewModelProvider.select((val) {
        print("val $val");
        return val?.isLoading == true;
      }),
    );

    ref.listen(homePageViewModelProvider, (_, next) {
      next?.when(
        data: (data) {
          showSnackBar(context, "Upload Sucessfull");
        },
        error: (error, st) {
          showSnackBar(context, error.toString());
        },
        loading: () {},
      );
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: Pallete.backgroundColor,
        appBar: AppBar(
          title: const Text("Upload Song"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: uploadData,
              icon: const Icon(Icons.check, color: Colors.white),
            ),
          ],
        ),
        body: isLoading == true
            ? const Loader()
            : SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 150,
                          child: selectedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    10,
                                  ),
                                  child: Image.file(
                                    selectedImage!,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: selectImage,
                                  child: const DottedBorder(
                                    options: RectDottedBorderOptions(
                                      dashPattern: [6, 4],
                                      color: Colors.white,
                                      strokeCap: StrokeCap.round,
                                      stackFit: StackFit.loose,
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.file_upload),
                                          SizedBox(height: 10),
                                          Text("Select the thumbnail for song"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 40),
                        Form(
                          child: Column(
                            children: [
                              selectedSong != null
                                  ? AudioWaveForm(audioPath: selectedSong!.path)
                                  : CustomTextField(
                                      hintText: "Pick song",
                                      readOnly: true,
                                      controller: null,
                                      onTap: () {
                                        selectAudio();
                                      },
                                    ),
                              const SizedBox(height: 15),

                              CustomTextField(
                                hintText: "Artist",
                                controller: _artistNameContrller,
                              ),
                              const SizedBox(height: 15),
                              CustomTextField(
                                hintText: "Song Name",
                                controller: _songNameController,
                              ),

                              const SizedBox(height: 10),
                              ColorPicker(
                                color: selectedColor,
                                pickersEnabled: {ColorPickerType.wheel: true},
                                onColorChanged: (color) {
                                  selectedColor = color;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
