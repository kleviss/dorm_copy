import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
// import firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:url_launcher/url_launcher.dart';

launchWhatsApp() async {
  print("launchWhatsApp");
  const link = WhatsAppUnilink(
    phoneNumber: '+491603265882',
    text:
        "Hey! I just uploaded a file with name {enter file name here/or send me a screenshot} to the Dorm Copy App - kindly let me know when I can come by to pick it up!",
  );
  await launch('$link');
}

class FilesPage extends StatefulWidget {
  final List<PlatformFile> files;
  final ValueChanged<PlatformFile> onOpenFile;

  const FilesPage({
    Key? key,
    required this.files,
    required this.onOpenFile,
  }) : super(key: key);

  @override
  _FilesPageState createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  PlatformFile? pickedFile;

  Future uploadFile(PlatformFile bile) async {
    if (kIsWeb) {
      print("Web");
      // upload platform file from web to firebase storage by converting bytes

      Reference _reference =
          _firebaseStorage.ref().child('files/${Path.basename(bile!.path)}');
      await _reference
          .putData(
        await pickedFile!.readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      )
          .whenComplete(() async {
        await _reference.getDownloadURL().then((value) {
          uploadedPhotoUrl = value;
        });
      });

      print("Web1");
    } else {
      final path = 'files/${bile!.name}';
      final file = File(bile!.path!);
      if (file == null) return;

      final storage = FirebaseStorage.instance;
      final ref = storage.ref().child(path);
      final task = ref.putFile(File(bile.path!));

      final snapshot = await task;
      final url = await snapshot.ref.getDownloadURL();
      print("Download URL: $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Files'),
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: widget.files.length,
            itemBuilder: (context, index) {
              final file = widget.files[index];
              return ListTile(
                title: Text(file.name),
                subtitle: Text('${file.size} bytes'),
                onTap: () => widget.onOpenFile(file),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(11, 11, 17, 73),
              child: ElevatedButton(
                onPressed: () {
                  launchWhatsApp();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                child: const Text('Notify Dorm Manager 📲'),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => uploadFile(widget.files.first),
        tooltip: 'Upload Files to firebase storage',
        label: const Text('Upload Selected File(s)'),
        icon: const Icon(Icons.upload_file),
      ),
    );
  }
}
