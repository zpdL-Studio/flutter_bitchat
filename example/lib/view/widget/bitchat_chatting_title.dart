import 'package:flutter/material.dart';
import 'package:flutter_bitchat_example/main.dart';

class BitchatChattingTitle extends StatelessWidget {
  const BitchatChattingTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final nickname = BitChatInheritedModel.nickNameOf(context) ?? '';
    return Text('bitchat* $nickname');
  }
}
