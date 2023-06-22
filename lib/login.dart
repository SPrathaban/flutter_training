import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  String email = 'prathapsubha1@gmail.com';
  String password = 'Litehome@1';
  void onClickLogin() {
    var payload = {'email': email, 'password': password};
    print(payload);
    loginUser(payload);
  }

  Future<void> loginUser(payload) async {
    await dotenv.load(fileName: '.env');
    String BACKEND_URL = dotenv.env['BACKEND_URL'] ?? 'Api urls not found';
    var uri = Uri.https(BACKEND_URL, '/login');
    print(uri);
    var result = await http.post(uri, body: payload);
    var resultJson = jsonDecode(utf8.decode(result.bodyBytes));
    print(resultJson['data']);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
          height: 50,
          width: 200,
          child: TextFormField(
            onChanged: (value) {
              setState(() {
                email = value;
              });
            },
          )),
      SizedBox(
          height: 50,
          width: 200,
          child: TextFormField(
            onChanged: (value) {
              setState(() {
                password = value;
              });
            },
          )),
      SizedBox(
        height: 50,
        width: 200,
        // style: authButtonStyle(Colors.black, Colors.blue),
        child: TextButton(
            onPressed: () {
              onClickLogin();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[200]),
            child: Text("Login")),
      )
    ]);
  }
}

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_training/login.dart';
// import 'package:http/http.dart' as http;

// Future<void> main() async {
//   await dotenv.load(fileName: '.env');
//   runApp(const MyApp());
// }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Flutter Demo',
// //       theme: ThemeData(
// //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
// //         useMaterial3: true,
// //       ),
// //       home: const MyHomePage(title: 'Flutter Demo Home Page'),
// //     );
// //   }
// // }

// // class MyHomePage extends StatefulWidget {
// //   const MyHomePage({super.key, required this.title});
// //   final String title;
// //   @override
// //   State<MyHomePage> createState() => _MyHomePageState();
// // }

// // class _MyHomePageState extends State<MyHomePage> {
// //   String BACKEND_URL = dotenv.env['BACKEND_URL'] ?? 'Api urls not found';

// //   Future<void> _incrementCounter() async {
// //     var result = await fetchRequest();
// //     var resultJson = jsonDecode(utf8.decode(result.bodyBytes));
// //     print(resultJson['data']['COUNTRIES']);
// //   }

// //   Future<http.Response> fetchRequest() async {
// //     var uri = Uri.https(BACKEND_URL, '/common');
// //     return await http.get(uri);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
// //         title: Text(widget.title),
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           // children: <Widget>[
// //           //   const Text(
// //           //     'You have pushed the button this many times: Hello',
// //           //   ),
// //           //   Text(
// //           //     dotenv.env['BACKEND_URL'] ?? 'Api urls not found',
// //           //     style: Theme.of(context).textTheme.headlineMedium,
// //           //   ),
// //           // ],
// //           children: [Login()],
// //         ),
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: _incrementCounter,
// //         tooltip: 'Increment',
// //         child: const Icon(Icons.add),
// //       ),
// //     );
// //   }
// // }
