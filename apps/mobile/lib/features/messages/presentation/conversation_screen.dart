import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/buttons/secondary_button.dart';
import '../models/conversation.dart';

/// Secure chat for a verified match. Backend messaging isn't implemented —
/// sent messages and the "returned" state are local/in-memory only.
class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key, required this.conversation});

  final Conversation conversation;

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  late final List<ChatMessage> _messages = List.of(widget.conversation.messages);
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  bool _returned = false;

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _inputController.text.trim();
    if (text.isEmpty || _returned) return;
    setState(() {
      _messages.add(ChatMessage(text: text, fromMe: true, timeLabel: 'Just now'));
      _inputController.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _confirmMarkReturned() async {
    final confirmed = await AppBottomSheet.show<bool>(
      context: context,
      title: 'Mark item as returned?',
      builder: (context) {
        final textTheme = Theme.of(context).textTheme;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This helps keep OWNIT accurate for everyone. You can still view this conversation afterward.',
              style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.s24),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: 'Cancel',
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
                const SizedBox(width: AppSpacing.s12),
                Expanded(
                  child: PrimaryButton(
                    label: 'Confirm',
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      setState(() => _returned = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final conversation = widget.conversation;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.surfaceElevated,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(conversation.name.substring(0, 1), style: textTheme.bodyMedium),
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(conversation.name, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                  Text(
                    conversation.itemTitle,
                    style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Semantics(
            button: true,
            label: _returned ? 'Item marked as returned' : 'Mark item as returned',
            child: IconButton(
              icon: Icon(
                _returned ? Icons.task_alt : Icons.task_alt_outlined,
                color: _returned ? AppColors.foundTeal : AppColors.textSecondary,
              ),
              onPressed: _returned ? null : _confirmMarkReturned,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal,
                vertical: AppSpacing.s12,
              ),
              color: AppColors.surface,
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: AppSpacing.s8),
                  Expanded(
                    child: Text(
                      'Keep meetups in public places.',
                      style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            if (_returned)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal,
                  vertical: AppSpacing.s8,
                ),
                color: AppColors.foundTint,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline, size: 14, color: AppColors.foundTeal),
                    const SizedBox(width: AppSpacing.s8),
                    Text(
                      'Item marked as returned',
                      style: textTheme.bodySmall?.copyWith(color: AppColors.foundTeal),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal,
                  vertical: AppSpacing.s16,
                ),
                itemCount: _messages.length,
                itemBuilder: (context, index) => _MessageBubble(message: _messages[index]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontal,
                AppSpacing.s8,
                AppSpacing.screenHorizontal,
                AppSpacing.s16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: AppSpacing.controlHeight,
                      child: TextField(
                        controller: _inputController,
                        enabled: !_returned,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _send(),
                        decoration: InputDecoration(
                          hintText: _returned ? 'Conversation resolved' : 'Message',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  Semantics(
                    button: true,
                    label: 'Send message',
                    child: Material(
                      color: _returned
                          ? AppColors.surfaceElevated
                          : AppColors.orange,
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: _returned ? null : _send,
                        customBorder: const CircleBorder(),
                        child: SizedBox(
                          width: AppSpacing.controlHeight,
                          height: AppSpacing.controlHeight,
                          child: Icon(
                            Icons.arrow_upward,
                            color: _returned ? AppColors.textTertiary : AppColors.onAccent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(AppSpacing.radiusControl);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s12),
      child: Row(
        mainAxisAlignment: message.fromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
            child: Column(
              crossAxisAlignment:
                  message.fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s16,
                    vertical: AppSpacing.s12,
                  ),
                  decoration: BoxDecoration(
                    color: message.fromMe
                        ? AppColors.orange.withValues(alpha: 0.14)
                        : AppColors.surfaceElevated,
                    borderRadius: radius,
                    border: Border.all(
                      color: message.fromMe
                          ? AppColors.orange.withValues(alpha: 0.4)
                          : AppColors.border,
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
                  ),
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  message.timeLabel,
                  style: textTheme.bodySmall?.copyWith(color: AppColors.textTertiary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
