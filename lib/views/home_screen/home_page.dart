import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxia/providers/user/user_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        leading: GestureDetector(
          onTap: () async {
            await userProvider.logOutUser();
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: Icon(Icons.logout),
        ),
      ),
    );
  }
}
