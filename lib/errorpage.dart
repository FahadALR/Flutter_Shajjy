import 'dart:io';
import 'package:flutter/cupertino.dart';
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
            color: const Color(0XFFA9954D),
            size: 55,
          ),
          const SizedBox(
            height: 3,
          ),

          const Text(
            'لاتوجد نتيجة',
            style: TextStyle(
                color: Color(0XFFA9954D),
                fontWeight: FontWeight.bold,
                fontSize: 17),
          ),
          const SizedBox(
            height: 20,
          ),
          // ignore: prefer_const_constructors
          Text(
            'حاول تشغيل الصوت بشكل واضح وبدون ضوضاء -',
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                ' قد يكون القارئ الذي تستعلم عنه غير موجود في قاعدةالبيانات -',
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ],
          ),
          const SizedBox(
            height: 60,
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, 'Home', (_) => false);
            },
            child: Container(
              height: 80,
              width: 60,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Color(0XFFA9954D)),
              child: const Icon(
                Icons.refresh,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          const Text(
            'حاول مرة أخرى',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(0XFFA9954D),
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),
        ],
      ),
    );
  }
}
