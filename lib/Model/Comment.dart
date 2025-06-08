class CommentModel {
  final String id;
  final String author;
  final String content;
  final List<CommentModel> replies;

  CommentModel({
    required this.id,
    required this.author,
    required this.content,
    this.replies = const [],
  });
}