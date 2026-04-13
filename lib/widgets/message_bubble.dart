import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatefulWidget {
  final String text;
  final String sender;
  final String? senderPhotoUrl;
  final DateTime? timestamp;
  final bool isMe;
  final VoidCallback? onLongPress;

  const MessageBubble({
    super.key,
    required this.text,
    required this.sender,
    this.senderPhotoUrl,
    required this.timestamp,
    required this.isMe,
    this.onLongPress,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: GestureDetector(
          onLongPress: widget.onLongPress,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: widget.isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                // Sender name with avatar (only for received messages)
                if (!widget.isMe)
                  Padding(
                    padding: const EdgeInsets.only(left: 6, bottom: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Small avatar
                        _buildMiniAvatar(),
                        const SizedBox(width: 6),
                        Text(
                          widget.sender,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4A7FC1),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Message bubble
                Align(
                  alignment: widget.isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: widget.isMe
                          ? const Color(0xFF1A3A6B)
                          : const Color(0xFFEBEEF3),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: widget.isMe
                            ? const Radius.circular(20)
                            : const Radius.circular(6),
                        bottomRight: widget.isMe
                            ? const Radius.circular(6)
                            : const Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.isMe
                              ? const Color(0xFF1A3A6B)
                                  .withValues(alpha: 0.15)
                              : Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.text,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: widget.isMe
                            ? Colors.white
                            : const Color(0xFF1A2D45),
                        height: 1.4,
                      ),
                    ),
                  ),
                ),

                // Timestamp
                if (widget.timestamp != null)
                  Padding(
                    padding: EdgeInsets.only(
                      top: 4,
                      left: widget.isMe ? 0 : 14,
                      right: widget.isMe ? 14 : 0,
                    ),
                    child: Text(
                      DateFormat('h:mm a').format(widget.timestamp!),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFFB0BEC5),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a small avatar for received messages.
  Widget _buildMiniAvatar() {
    if (widget.senderPhotoUrl != null &&
        widget.senderPhotoUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 10,
        backgroundImage: NetworkImage(widget.senderPhotoUrl!),
        backgroundColor: const Color(0xFFEBEEF3),
      );
    }
    return CircleAvatar(
      radius: 10,
      backgroundColor: const Color(0xFF4A7FC1).withValues(alpha: 0.15),
      child: Text(
        widget.sender.isNotEmpty ? widget.sender[0].toUpperCase() : '?',
        style: GoogleFonts.inter(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF4A7FC1),
        ),
      ),
    );
  }
}
