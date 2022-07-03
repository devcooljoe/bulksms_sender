import 'package:bulksms/homescreen.dart';
import 'package:bulksms/welcome.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  await GetStorage.init();
  runApp(BulkSMS());
}

class BulkSMS extends StatelessWidget {
  BulkSMS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GetStorage box = GetStorage();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BulkSMS',
      home: box.read('api_token') == null ? const WelcomeScreen() : HomeScreen(),
      theme: ThemeData(primarySwatch: Colors.purple),
    );
  }
}
