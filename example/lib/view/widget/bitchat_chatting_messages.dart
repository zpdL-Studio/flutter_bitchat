import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bitchat/manager/data/flutter_bitchat_message.dart';
import 'package:flutter_bitchat_example/main.dart';
import 'package:intl/intl.dart';

class BitchatChattingMessages extends StatelessWidget {
  final EdgeInsetsGeometry? padding;

  const BitchatChattingMessages({super.key, this.padding});

  @override
  Widget build(BuildContext context) {
    final messages = BitChatInheritedModel.messagesOf(context);
    return ListView.separated(
      padding: padding,
      itemCount: messages.length,
      // reverse: true,
      itemBuilder: (context, index) {
        final message = messages[index];
        if (message.sender == 'system') {
          return BitchatChattingSystemMessage(message: message);
        }

        return Text(message.toString());
      },
      separatorBuilder: (context, index) => SizedBox(height: 8,),
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
              color: theme.hintColor
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
