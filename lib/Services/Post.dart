class Post {
  final String userProfile;
  final String userName;
  final String userHandle;
  final String timeAgo;
  final String postText;
  final String imageUrl;
  final int likes;
  final int comments;
  final int shares;

  Post({
    required this.userProfile,
    required this.userName,
    required this.userHandle,
    required this.timeAgo,
    required this.postText,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.shares,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userProfile: json['userProfile'],
      userName: json['userName'],
      userHandle: json['userHandle'],
      timeAgo: json['timeAgo'],
      postText: json['postText'],
      imageUrl: json['imageUrl'],
      likes: json['likes'],
      comments: json['comments'],
      shares: json['shares'],
    );
  }
}
