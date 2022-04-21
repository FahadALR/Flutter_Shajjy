import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:shajyy/main.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ignore: prefer_const_constructors
          Icon(
            Icons.error,
            color: Color(0XFFA9954D),
            size: 55,
          ),
          SizedBox(
            height: 3,
          ),

          Text(
            'لاتوجد نتيجة',
            style: TextStyle(
                color: Color(0XFFA9954D),
                fontWeight: FontWeight.bold,
                fontSize: 17),
          ),
          SizedBox(
            height: 20,
          ),
          // ignore: prefer_const_constructors
          Text(
            'حاول تشغيل الصوت بشكل واضح وبدون ضوضاء -',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ' قد يكون القارئ الذي تستعلم عنه غير موجود في قاعدةالبيانات -',
                overflow: TextOverflow.clip,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ],
          ),
          SizedBox(
            height: 60,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Color(0XFFA9954D)),
              child: Icon(
                Icons.refresh,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            'حاول مرة أخرى',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
