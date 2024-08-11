import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  getPermission() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      print('허락됨');
      var contacts = await ContactsService.getContacts();
      setState(() {
        name = contacts;
      });

      print(name[2].givenName);
      print(name[2].familyName);

      // var newPerson = Contact();
      // newPerson.givenName = '민수';
      // newPerson.familyName = '김';
      // await ContactsService.addContact(newPerson);

    } else if (status.isDenied) {
      print('거절됨');
      Permission.contacts.request();
    }
  }

  addName(String newGivenName, String newFamilyName) async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      var newPerson = Contact();
      newPerson.givenName = newGivenName;
      newPerson.familyName = newFamilyName;
      await ContactsService.addContact(newPerson);

    } else if (status.isDenied) {
      Permission.contacts.request();
    }
  }

  var name = [];
  var like = [0, 0, 0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: (){getPermission();}, icon: Icon(Icons.contacts))
      ],),
      body: ListView.builder(
          itemCount: name.length,
          itemBuilder: (context, i) {
            return ListTile(
                leading: Image.asset(
                  'assets/profile.jpg',
                  width: 100,
                ),
                title: Text(name[i].givenName ?? '이름이없는놈'));
          }),
      floatingActionButton: FloatingActionButton(
        child: Text('btn'),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return DialogUI(
                  addName: addName,
                );
              });
        },
      ),
    );
  }
}

class DialogUI extends StatelessWidget {
  DialogUI({Key? key, this.addOne, required this.addName}) : super(key: key);
  final addOne;
  final Function(String, String) addName;
  var givenName = TextEditingController();
  var familyName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 300,
        height: 300,
        child: Column(
          children: [
            TextField(
              controller: givenName,

            ),TextField(
              controller: familyName,
            ),
            TextButton(
                child: Text('완료'),
                onPressed: () {
                  addName(givenName.text, familyName.text);
                  Navigator.pop(context);
                }),
            TextButton(
                child: Text('취소'),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}

// /Applications/Android\ Studio.app/Contents/jbr/Contents/Home/bin/keytool -genkey -v -keystore ./upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload