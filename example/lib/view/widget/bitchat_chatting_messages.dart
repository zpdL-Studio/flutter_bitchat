import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bitchat/manager/data/flutter_bitchat_message.dart';
import 'package:flutter_bitchat_example/main.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:intl/intl.dart';

class BitchatChattingMessages extends StatelessWidget {
  final EdgeInsetsGeometry? padding;

  const BitchatChattingMessages({super.key, this.padding});

  @override
  Widget build(BuildContext context) {
    final messages = BitChatInheritedModel.messagesOf(context);
    final nickName = BitChatInheritedModel.nickNameOf(context);

    return ListView.separated(
      padding: padding,
      itemCount: messages.length,
      // reverse: true,
      itemBuilder: (context, index) {
        final message = messages[index];
        if (message.sender == 'system') {
          return BitchatChattingSystemMessage(message: message);
        }
        if (message.sender == nickName) {
          return BitchatChattingMyMessage(message: message);
        }
        return BitchatChattingOtherMessage(message: message);
      },
      separatorBuilder: (context, index) => SizedBox(height: 8),
    );
  }
}

class BitchatChattingSystemMessage extends StatelessWidget {
  final FlutterBitchatMessage message;

  const BitchatChattingSystemMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localeName = Platform.localeName;
    return Container(
      alignment: AlignmentDirectional.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${DateFormat.yMMMMEEEEd(localeName).format(message.timestamp)} ${DateFormat.jm(localeName).format(message.timestamp)}',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.hintColor,
            ),
          ),
          Text(
            '* ${message.content} *',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.hintColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class BitchatChattingMyMessage extends StatelessWidget {
  final FlutterBitchatMessage message;

  const BitchatChattingMyMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localeName = Platform.localeName;
    return Container(
      alignment: AlignmentDirectional.centerEnd,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            DateFormat.jm(localeName).format(message.timestamp),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.hintColor,
            ),
          ),
          const SizedBox(width: 8,),
          Flexible(
            child: PhysicalShape(
              clipper: ChatBubbleClipper8(type: BubbleType.sendBubble),
              color: theme.colorScheme.primary,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 16,
                  end: 24,
                  top: 8,
                  bottom: 8,
                ),
                child: Text(
                  message.content,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BitchatChattingOtherMessage extends StatelessWidget {
  final FlutterBitchatMessage message;

  const BitchatChattingOtherMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localeName = Platform.localeName;
    return Container(
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: PhysicalShape(
              clipper: ChatBubbleClipper8(type: BubbleType.receiverBubble),
              color: theme.colorScheme.surface,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 24,
                  end: 16,
                  top: 8,
                  bottom: 8,
                ),
                child: Text(
                  message.content,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8,),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '<${message.sender}>',
                style: theme.textTheme.labelSmall,
              ),
              Text(
                DateFormat.jm(localeName).format(message.timestamp),
                style: theme.textTheme.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
