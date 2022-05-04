import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:shajyy/main.dart';

class New extends StatefulWidget {
  // ignore: non_constant_identifier_names

  String url0, url1, url2, name0, name1, name2;
  New({
    required this.name0,
    required this.name1,
    required this.name2,
    required this.url0,
    required this.url1,
    required this.url2,
  });

  @override
  State<New> createState() => _NewState();
}

class _NewState extends State<New> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(children: [
          ClipPath(
            // this clippath id for decoration
            clipper: OvalBottomBorderClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color(0XFFA9954D),
                Color(0XFFA9954D).withOpacity(0.9)
              ])),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (Platform.isAndroid)
                IconButton(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.fromLTRB(370, 14.5, 0, 0),
                  iconSize: 40,
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Color(0XFF413420),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, 'Home', (_) => false);
                  },
                ),
              if (Platform.isIOS)
                IconButton(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.fromLTRB(375, 17.5, 0, 0),
                  iconSize: 40,
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0XFF413420),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, 'Home', (_) => false);
                  },
                ),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width / 1.5,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      // Here when we connect the fastAPI i will remove this http from here and uncomment the widget.url
                      // 'https://i1.sndcdn.com/artworks-000207412380-slycmh-t500x500.jpg',
                      widget.url0,
                      fit: BoxFit.cover,
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width / 1.5,
                decoration: BoxDecoration(
                    color: Color(0XFFD4DD9C),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade400,
                          blurRadius: 4,
                          spreadRadius: 3,
                          offset: Offset(3, 3))
                    ]),
                child: Center(
                  child: Text(
                    //'عبدالرحمن العوسي',
                    widget.name0,
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width / 2.5,
                  decoration: BoxDecoration(
                      color: Color(0XFFD4DD9C),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      'القراء المشابهين',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.grey.shade800),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width / 2.5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade200),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                // Here also when we connect the fastAPI i will remove this http from here and uncomment the widget.url
                                //'https://www.alwatan.com.sa/uploads/images/2019/05/25/319187.jpg',
                                widget.url1,
                                fit: BoxFit.cover,
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 2.5,
                          decoration: BoxDecoration(
                              color: Color(0XFFD4DD9C),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Text(
                            //'ٔحمد الطرابلسي',
                            widget.name1,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          )),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width / 2.5,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade200),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  widget.url2,
                                  fit: BoxFit.cover,
                                ))),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 2.5,
                          decoration: BoxDecoration(
                              color: Color(0XFFD4DD9C),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Text(
                            widget.name2,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          )),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}

class WaveClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addOval(
        Rect.fromCircle(center: Offset(size.width / 2, 0), radius: 400));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
