import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/index.dart';
import 'package:chat_app/widgets/index.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  ChatService? chatService;
  SocketService? socketService;
  AuthService? authService;

  final List<ChatMessage> _messages = [];

  bool _isWriting = false;

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService!.socket.on('personal-message', _listenMessage);

    _chargeHistory(chatService!.userTo!.uuid!);
  }

  void _listenMessage(dynamic payload) {
    ChatMessage newMessage = ChatMessage(
      text: payload['message'],
      uuid: payload['from'],
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 300,
        ),
      ),
    );

    setState(() {
      _messages.insert(0, newMessage);
    });

    newMessage.animationController.forward();
  }

  void _chargeHistory(String userId) async {
    final res = await chatService!.getMessagesChat(userId);
    final history = res.map(
      (msg) => ChatMessage(
        text: msg.message,
        uuid: msg.from,
        animationController: AnimationController(
          vsync: this,
          duration: const Duration(
            milliseconds: 0,
          ),
        )..forward(),
      ),
    );

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userTo = chatService!.userTo!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blueAccent,
              maxRadius: 15,
              child: Text(
                userTo.name!.substring(0, 2),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              userTo.name!,
              style: const TextStyle(
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
      uuid: authService!.userAuth!.uuid!,
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

    socketService?.emit('personal-message', {
      "from": authService!.userAuth!.uuid,
      "to": chatService!.userTo!.uuid,
      "message": _textController.text,
    });

    _focusNode.requestFocus();
    _textController.clear();
  }

  @override
  void dispose() {
    final chats = ChatService();
    chats.userTo = null;
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    socketService!.socket.off('personal-message');
    super.dispose();
  }
}
