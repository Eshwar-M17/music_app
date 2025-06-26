import 'package:c_lient/core/providers/current_user_provider.dart';
import 'package:c_lient/core/theme/theme.dart';
import 'package:c_lient/features/homepage/view/pages/home_page.dart';
import 'package:c_lient/features/auth/view/pages/login_page.dart';
import 'package:c_lient/features/auth/viewmodel/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  await Hive.openBox('recent-played');
   await Hive.openBox('favorite-played');
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  final container = ProviderContainer();
  final notifier = container.read(authViewModelProvider.notifier);
  await notifier.sharedPreferencesIntilize();
  await notifier.getUserData();

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserNotifierProvider);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkThemeMode,
      home: user == null ? const LoginPage() : const HomePage(),
    );
  }
}


