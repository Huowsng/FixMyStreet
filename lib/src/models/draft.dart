import 'dart:io';

class Draft {
  final File? image;
  final String? title;
  final String? titleDetail;
  final String? content;
  final double? latitude;
  final double? longitude;

  Draft({
    this.image,
    this.title,
    this.titleDetail,
    this.content,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'title': title,
      'titleDetail': titleDetail,
      'content': content,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Draft.fromJson(Map<String, dynamic> json) {
    return Draft(
      image: json['image'],
      title: json['title'],
      titleDetail: json['titleDetail'],
      content: json['content'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
