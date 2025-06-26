// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_page_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getAllSongsHash() => r'6c3203ed6e2e4f5753ae5e3ea1fbdc180c12676b';

/// See also [getAllSongs].
@ProviderFor(getAllSongs)
final getAllSongsProvider = AutoDisposeFutureProvider<List<SongModel>>.internal(
  getAllSongs,
  name: r'getAllSongsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getAllSongsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetAllSongsRef = AutoDisposeFutureProviderRef<List<SongModel>>;
String _$getFavSongsHash() => r'b82d464d3d8231e0e76fbb8cc14df17f54b9bfa9';

/// See also [getFavSongs].
@ProviderFor(getFavSongs)
final getFavSongsProvider = AutoDisposeFutureProvider<List<SongModel>>.internal(
  getFavSongs,
  name: r'getFavSongsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getFavSongsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetFavSongsRef = AutoDisposeFutureProviderRef<List<SongModel>>;
String _$favoriteSongNotifierHash() =>
    r'b873670bdf74ae873103ec74116137fa1c0f5d69';

/// See also [FavoriteSongNotifier].
@ProviderFor(FavoriteSongNotifier)
final favoriteSongNotifierProvider =
    AutoDisposeNotifierProvider<
      FavoriteSongNotifier,
      AsyncValue<List<SongModel>>
    >.internal(
      FavoriteSongNotifier.new,
      name: r'favoriteSongNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$favoriteSongNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FavoriteSongNotifier =
    AutoDisposeNotifier<AsyncValue<List<SongModel>>>;
String _$favoriteStatusHash() => r'049b48c5e9d3d5b60cae40f04fa078542e0fd28f';

/// See also [FavoriteStatus].
@ProviderFor(FavoriteStatus)
final favoriteStatusProvider =
    AutoDisposeNotifierProvider<FavoriteStatus, AsyncValue<String>?>.internal(
      FavoriteStatus.new,
      name: r'favoriteStatusProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$favoriteStatusHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FavoriteStatus = AutoDisposeNotifier<AsyncValue<String>?>;
String _$homePageViewModelHash() => r'379e61d0eb839287f4a80131c1b8eabc432bd5b3';

/// See also [HomePageViewModel].
@ProviderFor(HomePageViewModel)
final homePageViewModelProvider =
    AutoDisposeNotifierProvider<
      HomePageViewModel,
      AsyncValue<SongModel>?
    >.internal(
      HomePageViewModel.new,
      name: r'homePageViewModelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$homePageViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$HomePageViewModel = AutoDisposeNotifier<AsyncValue<SongModel>?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
