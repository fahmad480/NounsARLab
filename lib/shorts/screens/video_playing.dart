import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:nouns_dao_ar/shorts/model/model.dart';
import 'package:nouns_dao_ar/shorts/widgets/video_play_item.dart';
import 'package:nouns_dao_ar/media_result_screen.dart';
import 'package:camerakit_flutter/camerakit_flutter.dart';
import 'package:camerakit_flutter/lens_model.dart';
import 'package:nouns_dao_ar/constants.dart';
import 'package:hive/hive.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'package:nouns_dao_ar/shorts/utils/video_cache_manager.dart';

class VideoPlayingScreen extends StatefulWidget {
  final bool isActive;

  const VideoPlayingScreen({
    super.key,
    this.isActive = true,
  });

  @override
  State<VideoPlayingScreen> createState() => VideoPlayingScreenState();
}

class VideoPlayingScreenState extends State<VideoPlayingScreen>
    implements CameraKitFlutterEvents {
  List<Video> _videos = [];
  RefreshController refreshController = RefreshController();
  PageController pageController = PageController();
  late String _filePath = '';
  late String _fileType = '';
  late List<Lens> lensList = [];
  bool isLensListPressed = false;
  late final CameraKitFlutterImpl _cameraKitFlutterImpl;
  bool _isDescriptionExpanded = false;
  late Box _videoBox;
  int _currentPage = 0;
  final VideoCacheManager _cacheManager = VideoCacheManager();
  bool _isActive = true;

  // Regular expression to detect URLs
  final RegExp _urlRegex = RegExp(
    r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
    caseSensitive: false,
  );

  // Function to open URLs in device browser
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (kDebugMode) {
        print('Could not launch $url');
      }
    }
  }

  // Create clickable text with URLs and see more/less button at the end
  Widget _buildClickableText(String text,
      {int? maxLines, bool expand = false, bool longText = false}) {
    List<InlineSpan> textSpans = [];
    int lastMatchEnd = 0;

    for (var match in _urlRegex.allMatches(text)) {
      // Add text before the URL
      if (match.start > lastMatchEnd) {
        textSpans.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        );
      }

      // Add the URL with blue color and clickable
      final url = text.substring(match.start, match.end);
      textSpans.add(
        TextSpan(
          text: url,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()..onTap = () => _launchUrl(url),
        ),
      );

      lastMatchEnd = match.end;
    }

    // Add remaining text after the last URL
    if (lastMatchEnd < text.length) {
      textSpans.add(
        TextSpan(
          text: text.substring(lastMatchEnd),
          style: const TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      );
    }

    // Add "See more"/"See less" text at the end if the text is long
    if (longText) {
      // Add a space before "See more"/"See less"
      textSpans.add(
        const TextSpan(
          text: " ",
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      );

      // Add the "See more"/"See less" text with blue color
      textSpans.add(
        TextSpan(
          text: expand ? "See less" : "See more",
          style: const TextStyle(
            fontSize: 15,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return RichText(
      text: TextSpan(
        children: textSpans,
      ),
      maxLines: expand ? null : maxLines,
      overflow: expand ? TextOverflow.visible : TextOverflow.ellipsis,
    );
  }

  @override
  void initState() {
    super.initState();
    _isActive = widget.isActive;
    refreshController = RefreshController(initialRefresh: true);
    pageController = PageController(initialPage: 0, viewportFraction: 1);
    _cameraKitFlutterImpl = CameraKitFlutterImpl(cameraKitFlutterEvents: this);
    _videoBox = Hive.box('videoBox');

    // Listen for page changes to preload videos
    pageController.addListener(_onPageChange);
  }

  @override
  void didUpdateWidget(VideoPlayingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      setActiveState(widget.isActive);
    }
  }

  // Method to be called from parent to set active state
  void setActiveState(bool active) {
    if (_isActive != active) {
      setState(() {
        _isActive = active;
      });

      // Pause/resume video based on active state
      if (_videos.isNotEmpty) {
        handleVideoPlayback();
      }
    }
  }

  // Handle video playback based on active state
  void handleVideoPlayback() {
    if (_currentPage >= 0 && _currentPage < _videos.length) {
      // Force a rebuild of the current video with updated active state
      setState(() {});
    }
  }

  void _onPageChange() {
    // Check if we're settled on a page
    if (pageController.position.haveDimensions &&
        !pageController.position.isScrollingNotifier.value) {
      final currentPage = pageController.page!.round();

      if (_currentPage != currentPage) {
        _currentPage = currentPage;
        _preloadAdjacentVideos(currentPage);
      }
    }
  }

  void _preloadAdjacentVideos(int currentIndex) {
    // Preload next video
    if (currentIndex + 1 < _videos.length) {
      _cacheManager.preloadVideo(_videos[currentIndex + 1].videoUrl);
      if (kDebugMode) {
        print('Preloading next video: ${_videos[currentIndex + 1].videoUrl}');
      }
    }

    // Preload previous video
    if (currentIndex - 1 >= 0) {
      _cacheManager.preloadVideo(_videos[currentIndex - 1].videoUrl);
      if (kDebugMode) {
        print(
            'Preloading previous video: ${_videos[currentIndex - 1].videoUrl}');
      }
    }

    // Optionally preload two videos ahead for smoother experience
    if (currentIndex + 2 < _videos.length) {
      _cacheManager.preloadVideo(_videos[currentIndex + 2].videoUrl);
    }
  }

  Future<bool> getVideoData({bool isRefresh = false}) async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Videos').get();

      List<Video> videos =
          querySnapshot.docs.map((doc) => Video.fromFirestore(doc)).toList();
      videos.shuffle(Random());

      // Filter out reported videos
      videos = videos.where((video) {
        return !_videoBox.containsKey('${video.id}_report');
      }).toList();

      if (isRefresh) {
        _videos = videos;
      } else {
        _videos.addAll(videos);
      }

      // Preload first few videos immediately
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_videos.isNotEmpty) {
          // Preload current and next video
          _preloadAdjacentVideos(0);
        }
      });

      setState(() {});
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching videos: $e');
      }
      return false;
    }
  }

  void openCameraKitWithLens(String lensId, String groupId) {
    _cameraKitFlutterImpl.openCameraKitWithSingleLens(
      lensId: lensId,
      groupId: groupId,
      isHideCloseButton: false,
    );
  }

  Future<void> initCameraKit() async {
    try {
      await _cameraKitFlutterImpl.openCameraKit(
          groupIds: Constants.groupIdList, isHideCloseButton: false);
    } on PlatformException {
      if (kDebugMode) {
        print("Failed to open camera kit");
      }
    }
  }

  void _showTagOptions(String tag) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.black,
          padding: const EdgeInsets.only(bottom: 20), // Add bottom padding
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.thumb_up, color: Colors.white),
                title: const Text('Like Tag',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  _handleTagAction('like', tag);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.thumb_down, color: Colors.white),
                title: const Text('Dislike Tag',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  _handleTagAction('dislike', tag);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.white),
                title:
                    const Text('Cancel', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleTagAction(String action, String tag) {
    setState(() {
      if (action == 'like') {
        _videoBox.delete('disliked_tag_$tag');
        _videoBox.put('liked_tag_$tag', true);
      } else if (action == 'dislike') {
        _videoBox.delete('liked_tag_$tag');
        _videoBox.put('disliked_tag_$tag', true);
      }
    });
    if (kDebugMode) {
      print('User chose to $action the tag: $tag');
    }
  }

  Widget _getScreen() {
    return _buildMainContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          _getScreen(),
          Positioned(
            top: 55,
            left: 10,
            child: IconButton(
              onPressed: () async {
                await initCameraKit();
              },
              icon: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
                size: 28, // Increased icon size
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SmartRefresher(
      controller: refreshController,
      enablePullUp: true,
      onRefresh: () async {
        final result = await getVideoData(isRefresh: true);
        if (result) {
          refreshController.refreshCompleted();
        } else {
          refreshController.refreshFailed();
        }
      },
      onLoading: () async {
        final result = await getVideoData();
        if (result) {
          refreshController.loadComplete();
        } else {
          refreshController.loadFailed();
        }
      },
      child: PageView.builder(
        controller: pageController,
        scrollDirection: Axis.vertical,
        itemBuilder: (_, index) {
          final video = _videos[index];
          return Stack(
            children: [
              VideoPlayItem(
                videoId: video.id,
                videoUrl: video.videoUrl,
                videoLikes: video.likes,
                videoDislikes: video.dislikes,
                videoLiked: false,
                videoDisliked: false,
                videoDescription: video.videoDescription,
                effectName: video.effectName,
                effectIcon: video.effectIcon,
                lensGroupId: video.lensGroupId,
                lensId: video.lensId,
                tags: video.tags,
                isActive: index == _currentPage && _isActive,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 15.0), // Tambahkan padding di sini
                child: Column(
                  children: [
                    const SizedBox(height: 50), // Reduced height
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 60,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundImage:
                                            NetworkImage(video.effectIcon),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          video.effectName.isNotEmpty
                                              ? video.effectName
                                              : "Nouns AR",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          openCameraKitWithLens(
                                              video.lensId, video.lensGroupId);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFFFBC311),
                                          minimumSize: const Size(50, 33),
                                        ),
                                        child: const Text(
                                          "Use Effect",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 0,
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis
                                        .horizontal, // Aktifkan scroll horizontal
                                    child: Wrap(
                                      spacing: 8.0,
                                      runSpacing: 4.0,
                                      children: video.tags.map((tag) {
                                        final backgroundColor =
                                            const Color.fromARGB(
                                                    255, 201, 79, 79)
                                                .withOpacity(1);
                                        return GestureDetector(
                                          onTap: () => _showTagOptions(tag),
                                          child: Chip(
                                            label: Text(
                                              tag,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            backgroundColor: backgroundColor,
                                            labelStyle: const TextStyle(
                                              color: Colors.white,
                                            ),
                                            labelPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal:
                                                  4.0, // Adjust the horizontal padding
                                              vertical:
                                                  0.0, // Adjust the vertical padding
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  100), // Fully rounded corners
                                              side: BorderSide
                                                  .none, // Remove border
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isDescriptionExpanded =
                                            !_isDescriptionExpanded;
                                      });
                                    },
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (video.videoDescription.length >
                                              100)
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.30),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: _buildClickableText(
                                                video.videoDescription,
                                                maxLines: _isDescriptionExpanded
                                                    ? null
                                                    : 2,
                                                expand: _isDescriptionExpanded,
                                                longText: true,
                                              ),
                                            )
                                          else
                                            _buildClickableText(
                                              video.videoDescription,
                                              maxLines: _isDescriptionExpanded
                                                  ? null
                                                  : 2,
                                              expand: _isDescriptionExpanded,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        itemCount: _videos.length,
        onPageChanged: (page) {
          setState(() {
            _currentPage = page;

            // Load more videos when approaching the end
            if (page >= _videos.length - 3) {
              getVideoData();
            }
          });
        },
      ),
    );
  }

  @override
  void onCameraKitResult(Map<dynamic, dynamic> result) {
    setState(() {
      _filePath = result["path"] as String;
      _fileType = result["type"] as String;

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MediaResultWidget(
                filePath: _filePath,
                fileType: _fileType,
              )));
    });
  }

  @override
  void receivedLenses(List<Lens> lensList) async {
    // isLensListPressed = false;
    // setState(() {});
    // final result = await Navigator.of(context).push(MaterialPageRoute(
    //         builder: (context) => LensListView(lensList: lensList)))
    //     as Map<String, dynamic>?;
    // final lensId = result?['lensId'] as String?;
    // final groupId = result?['groupId'] as String?;

    // if ((lensId?.isNotEmpty ?? false) && (groupId?.isNotEmpty ?? false)) {
    //   _cameraKitFlutterImpl.openCameraKitWithSingleLens(
    //       lensId: lensId!, groupId: groupId!, isHideCloseButton: false);
    // }
  }

  @override
  void dispose() {
    refreshController.dispose();
    pageController.dispose();
    _cacheManager.releaseAllControllers(); // Clean up all cached videos
    super.dispose();
  }
}

class InitCameraScreen extends StatelessWidget {
  final Future<void> Function() initCameraKit;

  const InitCameraScreen({required this.initCameraKit, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Init Camera'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await initCameraKit();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => const VideoPlayingScreen()),
            );
          },
          child: const Text('Initialize Camera'),
        ),
      ),
    );
  }
}
