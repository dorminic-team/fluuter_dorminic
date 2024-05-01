class Announcement {
  final int announcementId;
  final String topic;
  final String description;
  final bool isExpired;

  Announcement({
    required this.announcementId,
    required this.topic,
    required this.description,
    required this.isExpired,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      announcementId: json['announcement_id'],
      topic: json['topic'],
      description: json['description'],
      isExpired: json['isExpired'] == 1,
    );
  }
}
