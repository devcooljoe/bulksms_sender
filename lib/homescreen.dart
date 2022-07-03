import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);
  var _loading = false;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _message = TextEditingController();
  final TextEditingController _phones = TextEditingController();
  final TextEditingController _from = TextEditingController();
  GetStorage box = GetStorage();
  getBalance() async {
    var response = await get(
      Uri.parse("https://www.bulksmsnigeria.com/api/v2/balance/get?api_token=${box.read('api_token')}"),
      headers: {
        'Accept': 'application/json',
      },
    );
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('BulkSMS Sender'),
        actions: [
          Row(
            children: [
              const Text('Balance: ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              FutureBuilder(
                future: getBalance(),
                builder: (context, snapshot) {
                  var data = jsonDecode(snapshot.data.toString());
                  return snapshot.hasData == true ? Text("N${data['balance']['total_balance']}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)) : const Text('Loading...');
                },
              ),
              const SizedBox(width: 10),
            ],
          )
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        shrinkWrap: true,
        children: [
          const SizedBox(height: 50),
          const Text(
            "Welcome to BulkSMS Sender",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text('Sender Name (Required)', style: TextStyle(fontStyle: FontStyle.italic)),
          const SizedBox(height: 5),
          TextField(
            maxLength: 20,
            controller: _from,
            decoration: const InputDecoration(
              hintText: "Enter sender name here...",
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.purple, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text('Text Message (Required)', style: TextStyle(fontStyle: FontStyle.italic)),
          const SizedBox(height: 5),
          TextField(
            maxLength: 160,
            maxLines: 10,
            controller: _message,
            decoration: const InputDecoration(
              hintText: "Enter message here...",
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.purple, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text('Comma separated phone numbers (Required)', style: TextStyle(fontStyle: FontStyle.italic)),
          const SizedBox(height: 5),
          TextField(
            maxLines: 5,
            controller: _phones,
            decoration: const InputDecoration(
              hintText: "Enter comma separated phone numbers here...",
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
            onPressed: () {
              sendMessage();
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: widget._loading
                    ? const SizedBox(
                        height: 25.0,
                        width: 25.0,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const <Widget>[
                          Icon(Icons.send),
                          SizedBox(width: 10),
                          Text('Send Message'),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage() async {
    var link = 'https://www.bulksmsnigeria.com/api/v1/sms/create?api_token=${box.read('api_token')}&from=${_from.text}&to=${_phones.text}&body=${_message.text}&dnd=2';
    if (_from.text != '' && _message.text != '' && _phones.text != '') {
      setState(() {
        widget._loading = true;
      });
      var response = await get(
        Uri.parse(link),
        headers: {
          'Accept': 'application/json',
        },
      );
      setState(() {
        widget._loading = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('SMS Report'),
              content: Column(
                children: [
                  jsonDecode(response.body)['data']['status'] == 'success'
                      ? const Icon(Icons.check_circle_outline_rounded, size: 100, color: Colors.green)
                      : const Icon(
                          Icons.error_outline_rounded,
                          size: 100,
                          color: Colors.red,
                        ),
                  const SizedBox(height: 50),
                  Text("Status: ${jsonDecode(response.body)['data']['status']}"),
                  Text("Message: ${jsonDecode(response.body)['data']['message']}"),
                  Text("Cost: N${jsonDecode(response.body)['data']['cost']}"),
                ],
              ),
            );
          });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Empty fields'),
            content: const Text('All field must be filled!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    }
  }
}
