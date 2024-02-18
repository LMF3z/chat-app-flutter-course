import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_app/services/index.dart';
import 'package:chat_app/models/index.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final usersService = UsersService();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<UserModel> usersList = [];

  @override
  void initState() {
    super.initState();

    _chargeUsers();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.userAuth;
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(user!.name!),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            socketService.disconnect();
            AuthService.deleteToken();
            Navigator.pushReplacementNamed(context, 'login');
          },
          icon: const Icon(Icons.exit_to_app_sharp),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.Online
                ? const Icon(
                    Icons.check_circle,
                    color: Colors.blueAccent,
                  )
                : const Icon(
                    Icons.offline_bolt,
                    color: Colors.redAccent,
                  ),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _chargeUsers,
        header: WaterDropHeader(
          complete: Icon(
            Icons.check,
            color: Colors.blue[400],
          ),
          waterDropColor: Colors.blue,
        ),
        child: _listViewUsers(),
      ),
    );
  }

  ListView _listViewUsers() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: usersList.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (_, index) {
        final user = usersList[index];
        return _usersListTile(user);
      },
    );
  }

  ListTile _usersListTile(UserModel user) {
    return ListTile(
      title: Text(user.name!),
      subtitle: Text(user.email!),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(
          user.name!.substring(0, 2),
        ),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: user.online! ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.userTo = user;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  _chargeUsers() async {
    final users = await usersService.getUsers();
    setState(() {
      usersList = users;
    });
    return _refreshController.refreshCompleted();
  }
}
