class Favorite {
  final String channelId;
  final String channelName;
  final String channelType;
  final String channelCategory;
  final String channelImage;
  final String channelUrl;

  Favorite(
      {
      this.channelId,
      this.channelName,
      this.channelType,
      this.channelCategory,
      this.channelImage,
      this.channelUrl});

  Map<String, dynamic> toMap() {
    return {
      'channelId': channelId,
      'channelName': channelName,
      'channelType': channelType,
      'channelCategory': channelCategory,
      'channelImage': channelImage,
      'channelUrl': channelUrl,
    };
  }
}
