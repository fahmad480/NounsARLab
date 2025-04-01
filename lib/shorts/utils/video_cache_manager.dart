import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';
import 'dart:collection';
import 'package:hive/hive.dart';

class VideoCacheManager {
  static final VideoCacheManager _instance = VideoCacheManager._internal();
  factory VideoCacheManager() => _instance;

  VideoCacheManager._internal() {
    _loadCachedUrls();
  }

  // Cache of initialized video controllers
  final Map<String, VideoPlayerController> _cachedControllers = {};

  // LRU queue to track least recently used videos for cleanup
  final ListQueue<String> _videoQueue = ListQueue<String>();

  // Maximum number of videos to keep in cache
  final int _maxCacheSize = 10;

  // Set to track URLs that have been cached to disk by the system
  final Set<String> _cachedUrls = {};

  // Preloading status tracking
  final Map<String, bool> _preloadingStatus = {};

  Future<void> _loadCachedUrls() async {
    try {
      final videoBox = Hive.box('videoBox');
      final cachedList =
          videoBox.get('cached_video_urls', defaultValue: <String>[]);
      if (cachedList is List) {
        _cachedUrls.addAll(cachedList.cast<String>());
      }
      if (kDebugMode) {
        print('Loaded ${_cachedUrls.length} cached URLs from storage');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading cached URLs: $e');
      }
    }
  }

  Future<void> _saveCachedUrls() async {
    try {
      final videoBox = Hive.box('videoBox');
      await videoBox.put('cached_video_urls', _cachedUrls.toList());
    } catch (e) {
      if (kDebugMode) {
        print('Error saving cached URLs: $e');
      }
    }
  }

  // Get a controller for a video URL, either from cache or newly initialized
  Future<VideoPlayerController> getController(String videoUrl) async {
    // If controller is already in cache, move it to most recently used and return
    if (_cachedControllers.containsKey(videoUrl)) {
      _videoQueue.remove(videoUrl);
      _videoQueue.add(videoUrl);
      return _cachedControllers[videoUrl]!;
    }

    // Create a new controller
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true,
        allowBackgroundPlayback: false,
      ),
    );

    // Initialize the controller
    try {
      await controller.initialize();
      controller.setLooping(true);

      // Add to cache
      _cachedControllers[videoUrl] = controller;
      _videoQueue.add(videoUrl);
      _cachedUrls.add(videoUrl);
      await _saveCachedUrls();

      // Clean up old controllers if cache is too large
      _cleanupCache();

      return controller;
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing video controller: $e');
      }
      // Return the controller anyway, the error will be handled by the UI
      return controller;
    }
  }

  // Preload a video without displaying it
  Future<void> preloadVideo(String videoUrl) async {
    if (_cachedControllers.containsKey(videoUrl) ||
        _preloadingStatus[videoUrl] == true) {
      return; // Already cached or being preloaded
    }

    try {
      _preloadingStatus[videoUrl] = true;

      final controller = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: false,
        ),
      );

      await controller.initialize();
      controller.setLooping(true);

      // Pause immediately after loading
      controller.pause();

      // Add to cache
      _cachedControllers[videoUrl] = controller;
      _videoQueue.add(videoUrl);
      _cachedUrls.add(videoUrl);
      await _saveCachedUrls();

      // Clean up if needed
      _cleanupCache();

      if (kDebugMode) {
        print('Preloaded video: $videoUrl');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error preloading video: $e');
      }
    } finally {
      _preloadingStatus[videoUrl] = false;
    }
  }

  // Clean up least recently used videos if cache exceeds max size
  void _cleanupCache() {
    while (_videoQueue.length > _maxCacheSize) {
      final oldestUrl = _videoQueue.removeFirst();
      final controller = _cachedControllers.remove(oldestUrl);
      controller?.dispose();
      if (kDebugMode) {
        print('Removed video from cache: $oldestUrl');
      }
    }
  }

  // Check if a video URL is in the cache
  bool isVideoCached(String videoUrl) {
    return _cachedControllers.containsKey(videoUrl) ||
        _cachedUrls.contains(videoUrl);
  }

  // Release a specific video controller
  Future<void> releaseController(String videoUrl) async {
    final controller = _cachedControllers.remove(videoUrl);
    if (controller != null) {
      _videoQueue.remove(videoUrl);
      await controller.dispose();
    }
  }

  // Release all video controllers
  Future<void> releaseAllControllers() async {
    for (final controller in _cachedControllers.values) {
      await controller.dispose();
    }
    _cachedControllers.clear();
    _videoQueue.clear();
  }
}
