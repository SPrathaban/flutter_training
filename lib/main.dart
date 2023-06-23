import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_training/api/HttpRequestHandler.dart';

Future<void> main() async {
  await dotenv.load(); // default fileName will be .env
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List users = [];
  bool showAddUser = true;
  String backendUrl =
      dotenv.env['BACKEND_URL'] ?? "https://api-dev.kingpin.global";
  int userId = 0;
  String userName = '', password = '';

  Future<void> showUsers() async {
    var response = convertResponse(await getApiRequest('/dschatbox/get-users'));
    setState(() {
      users = response;
      showAddUser = false;
    });
  }

  Future<void> deleteUser(userId) async {
    String url = '/dschatbox/delete-user/$userId';
    var response = convertResponse(await deleteApiRequest(
      url,
    ));
    setState(() {
      users = response;
    });
  }

  void onClickAddUser() {
    setState(() {
      showAddUser = true;
    });
  }

  Future<void> addUser() async {
    String url = '/dschatbox/save-user';
    var response = convertResponse(await postApiRequest(
      url,
      {
        "userId": userId.toString(),
        "userName": userName,
        "password": password,
      },
    ));
    setState(() {
      users = response;
      showAddUser = false;
      userId = 0;
      userName = '';
      password = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: showUsers, child: const Text('Show Users')),
              ElevatedButton(
                  onPressed: onClickAddUser, child: const Text('Add a user')),
            ],
          ),
          if (!showAddUser && users.isNotEmpty)
            Column(
              children: List.generate(
                  users.length,
                  (index) => ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8),
                        children: [
                          ListTile(
                              title: Text(
                                  "UserName - ${users[index]['userName']}  - ${users[index]['userId']}"),
                              leading: const Icon(Icons.person),
                              subtitle: Text(
                                  "Password - ${users[index]['password']}"),
                              trailing: ElevatedButton(
                                  onPressed: () {
                                    deleteUser(users[index]['userId']);
                                  },
                                  child: const Icon(Icons.delete))),
                        ],
                      )),
            ),
          if (showAddUser)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Enter your userId',
                    ),
                    onChanged: (value) {
                      setState(() {
                        userId = int.parse(value);
                      });
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Enter your username',
                    ),
                    onChanged: (value) {
                      setState(() {
                        userName = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Enter your password',
                    ),
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: ElevatedButton(
                        onPressed: () {
                          addUser();
                        },
                        child: const Text('Add User')),
                  ),
                ],
              ),
            )
        ]),
      ),
    );
  }
}
