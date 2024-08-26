import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'style.dart' as style;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (c) => Store1()),
    ChangeNotifierProvider(create: (c) => Store2())
  ], child: MaterialApp(theme: style.theme, home: MyApp())));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  var data = [];
  var userImage;
  var userContent;

  saveData() async {
    var storage = await SharedPreferences.getInstance();
    storage.setString('name', 'john');
    var result = storage.get('name');
    print(result);
  }

  setUserContent(a) {
    setState(() {
      userContent = a;
    });
  }

  addMyData() {
    var myData = {
      'id': data.length,
      'image': userImage,
      'likes': 5,
      'date': 'July 25',
      'content': userContent,
      'liked': false,
      'user': 'John Kim'
    };
    setState(() {
      data.insert(0, myData);
    });
  }

  addData(newData) {
    setState(() {
      data.add(newData);
    });
  }

  getData() async {
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    if (result.statusCode == 200) {
      var result2 = jsonDecode(result.body);
      setState(() {
        data = result2;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    saveData();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Instagram'),
        actions: [
          IconButton(
            onPressed: () async {
              var picker = ImagePicker();
              var image = await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                setState(() {
                  userImage = File(image.path);
                });
              }

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => Upload(
                            userImage: userImage,
                            setUserContent: setUserContent,
                            addMyData: addMyData,
                          )));
            },
            icon: Icon(Icons.add_box_outlined),
            iconSize: 30,
          )
        ],
      ),
      body: [
        Home(
          data: data,
          addData: addData,
        ),
        Text('샵페이지')
      ][tab],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i) {
          setState(() {
            tab = i;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined), label: '샵')
        ],
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key, this.data, this.addData}) : super(key: key);
  final data;
  final addData;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var scroll = ScrollController();

  getMore() async {
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/more1.json'));

    if (result.statusCode == 200) {
      var resultJson = jsonDecode(result.body);
      print(resultJson);
      widget.addData(resultJson);
    }
  }

  @override
  void initState() {
    super.initState();
    scroll.addListener(() async {
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        getMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty) {
      return ListView.builder(
          itemCount: widget.data.length,
          controller: scroll,
          itemBuilder: (c, i) {
            return Column(
              children: [
                widget.data[i]['image'].runtimeType == String
                    ? Image.network(widget.data[i]['image'])
                    : Image.file(widget.data[i]['image']),
                Container(
                  constraints: BoxConstraints(maxWidth: 600),
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        child: Text(widget.data[i]['user']),
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (c, a1, a2) => Profile(),
                                transitionsBuilder: (c, a1, a2, child) =>
                                    FadeTransition(opacity: a1, child: child)),
                          );
                        },
                      ),
                      Text('좋아요 ${widget.data[i]['likes']}'),
                      Text(widget.data[i]['content']),
                    ],
                  ),
                )
              ],
            );
          });
    }

    return Text('로딩중임');
  }
}

class Upload extends StatelessWidget {
  const Upload({Key? key, this.userImage, this.setUserContent, this.addMyData})
      : super(key: key);
  final userImage;
  final setUserContent;
  final addMyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          IconButton(
              onPressed: () {
                addMyData();
              },
              icon: Icon(Icons.send))
        ]),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(userImage),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close)),
            TextField(onChanged: (text) {
              setUserContent(text);
            })
          ],
        ));
  }
}

class Store2 extends ChangeNotifier {
  var name = 'john kim';
}

class Store1 extends ChangeNotifier {
  var follower = 0;
  var following = false;
  var profileImage = [];

  getData() async {
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/profile.json'));
    var result2 = jsonDecode(result.body);
    profileImage = result2;
    print(profileImage);
    notifyListeners();
  }

  follow() {
    print("1123");
    if (!following) {
      follower += 1;
      following = true;
      return notifyListeners();
    }
    follower -= 1;
    following = false;
    notifyListeners();
  }
}

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.watch<Store2>().name),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
          ),
          Text('팔로워 ${context.watch<Store1>().follower}명'),
          ElevatedButton(
              onPressed: () {
                context.read<Store1>().follow();
              },
              child: Text(context.watch<Store1>().following ? '팔로우중' : '팔로우')),
          ElevatedButton(
              onPressed: () {
                context.read<Store1>().getData();
              },
              child: Text('가져오기'))
        ],
      ),
    );
  }
}
