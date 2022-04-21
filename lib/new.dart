import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:shajyy/main.dart';

class New extends StatefulWidget {
  // ignore: non_constant_identifier_names
  String Arabicname, url, Englishname, id;
  New({
    required this.id,
    required this.url,
    required this.Englishname,
    required this.Arabicname,
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
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          // Here when we connect the fastAPI i will remove this http from here and uncomment the widget.url
                          'https://i1.sndcdn.com/artworks-000207412380-slycmh-t500x500.jpg',
                          //widget.url,
                          fit: BoxFit.cover,
                        )),
                  ),
                ],
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
                    'عبدالرحمن العوسي',
                    // widget.Arabicname,
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Accuracy Rate : 85% ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0XFFA9954D),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'القراء المقترحين',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey.shade800),
                    ),
                  ],
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
                                'https://www.alwatan.com.sa/uploads/images/2019/05/25/319187.jpg',
                                //widget.url,
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
                            'ٔحمد الطرابلسي',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          )),
                        ),
                        Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width / 2.5,
                          decoration: BoxDecoration(),
                          child: Center(
                              child: Text(
                            'Accuracy Rate : 35 %',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0XFFA9954D),
                            ),
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
                                  'https://i1.sndcdn.com/artworks-989Z8BJKL2lKwOla-t8jhzA-t500x500.jpg',
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
                            'احمد الحذيفي',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          )),
                        ),
                        Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width / 2.5,
                          decoration: BoxDecoration(),
                          child: Center(
                              child: Text(
                            'Accuracy Rate : 65 %',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0XFFA9954D),
                            ),
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
