class ChatMessage {
  const ChatMessage({required this.text, required this.fromMe, required this.timeLabel});

  final String text;
  final bool fromMe;
  final String timeLabel;
}

/// A mock secure conversation, tied to a verified match. No phone numbers
/// or other private identifiers are ever part of this model.
class Conversation {
  const Conversation({
    required this.id,
    required this.name,
    required this.itemTitle,
    required this.lastMessage,
    required this.timeLabel,
    required this.unread,
    required this.messages,
  });

  final String id;
  final String name;
  final String itemTitle;
  final String lastMessage;
  final String timeLabel;
  final bool unread;
  final List<ChatMessage> messages;
}

final List<Conversation> kMockConversations = [
  Conversation(
    id: 'c1',
    name: 'Maya',
    itemTitle: 'Black leather wallet',
    lastMessage: 'Hi, I think this might be yours.',
    timeLabel: '2m ago',
    unread: true,
    messages: const [
      ChatMessage(text: 'Hi, I think I found your wallet.', fromMe: false, timeLabel: '10:02 AM'),
      ChatMessage(
        text: 'Thanks. What time would work for the handoff?',
        fromMe: true,
        timeLabel: '10:05 AM',
      ),
      ChatMessage(text: 'Tomorrow afternoon.', fromMe: false, timeLabel: '10:06 AM'),
      ChatMessage(text: 'Hi, I think this might be yours.', fromMe: false, timeLabel: '10:07 AM'),
    ],
  ),
  Conversation(
    id: 'c2',
    name: 'Alex',
    itemTitle: 'AirPods case',
    lastMessage: 'Can we arrange the handoff?',
    timeLabel: '1h ago',
    unread: false,
    messages: const [
      ChatMessage(text: 'Hey, I saw the potential match for my AirPods.', fromMe: true, timeLabel: '9:10 AM'),
      ChatMessage(text: 'Yes! Found it near the campus area.', fromMe: false, timeLabel: '9:12 AM'),
      ChatMessage(text: 'Can we arrange the handoff?', fromMe: false, timeLabel: '9:14 AM'),
    ],
  ),
  Conversation(
    id: 'c3',
    name: 'Sam',
    itemTitle: 'Blue backpack',
    lastMessage: 'Thanks for confirming.',
    timeLabel: 'Yesterday',
    unread: false,
    messages: const [
      ChatMessage(text: 'Is this your backpack?', fromMe: false, timeLabel: 'Yesterday'),
      ChatMessage(text: 'Yes, that\'s it!', fromMe: true, timeLabel: 'Yesterday'),
      ChatMessage(text: 'Thanks for confirming.', fromMe: false, timeLabel: 'Yesterday'),
    ],
  ),
];
