import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String id;
  String videoUrl;
  String videoDescription;
  String effectName;
  String effectIcon;
  String lensGroupId;
  String lensId;
  List<String> tags;
  int likes;
  int dislikes;

  Video({
    required this.id,
    required this.videoUrl,
    required this.videoDescription,
    required this.effectName,
    required this.effectIcon,
    required this.lensGroupId,
    required this.lensId,
    required this.tags,
    required this.likes,
    required this.dislikes,
  });

  factory Video.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Video(
      id: doc.id,
      videoUrl: data['video_url'] ?? '',
      videoDescription: data['video_description'] ?? '',
      effectName: data['effect_name'] ?? '',
      effectIcon: data['effect_icon'] ?? '',
      lensGroupId: data['lens_group_id'] ?? '',
      lensId: data['lens_id'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      likes: data['likes'] ?? 0,
      dislikes: data['dislikes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "video_url": videoUrl,
        "video_description": videoDescription,
        "effect_name": effectName,
        "effect_icon": effectIcon,
        "lens_group_id": lensGroupId,
        "lens_id": lensId,
        "tags": tags,
        "likes": likes,
        "dislikes": dislikes,
      };
}
