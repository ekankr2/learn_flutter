import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: SizedBox(
      child: Row(
        children: [
          SizedBox(
            child: Image.asset(
              'assets/dog.jpg',
              fit: BoxFit.fill,
            ),
            width: 250,
            height: 250,
          ),
          Column(
            children: [
              Text('웨르시 코르기'),
              Text('끌올 10분 전', style: TextStyle(color: Colors.grey),),
              Text('제목'),
              SizedBox(
                child: Row(
                  children: [
                    Text('홍길동'),
                    Row(children: [
                      Icon(Icons.heart_broken),
                      Text('4')
                    ],)
                  ],
                ),
              )
            ],
          )
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    )));
  }
}
