import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:open_file/open_file.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:url_launcher/url_launcher.dart';

launchWhatsApp() async {
  final link = const WhatsAppUnilink(
    phoneNumber: '+491603265882',
    text:
        "Hey! I just uploaded a file to the Dorm Copy App - kindly let me know when I can come by to pick it up!",
  );
  await launch('$link');
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "dorm _copy project",
    options: const FirebaseOptions(
        apiKey: "AIzaSyCpAqVKGjxmkfA5BEv28uifRrIiIIWAtLw",
        authDomain: "dorm-copy.firebaseapp.com",
        projectId: "dorm-copy",
        storageBucket: "dorm-copy.appspot.com",
        messagingSenderId: "386971079556",
        appId: "1:386971079556:web:e57905f571a514c03283d1"),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dorm Copy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_print_shop_rounded, color: Colors.white, size: 20),
            Text(
              ' Dorm Copy',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final Widget title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) return;

    // Open the single file
    final file = result?.files.first;
    // openFile(file);

    print("Name: ${file!.name}");
    print("Size: ${file.size}");
    print("Extension: ${file.extension}");
    print("Path: ${file.path}");
  }

  Future openFile(PlatformFile? file) async {
    await OpenFile.open(file?.path!);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: widget.title,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Welcome users and explain what the app does
            const Text(
              'Welcome to Dorm Copy!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'You can use this app to print stuff asap.',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            const Text(
              'To get started, select a file that you want to print.',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            const Text(
              'Then, notify/chat with the Dorm Copy Manager to schedule delivery.',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            const Text(
              '(notification via WhatsApp)',
              style: TextStyle(
                fontSize: 10,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ElevatedButton(
                onPressed: () {
                  launchWhatsApp();
                },
                child: const Text('Notify 📲'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await FilePicker.platform.pickFiles();
          if (result != null) return;

          // Open the single file
          final file = result?.files.first;
          // openFile(file);

          print("Name: ${file!.name}");
          print("Size: ${file.size}");
          print("Extension: ${file.extension}");
          print("Path: ${file.path}");
        },
        tooltip: 'Select File',
        icon: const Icon(Icons.upload_rounded),
        label: const Text('Select File'),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
