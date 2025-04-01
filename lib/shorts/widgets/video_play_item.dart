import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nouns_dao_ar/shorts/utils/video_cache_manager.dart';

class VideoPlayItem extends StatefulWidget {
  final String videoId;
  final String videoUrl;
  final int videoLikes;
  final int videoDislikes;
  final bool? videoLiked;
  final bool? videoDisliked;
  final String videoDescription;
  final String effectName;
  final String effectIcon;
  final String lensGroupId;
  final String lensId;
  final List<String> tags;
  final bool isActive;

  const VideoPlayItem({
    super.key,
    required this.videoId,
    required this.videoUrl,
    required this.videoLikes,
    required this.videoDislikes,
    this.videoLiked,
    this.videoDisliked,
    required this.videoDescription,
    required this.effectName,
    required this.effectIcon,
    required this.lensGroupId,
    required this.lensId,
    required this.tags,
    this.isActive = false,
  });

  @override
  State<VideoPlayItem> createState() => _VideoPlayItemState();
}

class _VideoPlayItemState extends State<VideoPlayItem> {
  late VideoPlayerController _videoPlayerController;
  bool _isPlaying = false;
  bool _isLoved = false;
  int _likeCount = 500;
  bool _isDisliked = false;
  int _dislikeCount = 100;
  late Box _videoBox;
  String? _selectedReportReason;
  bool _isInitialized = false;
  final VideoCacheManager _cacheManager = VideoCacheManager();

