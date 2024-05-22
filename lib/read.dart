import 'package:flutter/material.dart';
import 'package:todoo_app/auth/models/User.dart';
import 'package:todoo_app/core/database/LoginOperation.dart';

class ReadPage extends StatefulWidget {
  const ReadPage({super.key});

  @override
  _ReadPageState createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  final Loginoperation loginCtr = Loginoperation();
  List<User> userList = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    List<User> users = await loginCtr.getAllUsers();
    setState(() {
      userList = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
      ),
      body: userList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(userList[index].email),
                  subtitle: Text(userList[index].password),
                );
              },
            ),
    );
  }
}
