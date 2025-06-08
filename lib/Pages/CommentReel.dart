import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

const _uuid = Uuid();

// Model สำหรับ Comment
class Comment {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String content;
  final DateTime timestamp;
  final List<Comment> replies;
  final Map<String, int> reactions; // emoji -> count
  final Map<String, bool> userReactions; // emoji -> isReacted by current user
  final String? replyToName; // ชื่อคนที่ตอบกลับ
  final String? parentId; // ID ของ comment หลัก
  final int replyLevel; // ระดับการตอบกลับ (0 = comment หลัก, 1 = reply ระดับแรก)

  Comment({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.content,
    required this.timestamp,
    this.replies = const [],
    this.reactions = const {},
    this.userReactions = const {},
    this.replyToName,
    this.parentId,
    this.replyLevel = 0,
  });

  Comment copyWith({
    List<Comment>? replies,
    Map<String, int>? reactions,
    Map<String, bool>? userReactions,
  }) {
    return Comment(
      id: this.id,
      authorName: this.authorName,
      authorAvatar: this.authorAvatar,
      content: this.content,
      timestamp: this.timestamp,
      replies: replies ?? this.replies,
      reactions: reactions ?? this.reactions,
      userReactions: userReactions ?? this.userReactions,
      replyToName: this.replyToName,
      parentId: this.parentId,
      replyLevel: this.replyLevel,
    );
  }
}

// Mock Data
class CommentData {
  static List<Comment> getMockComments() {
    return [
      Comment(
        id: _uuid.v4(),
        authorName: 'สมชาย ใจดี',
        authorAvatar: '👨‍💼',
        content: 'โพสต์นี้สุดยอดมากครับ! ได้ความรู้เยอะมาก 🔥',
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        reactions: {'👍': 12, '❤️': 8, '😍': 3},
        userReactions: {'👍': true},
        replyLevel: 0,
        replies: [
          Comment(
            id: _uuid.v4(),
            authorName: 'มาลี สวยงาม',
            authorAvatar: '👩‍💻',
            content: 'เห็นด้วยครับ เนื้อหาดีมาก',
            timestamp: DateTime.now().subtract(Duration(hours: 1)),
            reactions: {'👍': 5, '❤️': 2},
            userReactions: {},
            replyToName: 'สมชาย ใจดี',
            parentId: _uuid.v4(),
            replyLevel: 1,
          ),
        ],
      ),
      Comment(
        id: _uuid.v4(),
        authorName: 'ปิยะ นักเรียน',
        authorAvatar: '👩‍🎓',
        content: 'ขอบคุณสำหรับการแชร์ความรู้นะคะ จะนำไปประยุกต์ใช้ดู',
        timestamp: DateTime.now().subtract(Duration(hours: 3)),
        reactions: {'❤️': 15, '🙏': 7, '💯': 4},
        userReactions: {'❤️': true, '🙏': true},
        replyLevel: 0,
        replies: [],
      ),
      Comment(
        id: _uuid.v4(),
        authorName: 'วิชัย เก่งมาก',
        authorAvatar: '👨‍🔬',
        content: 'มีคำถามครับ สามารถขยายความในส่วนของ... ได้ไหมครับ?',
        timestamp: DateTime.now().subtract(Duration(hours: 5)),
        reactions: {'🤔': 3, '❓': 2},
        userReactions: {},
        replyLevel: 0,
        replies: [
          Comment(
            id: _uuid.v4(),
            authorName: 'ผู้เขียน',
            authorAvatar: '✍️',
            content: 'ขอบคุณสำหรับคำถามครับ ผมจะอธิบายเพิ่มเติมให้ฟังนะครับ... (ตัวอย่างคำตอบยาว)',
            timestamp: DateTime.now().subtract(Duration(hours: 4)),
            reactions: {'👍': 8, '🙏': 4},
            userReactions: {'👍': true},
            replyToName: 'วิชัย เก่งมาก',
            parentId: _uuid.v4(),
            replyLevel: 1,
          ),
          Comment(
            id: _uuid.v4(),
            authorName: 'วิชัย เก่งมาก',
            authorAvatar: '👨‍🔬',
            content: 'เข้าใจแล้วครับ ขอบคุณมากครับ! 🙏',
            timestamp: DateTime.now().subtract(Duration(hours: 3, minutes: 30)),
            reactions: {'🙏': 2},
            userReactions: {},
            replyToName: 'ผู้เขียน',
            parentId: _uuid.v4(),
            replyLevel: 1,
          ),
        ],
      ),
    ];
  }
}

