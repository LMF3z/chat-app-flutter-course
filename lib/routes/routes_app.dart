import 'package:flutter/material.dart';

import 'package:chat_app/screens/index.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  "users": (_) => const UserScreen(),
  "chat": (_) => const ChatScreen(),
  "login": (_) => const LoginScreen(),
  "register": (_) => const RegisterScreen(),
  "loading": (_) => const LoadingScreen(),
};
