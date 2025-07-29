import 'package:flutter/material.dart';
import 'package:flutter_bitchat_example/view/widget/bitchat_chatting_messages.dart';
import 'package:flutter_bitchat_example/view/widget/bitchat_chatting_title.dart';

class BitchatChattingView extends StatelessWidget {
  const BitchatChattingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const BitchatChattingTitle()),
      body: SafeArea(
        child: Stack(
          children: [
            BitchatChattingMessages(
              padding: EdgeInsetsDirectional.only(
                start: 16,
                end: 16,
                bottom: 80,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
