import 'package:bulksms/homescreen.dart';
import 'package:bulksms/welcome.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  GetStorage.init().then(
    (bool _) => runApp(const BulkSMS()),
  );
}

class BulkSMS extends StatelessWidget {
  const BulkSMS({Key? key}) : super(key: key);

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