  @override
  void initState() {
    super.initState();
    _videoBox = Hive.box('videoBox');
    _isLoved = _videoBox.get('${widget.videoId}_liked',
        defaultValue: widget.videoLiked ?? false);
    _likeCount = widget.videoLikes;
    _isDisliked = _videoBox.get('${widget.videoId}_disliked',
        defaultValue: widget.videoDisliked ?? false);
    _dislikeCount = widget.videoDislikes;

    _initializeVideoPlayer();
    _storeVideoData();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      if (kDebugMode) {
        print('Initializing video player for: ${widget.videoUrl}');
      }

      _videoPlayerController =
          await _cacheManager.getController(widget.videoUrl);

      setState(() {
        _isInitialized = true;
      });

      if (widget.isActive) {
        _videoPlayerController.play();
        _isPlaying = true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing video player: $e');
      }
    }
  }

  @override
  void didUpdateWidget(VideoPlayItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle active state changes
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive && _isInitialized) {
        _videoPlayerController.play();
        setState(() {
          _isPlaying = true;
        });
        if (kDebugMode) {
          print('Video playing: ${widget.videoId}');
        }
      } else if (!widget.isActive && _isInitialized) {
        _videoPlayerController.pause();
        setState(() {
          _isPlaying = false;
        });
        if (kDebugMode) {
          print('Video paused: ${widget.videoId}');
        }
      }
    }
  }

  void _storeVideoData() {
    final videoData = {
      'videoId': widget.videoId,
      'videoUrl': widget.videoUrl,
      'videoLikes': widget.videoLikes,
      'videoDislikes': widget.videoDislikes,
      'videoDescription': widget.videoDescription,
      'effectName': widget.effectName,
      'effectIcon': widget.effectIcon,
      'lensGroupId': widget.lensGroupId,
      'lensId': widget.lensId,
      'tags': widget.tags,
    };
    _videoBox.put(widget.videoId, videoData);
  }

  void _onLoveIconTapped() {
    setState(() {
      _isLoved = !_isLoved;
      _likeCount += _isLoved ? 1 : -1;
      _videoBox.put('${widget.videoId}_liked', _isLoved);
    });
    if (kDebugMode) {
      print('Love icon tapped');
    }
  }

  void _onDislikeIconTapped() {
    setState(() {
      _isDisliked = !_isDisliked;
      _dislikeCount += _isDisliked ? 1 : -1;
      _videoBox.put('${widget.videoId}_disliked', _isDisliked);
    });
    if (kDebugMode) {
      print('Dislike icon tapped');
    }
  }

  void _onShareIconTapped() {
    Share.share(widget.videoUrl);
    Fluttertoast.showToast(
      msg: "Shared successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
    if (kDebugMode) {
      print('Share icon tapped: ${widget.videoUrl}');
    }
  }

  void _seeMoreLikeThis() {
    _videoBox.put('${widget.videoId}_see_more_like_this', true);
    Fluttertoast.showToast(
      msg: "You'll see more content like this",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
    if (kDebugMode) {
      print('See more like this');
    }
  }

  void _seeLessLikeThis() {
    _videoBox.put('${widget.videoId}_see_less_like_this', true);
    Fluttertoast.showToast(
      msg: "You'll see less content like this",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
    if (kDebugMode) {
      print('See less like this');
    }
  }

  void _showReportModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              color: Colors.black,
              padding: const EdgeInsets.all(20)
                  .copyWith(bottom: 60), // Add bottom padding
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Report Video',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  RadioListTile<String>(
                    title: const Text('Inappropriate content',
                        style: TextStyle(color: Colors.white)),
                    value: 'Inappropriate content',
                    groupValue: _selectedReportReason,
                    onChanged: (value) {
                      setState(() {
                        _selectedReportReason = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Spam',
                        style: TextStyle(color: Colors.white)),
                    value: 'Spam',
                    groupValue: _selectedReportReason,
                    onChanged: (value) {
                      setState(() {
                        _selectedReportReason = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Hate speech',
                        style: TextStyle(color: Colors.white)),
                    value: 'Hate speech',
                    groupValue: _selectedReportReason,
                    onChanged: (value) {
                      setState(() {
                        _selectedReportReason = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Violence',
                        style: TextStyle(color: Colors.white)),
                    value: 'Violence',
                    groupValue: _selectedReportReason,
                    onChanged: (value) {
                      setState(() {
                        _selectedReportReason = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Misinformation',
                        style: TextStyle(color: Colors.white)),
                    value: 'Misinformation',
                    groupValue: _selectedReportReason,
                    onChanged: (value) {
                      setState(() {
                        _selectedReportReason = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_selectedReportReason != null) {
                        _report(_selectedReportReason!);
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                          msg: "Video Reported",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _report(String reason) {
    _videoBox.put('${widget.videoId}_report', reason);
    if (kDebugMode) {
      print('Report reason: $reason');
    }
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.black,
          padding: const EdgeInsets.only(bottom: 60), // Add bottom padding
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.more, color: Colors.white),
                title: const Text('See more like this',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  _seeMoreLikeThis();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.remove, color: Colors.white),
                title: const Text('See less like this',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  _seeLessLikeThis();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.report, color: Colors.white),
                title:
                    const Text('Report', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _showReportModal();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // Don't dispose the controller here since it's managed by the cache
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      // Avoids overlay on iOS status bar
      child: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(color: Colors.black),
        child: GestureDetector(
          onTap: () {
            if (_isInitialized) {
              setState(() {
                if (_videoPlayerController.value.isPlaying) {
                  _videoPlayerController.pause();
                  _isPlaying = false;
                } else {
                  _videoPlayerController.play();
                  _isPlaying = true;
                }
              });
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              _isInitialized
                  ? VideoPlayer(_videoPlayerController)
                  : const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
              if (_isInitialized && !_isPlaying)
                Icon(
                  Icons.play_arrow,
                  color: Colors.white.withOpacity(0.7),
                  size: 100,
                ),
              Positioned(
                right: 10,
                bottom: 180,
                child: Column(
                  children: [
                    IconButton(
                      iconSize: 35, // Double the size of the icon
                      icon: Icon(
                        Icons.favorite,
                        color: _isLoved ? Colors.red : Colors.white,
                      ),
                      onPressed: _onLoveIconTapped,
                    ),
                    // Text(
                    //   '$_likeCount',
                    //   style: const TextStyle(color: Colors.white),
                    // ),
                    const SizedBox(height: 15), // Add spacing
                    IconButton(
                      iconSize: 35, // Double the size of the icon
                      icon: Icon(
                        Icons.thumb_down,
                        color: _isDisliked ? Colors.blue : Colors.white,
                      ),
                      onPressed: _onDislikeIconTapped,
                    ),
                    // Text(
                    //   '$_dislikeCount',
                    //   style: const TextStyle(color: Colors.white),
                    // ),
                    const SizedBox(height: 15), // Add spacing
                    IconButton(
                      iconSize: 35, // Double the size of the icon
                      icon: const Icon(Icons.share, color: Colors.white),
                      onPressed: _onShareIconTapped,
                    ),
                    const SizedBox(height: 15), // Add spacing
                    IconButton(
                      iconSize: 35, // Double the size of the icon
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: _showBottomSheet,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
