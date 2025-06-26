import 'package:c_lient/core/providers/current_song_notifiier.dart';
import 'package:c_lient/core/theme/app_pallete.dart';
import 'package:c_lient/core/utils/utils.dart';
import 'package:c_lient/features/homepage/model/song_model.dart';
import 'package:c_lient/features/homepage/view/pages/library_page.dart';
import 'package:c_lient/features/homepage/view/pages/songs_page.dart';
import 'package:c_lient/features/homepage/view/widgets/music_slab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int selectedIndex = 0;
  final selectedPage = [const SongsPage(), const LibraryPage()];

  @override
  Widget build(BuildContext context) {
    final hexCode = ref.watch(currentSongNotifierProvider)?.hex_code;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: hexCode == null
              ? null
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [hexToColor(hexCode), Pallete.transparentColor],
                  stops: const [0.0, 0.3],
                ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              selectedPage[selectedIndex],

              const Positioned(bottom: 0, child: MusicSlab()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(
              selectedIndex == 0 ? Icons.home_filled : Icons.home_outlined,
            ),
            label: "home",
          ),
          NavigationDestination(
            icon: Icon(
              selectedIndex == 1
                  ? Icons.library_music
                  : Icons.library_music_outlined,
            ),
            label: "library",
          ),
        ],
      ),
    );
  }
}
