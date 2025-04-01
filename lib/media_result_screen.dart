import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

class MediaResultWidget extends StatefulWidget {
  final String filePath;
  final String fileType;

  const MediaResultWidget(
      {super.key, required this.filePath, required this.fileType});

  @override
  State<MediaResultWidget> createState() => _MediaResultWidgetState();
}

class _MediaResultWidgetState extends State<MediaResultWidget> {
  late VideoPlayerController _controller;
  bool _isVideoPlaying = true;

  @override
  void initState() {
    super.initState();

    if (widget.fileType == 'video') {
      _controller = VideoPlayerController.file(File(widget.filePath))
        ..initialize().then((_) {
          setState(() {});
          _controller.play();
          _controller.setLooping(true); // Enable looping
        });
      _controller.addListener(() {
        if (!_controller.value.isPlaying &&
            _controller.value.isInitialized &&
            (_controller.value.duration == _controller.value.position)) {
          setState(() {
            _isVideoPlaying = false;
            if (kDebugMode) {
              print("Video playback completed");
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    if (widget.fileType == 'video') {
      _controller.dispose();
    }
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isVideoPlaying = _controller.value.isPlaying;
    });
  }

  void _shareMedia() {
    Share.shareXFiles([XFile(widget.filePath)],
        text: 'Check out this Nouns AR !');
  }

  Future<void> _downloadMedia() async {
    try {
      final file = File(widget.filePath);
      dynamic result;
      String mediaType = widget.fileType == 'video' ? 'Video' : 'Image';

      if (widget.fileType == 'video') {
        // For videos, use saveFile method
        result = await ImageGallerySaverPlus.saveFile(
          widget.filePath,
          isReturnPathOfIOS: true,
        );
      } else {
        // For images, use saveImage method
        final fileBytes = await file.readAsBytes();
        result = await ImageGallerySaverPlus.saveImage(
          fileBytes,
          name: 'Nouns_AR_${DateTime.now().millisecondsSinceEpoch}',
          isReturnImagePathOfIOS: true,
        );
      }

      // Handle the result properly, regardless of its specific map type
      bool isSuccess = result is Map && result['isSuccess'] == true;

      if (isSuccess) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$mediaType successfully saved to gallery')),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save $mediaType to gallery')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      if (kDebugMode) {
        print('Download media error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (widget.filePath.isNotEmpty)
            widget.fileType == 'video'
                ? GestureDetector(
                    onTap: _togglePlayPause,
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : widget.fileType == 'image'
                    ? Image.file(File(widget.filePath), fit: BoxFit.cover)
                    : const Center(child: Text("Unknown File to show")),
          if (widget.fileType == 'video')
            Center(
              child: AnimatedOpacity(
                opacity: _isVideoPlaying ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: IconButton(
                  icon: Icon(
                    _isVideoPlaying ? Icons.pause : Icons.play_arrow,
                    size: 50.0,
                    color: Colors.white,
                  ),
                  onPressed: _togglePlayPause,
                ),
              ),
            ),
          Positioned(
            bottom: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: _shareMedia,
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                // Simply pop the current screen to return to the previous state
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.download, color: Colors.white),
              onPressed: _downloadMedia,
            ),
          ),
        ],
      ),
    );
  }
}
