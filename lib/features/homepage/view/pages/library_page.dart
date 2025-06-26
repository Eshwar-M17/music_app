import 'package:c_lient/core/providers/current_song_notifiier.dart';
import 'package:c_lient/core/utils/utils.dart';
import 'package:c_lient/core/widgets/loader.dart';
import 'package:c_lient/features/homepage/view/pages/upload_song_page.dart';
import 'package:c_lient/features/homepage/viewmodel/home_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   
    
    return SafeArea(
      child: ref
          .watch(favoriteSongNotifierProvider)
          .when(
            data: (data) {
              return Container(
                padding: const EdgeInsets.all(20),
                width: double.maxFinite,
                height: double.maxFinite,
                child: ListView.builder(
                  itemCount: data.length + 1,
                  itemBuilder: (context, index) {
                    return index == data.length
                        ? ListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const UploadSongPage();
                                  },
                                ),
                              );
                            },
                            leading: const Icon(Icons.add),
                            title: const Text("Add New Song"),
                          )
                        : GestureDetector(
                            onTap: () => ref
                                .read(currentSongNotifierProvider.notifier)
                                .updateSong(data[index]),
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              height: 70,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                color: hexToColor(
                                  data[index].hex_code,
                                ).withAlpha(200),
                                borderRadius: BorderRadius.circular(10),
                              ),

                              child: Row(
                                children: [
                                  Container(
                                    width: 55,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          data[index].thumbnail_url,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          data[index].song_name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          data[index].artist,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
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
            error: (error, stackTrace) {
              return Center(child: Text(error.toString()));
            },
            loading: () {
              return const Loader();
            },
          ),
    );
  }
}
