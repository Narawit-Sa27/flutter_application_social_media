import 'package:flutter/material.dart';
import 'package:flutter_application_socail_media/Model/Comment.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final List<CommentModel> comments = [];
  final TextEditingController commentController = TextEditingController();
  String? replyingToCommentId;
  String? replyingToName;
  final RxBool replyIsSelect = false.obs;
  final Map<String, RxBool> favoriteMap = {};

  @override
  void initState() {
    super.initState();
    comments.addAll(_mockComments());
  }

  RxBool getFavoriteState(String commentId) {
    return favoriteMap.putIfAbsent(commentId, () => false.obs);
  }

  List<CommentModel> _mockComments() {
    return [
      CommentModel(
        id: const Uuid().v4(),
        author: 'Clive Bixby',
        content: 'Cheers! 🙌 much appreciated',
        replies: [
          CommentModel(
            id: const Uuid().v4(),
            author: 'Seb Johanssen',
            content: 'Thanks a bunch, champ!',
          ),
        ],
      ),
    ];
  }

  void addComment(String content) {
    final replyContent =
        replyingToName != null ? "@$replyingToName $content" : content;

    final newComment = CommentModel(
      id: const Uuid().v4(),
      author: 'You',
      content: replyContent,
    );

    setState(() {
      if (replyingToCommentId == null) {
        comments.add(newComment);
      } else {
        final parentIndex = comments.indexWhere(
          (c) => c.id == replyingToCommentId,
        );
        if (parentIndex != -1) {
          final parent = comments[parentIndex];
          comments[parentIndex] = CommentModel(
            id: parent.id,
            author: parent.author,
            content: parent.content,
            replies: [...parent.replies, newComment],
          );
        }
      }

      replyingToCommentId = null;
      replyingToName = null;
      commentController.clear();
    });
  }

  Widget buildComment(CommentModel comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _commentHeader(comment.author, "2 mins ago"),
          const SizedBox(height: 6),
          Text(comment.content, style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 8),
          _buildActionComment(
            rootCommentId: comment.id,
            replyingToAuthor: comment.author,
            commentId: comment.id,
          ),
          if (comment.replies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                children:
                    comment.replies.map((reply) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _commentHeader(reply.author, "just now"),
                            const SizedBox(height: 4),
                            Text(
                              reply.content,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            _buildActionComment(
                              rootCommentId:
                                  comment.id, // 👈 ชี้กลับ comment หลัก
                              replyingToAuthor: reply.author,
                              commentId: reply.id,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionComment({
    required String rootCommentId,
    required String replyingToAuthor,
    required String commentId,
  }) {
    final favorite = getFavoriteState(commentId);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () {
            favorite.value = !favorite.value;
          },
          icon: Obx(
            () =>
                favorite.value
                    ? Icon(PhosphorIconsFill.heart, size: 16, color: Colors.red)
                    : Icon(PhosphorIconsRegular.heart, size: 16),
          ),
        ),
        Obx(
          () =>
              replyIsSelect.value
                  ? TextButton.icon(
                    onPressed: () {
                      replyIsSelect.toggle();
                      setState(() {
                        replyingToCommentId = null;
                        replyingToName = null;
                      });
                      commentController.clear();
                    },
                    icon: Icon(PhosphorIconsRegular.arrowBendUpLeft, size: 16),
                    label: Text("Reply"),
                  )
                  : TextButton.icon(
                    onPressed: () {
                      replyIsSelect.toggle();
                      setState(() {
                        replyingToCommentId = rootCommentId;
                        replyingToName = replyingToAuthor;
                      });
                      commentController.clear();
                    },
                    icon: Icon(PhosphorIconsRegular.arrowBendUpLeft, size: 16),
                    label: Text("Reply"),
                  ),
        ),
      ],
    );
  }

  Widget _commentHeader(String name, String time) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=$name"),
          radius: 14,
        ),
        const SizedBox(width: 8),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 6),
        Text(
          "• $time",
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(children: comments.map(buildComment).toList()),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Hassan is typing...",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText:
                          (replyingToCommentId != null &&
                                  replyingToName != null)
                              ? 'Replying to @$replyingToName'
                              : 'Write a comment...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    if (commentController.text.trim().isNotEmpty) {
                      addComment(commentController.text.trim());
                    }
                  },
                  icon: Icon(
                    PhosphorIconsRegular.paperPlaneTilt,
                    size: 28,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
