import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bitchat/manager/data/flutter_bitchat_message.dart';
import 'package:flutter_bitchat_example/main.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:intl/intl.dart';

class BitchatChattingInput extends StatefulWidget {
  const BitchatChattingInput({super.key});

  @override
  State<BitchatChattingInput> createState() => _BitchatChattingInputState();
}

class _BitchatChattingInputState extends State<BitchatChattingInput> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceBright,
      elevation: 2,
      child: TextFormField(
        controller: _textController,
        decoration: InputDecoration(
          contentPadding: EdgeInsetsDirectional.only(
            start: 16,
            end: 16,
            top: 12,
            bottom: 12,
          ),
          suffixIcon: IconButton(
            style: IconButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              minimumSize: Size.zero,
              fixedSize: Size(8, 8),
              maximumSize: Size(8, 8),
            ),
            onPressed: () async {
              await BitChatInheritedModel.model(
                context,
              ).onSendMessage(_textController.text);
              _textController.text = '';
            },
            icon: Icon(Icons.send, size: 20),
            color: theme.primaryColor,
          ),
        ),
        autofocus: false,
        minLines: 1,
        maxLines: 3,
        keyboardType: TextInputType.multiline,
      ),
    );
  }
}