// Widget สำหรับแสดง Comment
class CommentWidget extends StatefulWidget {
  final Comment comment;
  final bool isReply;
  final VoidCallback? onReply;
  final Function(Comment)? onReplyToComment; // เพิ่ม callback สำหรับตอบกลับ reply

  const CommentWidget({
    Key? key,
    required this.comment,
    this.isReply = false,
    this.onReply,
    this.onReplyToComment,
  }) : super(key: key);

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool showReactions = false;
  Map<String, int> currentReactions = {};
  Map<String, bool> userReactions = {};

  @override
  void initState() {
    super.initState();
    currentReactions = Map.from(widget.comment.reactions);
    userReactions = Map.from(widget.comment.userReactions);
  }

  void toggleReaction(String emoji) {
    setState(() {
      if (userReactions[emoji] == true) {
        // Remove reaction
        userReactions[emoji] = false;
        currentReactions[emoji] = (currentReactions[emoji] ?? 1) - 1;
        if (currentReactions[emoji]! <= 0) {
          currentReactions.remove(emoji);
        }
      } else {
        // Add reaction
        userReactions[emoji] = true;
        currentReactions[emoji] = (currentReactions[emoji] ?? 0) + 1;
      }
    });
  }

  String formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} นาทีที่แล้ว';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ชั่วโมงที่แล้ว';
    } else {
      return '${difference.inDays} วันที่แล้ว';
    }
  }

  @override
  Widget build(BuildContext context) {
    // กำหนด margin ตาม replyLevel แต่จำกัดไม่ให้เกิน 1 level
    double leftMargin = widget.comment.replyLevel >= 1 ? 40.0 : 0.0;
    
    return Container(
      margin: EdgeInsets.only(
        left: leftMargin,
        bottom: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    widget.comment.authorAvatar,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Author name and timestamp
                    Row(
                      children: [
                        Text(
                          widget.comment.authorName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          formatTimestamp(widget.comment.timestamp),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    // Comment content with reply mention
                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        children: [
                          if (widget.comment.replyToName != null) ...[
                            TextSpan(
                              text: '@${widget.comment.replyToName} ',
                              style: TextStyle(
                                color: Colors.indigo[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                          TextSpan(text: widget.comment.content),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    // Reactions display
                    if (currentReactions.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        children: currentReactions.entries.map((entry) {
                          final isUserReacted = userReactions[entry.key] == true;
                          return GestureDetector(
                            onTap: () => toggleReaction(entry.key),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isUserReacted ? Colors.indigo[50] : Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isUserReacted ? Colors.indigo[300]! : Colors.transparent,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(entry.key, style: TextStyle(fontSize: 12)),
                                  SizedBox(width: 4),
                                  Text(
                                    '${entry.value}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isUserReacted ? Colors.indigo[700] : Colors.grey[600],
                                      fontWeight: isUserReacted ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    SizedBox(height: 8),
                    // Action buttons
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showReactions = !showReactions;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: Row(
                              children: [
                                Icon(Icons.emoji_emotions_outlined, size: 16, color: Colors.grey[600]),
                                SizedBox(width: 4),
                                Text('แสดงความรู้สึก', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                              ],
                            ),
                          ),
                        ),
                        if (!widget.isReply) ...[
                          SizedBox(width: 16),
                          GestureDetector(
                            onTap: widget.onReply,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              child: Row(
                                children: [
                                  Icon(Icons.reply_outlined, size: 16, color: Colors.grey[600]),
                                  SizedBox(width: 4),
                                  Text('ตอบกลับ', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                ],
                              ),
                            ),
                          ),
                        ] else ...[
                          // สำหรับ reply ให้แสดงปุ่มตอบกลับได้
                          SizedBox(width: 16),
                          GestureDetector(
                            onTap: () => widget.onReplyToComment?.call(widget.comment),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              child: Row(
                                children: [
                                  Icon(Icons.reply_outlined, size: 16, color: Colors.grey[600]),
                                  SizedBox(width: 4),
                                  Text('ตอบกลับ', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    // Reaction picker
                    if (showReactions)
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Wrap(
                          spacing: 12,
                          children: ['👍', '❤️', '😍', '😂', '😮', '😢', '😡', '🙏', '💯', '🔥', '🤔', '❓']
                              .map((emoji) => GestureDetector(
                                    onTap: () {
                                      toggleReaction(emoji);
                                      setState(() {
                                        showReactions = false;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      child: Text(emoji, style: TextStyle(fontSize: 20)),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          // Replies
          if (widget.comment.replies.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Column(
                children: widget.comment.replies
                    .map((reply) => CommentWidget(
                          comment: reply,
                          isReply: true,
                          onReplyToComment: widget.onReplyToComment, // ส่งต่อ callback
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

// Main Comment Bottom Sheet
class CommentBottomSheet extends StatefulWidget {
  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController commentController = TextEditingController();
  List<Comment> comments = [];
  Comment? replyingTo;

  @override
  void initState() {
    super.initState();
    comments = CommentData.getMockComments();
  }

  // ฟังก์ชันเพิ่ม reply ลงใน comment หลัก
  void addReplyToComment(String parentId, Comment newReply) {
    setState(() {
      for (int i = 0; i < comments.length; i++) {
        if (comments[i].id == parentId) {
          List<Comment> updatedReplies = List.from(comments[i].replies);
          updatedReplies.add(newReply);
          comments[i] = comments[i].copyWith(replies: updatedReplies);
          break;
        }
      }
    });
  }

  void addComment(String content) {
    if (content.trim().isEmpty) return;

    if (replyingTo != null) {
      // สร้าง reply comment
      final newReply = Comment(
        id: _uuid.v4(),
        authorName: 'คุณ', // Current user
        authorAvatar: '😊',
        content: content,
        timestamp: DateTime.now(),
        replyToName: replyingTo!.authorName,
        parentId: replyingTo!.parentId ?? replyingTo!.id, // ใช้ parentId หรือ id ของ comment หลัก
        replyLevel: 1, // กำหนดให้ reply ทุกตัวเป็น level 1 เท่านั้น
      );

      // เพิ่ม reply เข้าไปใน comment หลัก
      addReplyToComment(replyingTo!.parentId ?? replyingTo!.id, newReply);
      replyingTo = null;
    } else {
      // สร้าง comment ใหม่
      final newComment = Comment(
        id: _uuid.v4(),
        authorName: 'คุณ', // Current user
        authorAvatar: '😊',
        content: content,
        timestamp: DateTime.now(),
        replyLevel: 0,
      );

      setState(() {
        comments.insert(0, newComment);
      });
    }

    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ความคิดเห็น (${comments.length})',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey[300]),
          
          // Comments List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return CommentWidget(
                  comment: comments[index],
                  onReply: () {
                    setState(() {
                      replyingTo = comments[index];
                    });
                  },
                  onReplyToComment: (comment) {
                    setState(() {
                      replyingTo = comment;
                    });
                  },
                );
              },
            ),
          ),

          // Reply indicator
          if (replyingTo != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.indigo[50],
              child: Row(
                children: [
                  Icon(Icons.reply, size: 16, color: Colors.indigo[700]),
                  SizedBox(width: 8),
                  Text(
                    'กำลังตอบกลับ ${replyingTo!.authorName}',
                    style: TextStyle(color: Colors.indigo[700], fontSize: 12),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () => setState(() => replyingTo = null),
                    child: Icon(Icons.close, size: 16, color: Colors.indigo[700]),
                  ),
                ],
              ),
            ),

          // Comment Input
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.indigo[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(child: Text('😊', style: TextStyle(fontSize: 16))),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: replyingTo != null 
                          ? 'เขียนตอบกลับ...' 
                          : 'เขียนความคิดเห็น...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.indigo),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    maxLines: null,
                    onSubmitted: addComment,
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  onPressed: () => addComment(commentController.text),
                  icon: Icon(
                    PhosphorIconsFill.paperPlaneTilt,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
