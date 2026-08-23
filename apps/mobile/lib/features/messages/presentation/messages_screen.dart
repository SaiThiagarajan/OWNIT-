import 'package:flutter/material.dart';

import '../../../app/bottom_tab_navigation.dart';
import '../../../app/report_selection_sheet.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_bottom_navigation.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/widgets/report_fab.dart';
import '../../../core/widgets/state_views.dart';
import '../models/conversation.dart';
import 'conversation_screen.dart';

enum _MessagesState { loading, loaded, empty, error }

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  static const _tabIndex = AppNavDestination.messages;

  _MessagesState _state = _MessagesState.loading;
  List<Conversation> _conversations = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _state = _MessagesState.loading);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() {
      _conversations = kMockConversations;
      _state = _conversations.isEmpty ? _MessagesState.empty : _MessagesState.loaded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Messages'),
      ),
      floatingActionButton: ReportFab(onPressed: () => showReportSelectionSheet(context)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _tabIndex.index,
        onDestinationSelected: (index) => handleBottomTabTap(
          context,
          currentIndex: _tabIndex.index,
          tappedIndex: index,
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_state == _MessagesState.loaded && _conversations.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontal,
                  AppSpacing.s16,
                  AppSpacing.screenHorizontal,
                  AppSpacing.s8,
                ),
                child: Text(
                  'Your verified conversations',
                  style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                ),
              ),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (_state) {
      case _MessagesState.loading:
        return _LoadingConversations();
      case _MessagesState.loaded:
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          itemCount: _conversations.length,
          separatorBuilder: (_, _) => const Divider(color: AppColors.border, height: 1),
          itemBuilder: (context, index) {
            final conversation = _conversations[index];
            return _ConversationRow(
              conversation: conversation,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ConversationScreen(conversation: conversation)),
              ),
            );
          },
        );
      case _MessagesState.empty:
        return const Center(
          child: EmptyState(
            icon: Icons.chat_bubble_outline,
            title: 'No verified conversations yet',
            message: 'Once a match is verified, your conversation will appear here.',
          ),
        );
      case _MessagesState.error:
        return Center(
          child: ErrorState(
            title: "Couldn't load your conversations",
            actionLabel: 'Retry',
            onAction: _load,
          ),
        );
    }
  }
}

class _LoadingConversations extends StatelessWidget {
  const _LoadingConversations();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.s16,
      ),
      itemCount: 4,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s20),
      itemBuilder: (context, index) {
        return Row(
          children: [
            const LoadingSkeleton(width: 48, height: 48, borderRadius: 24),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LoadingSkeleton(width: 140, height: 14),
                  const SizedBox(height: AppSpacing.s8),
                  const LoadingSkeleton(width: 200, height: 12),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ConversationRow extends StatelessWidget {
  const _ConversationRow({required this.conversation, required this.onTap});

  final Conversation conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      label: '${conversation.name}, ${conversation.itemTitle}'
          '${conversation.unread ? ', unread' : ''}',
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceElevated,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  conversation.name.substring(0, 1),
                  style: textTheme.titleLarge?.copyWith(color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          conversation.name,
                          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: AppSpacing.s8),
                        Expanded(
                          child: Text(
                            conversation.itemTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(color: AppColors.textTertiary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    Text(
                      conversation.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: conversation.unread ? AppColors.textPrimary : AppColors.textSecondary,
                        fontWeight: conversation.unread ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    conversation.timeLabel,
                    style: textTheme.bodySmall?.copyWith(color: AppColors.textTertiary),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  if (conversation.unread)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
