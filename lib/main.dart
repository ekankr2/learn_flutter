import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

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
    } else if (status.isDenied) {
      print('거절됨');
      Permission.contacts.request();
    }
  }

  var total = 3;
  var name = ['김영숙', '홍길동', '피자집'];
  var like = [0, 0, 0];

  addOne() {
    setState(() {
      total++;
    });
  }

  addName(String newName) {
    setState(() {
      name.add(newName);
    });
  }

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
                title: Text(name[i]));
          }),
      floatingActionButton: FloatingActionButton(
        child: Text(total.toString()),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return DialogUI(
                  addOne: addOne,
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
  final Function(String) addName;
  var inputData = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 300,
        height: 300,
        child: Column(
          children: [
            TextField(
              controller: inputData,
            ),
            TextButton(
                child: Text('완료'),
                onPressed: () {
                  addName(inputData.text);
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
