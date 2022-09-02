import 'package:bulksms/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _apiToken = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Welcome to BulkSMS Sender",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _apiToken,
              decoration: const InputDecoration(
                hintText: "Enter your API Key here",
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purple, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.purple),
              ),
              onPressed: saveApiToken,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const <Widget>[
                      Icon(Icons.save),
                      Text('Save'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void saveApiToken() {
    GetStorage box = GetStorage();
    box.write('api_token', _apiToken.text);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return HomeScreen();
      }),
    );
  }
}
