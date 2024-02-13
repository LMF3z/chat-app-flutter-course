import 'dart:io';

import 'package:chat_app/widgets/index.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  final List<ChatMessage> _messages = [];

  bool _isWriting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: const Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blueAccent,
              maxRadius: 15,
              child: Text(
                'TE',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              'Meslissa flores',
              style: TextStyle(
                fontSize: 12,
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (_, index) {
                return _messages[index];
              },
              reverse: true,
            ),
          ),
          const Divider(
            height: 1,
          ),
          Container(
            color: Colors.white,
            child: _inputChat(),
          )
        ],
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      _isWriting = true;
                    } else {
                      _isWriting = false;
                    }
                  });
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'Enviar mensaje',
                ),
                focusNode: _focusNode,
              ),
            ),
            Container(
              child: Platform.isIOS
                  ? IconButton(
                      onPressed: _isWriting
                          ? () {
                              _handleSubmit();
                            }
                          : null,
                      icon: const Icon(
                        Icons.send,
                        color: Colors.blueAccent,
                      ),
                    )
                  : IconTheme(
                      data: const IconThemeData(
                        color: Colors.blueAccent,
                      ),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onPressed: _isWriting
                            ? () {
                                _handleSubmit();
                              }
                            : null,
                        icon: const Icon(
                          Icons.send,
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    ChatMessage newMessage = ChatMessage(
      text: _textController.text,
      uuid: '123',
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 300,
        ),
      ),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _isWriting = false;
    });

    _focusNode.requestFocus();
    _textController.clear();
  }

  @override
  void dispose() {
    // TODO: clear socket

    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    super.dispose();
  }
}
