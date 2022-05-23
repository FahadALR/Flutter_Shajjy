// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
//import 'package:flutter_sound/flutter_sound.dart' as rec;
import 'package:flutter_sound_lite/flutter_sound.dart' as rec;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shajyy/audioplayer.dart';
import 'package:shajyy/errorpage.dart'; //ERROR PAGE
import 'package:shajyy/new.dart'; //ANSWER PAGE
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: MyApp(),
    routes: {
      'Home': (context) => MyApp(),
      'error': (context) => ErrorPage(),
    },
    title: 'Shajyy',
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  //const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // initial values

  bool isListening = false;
  bool isLoading = false;
  final recorder = rec.FlutterSoundRecorder();
  bool isRecorderReady = false;
  late String outputFile;

  String name0 = 'loading';
  String name1 = 'loading';
  String name2 = 'loading';
  String url0 = 'loading';
  String url1 = 'loading';
  String url2 = 'loading';

  TextEditingController controller = TextEditingController();
  int seconds = 14; //For the timer
  bool timerSt = false;
  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) async {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });

        if (seconds == 10) {
          if (recorder.isRecording) stop();
          if (!recorder.isRecording) await record();
        }
        if (seconds == 6 && (name0 == 'none' || name0 == 'loading')) {
          stop();
          if (recorder.isRecording) stop();
          if (!recorder.isRecording) await record();
        }
        if (seconds == 2 && (name0 == 'none' || name0 == 'loading')) {
          stop();
          if (recorder.isRecording) stop();
          if (!recorder.isRecording) await record();
        }
      } else {
        setState(() {
          isListening = !isListening;
        });
        timer?.cancel();
        if (recorder.isRecording) stop2();
        Navigator.pushNamed(context, 'error');
        seconds = 14;
      }
    });
  }

  Future record() async {
    if (!isRecorderReady) return;
    Directory tempDir = await getTemporaryDirectory();
    outputFile = '${tempDir.path}/myFile.wav';
    print('------------------------------ $outputFile');
    await recorder.startRecorder(
      toFile: outputFile,
      codec: rec.Codec.pcm16WAV,
      sampleRate: 22050,
      numChannels: 1,
    );
  }

  Future stop() async {
    if (!isRecorderReady) return;

    var path = await recorder.stopRecorder();
    print('Recorder Audio: $path');
    final audioFiles = File(outputFile);
    print('Recorder Audio: $audioFiles');
    uploadAudioToAPI(audioFiles);
  }

  Future stop2() async {
    if (!isRecorderReady) return;
    final path = await recorder.stopRecorder();
    print('The Audio is stopped: $path');
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }

    await recorder.openAudioSession();
    isRecorderReady = true;
    recorder.setSubscriptionDuration(Duration(milliseconds: 300));
  }

  Future uploadAudioToAPI(File audioFile) async {
    final url = Uri.http("10.0.2.2:8000", "predict");
    final request = http.MultipartRequest('POST', url);

    var audio = await (http.MultipartFile.fromPath('file', audioFile.path,
        filename: 'myFile.wav', contentType: new MediaType('audio', 'wav')));
    request.files.add(audio);

    request.headers.addAll({"content": "multipart/form-data"});
    print(url);
    print(audio.contentType);

    http.Response response =
        await http.Response.fromStream(await request.send());
    if (response.statusCode == 200) {
      var temp = jsonDecode(response.body)['prediction'];

      if ((temp == 'none') && seconds < 3) {
        Navigator.pushNamed(context, 'error');
        setState(() {});
        stop2();
        isLoading = false;
        timer?.cancel();
      } else {
        List<String>? tags = temp != null ? List.from(temp) : null;
        await FirebaseFirestore.instance
            .collection('Data')
            .where("data no ", isEqualTo: temp[0])
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            name0 = doc["name"];
            url0 = doc["url"];
          });
        });
        await FirebaseFirestore.instance
            .collection('Data')
            .where("data no ", isEqualTo: temp[1])
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            name1 = doc["name"];
            url1 = doc["url"];
          });
        });
        await FirebaseFirestore.instance
            .collection('Data')
            .where("data no ", isEqualTo: temp[2])
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            name2 = doc["name"];
            url2 = doc["url"];

            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => New(
                      name0: name0,
                      name1: name1,
                      name2: name2,
                      url0: url0,
                      url1: url1,
                      url2: url2,
                    )));
          });
        });
      }
    }
  }

  Future uploadAsset(File audioFile) async {
    final url = Uri.http("10.0.2.2:8000", "predict");
    var request = http.MultipartRequest('POST', url);

    var audio = http.MultipartFile.fromBytes('file',
        (await rootBundle.load("assets/justTest.wav")).buffer.asInt8List(),
        filename: 'test.wav', contentType: new MediaType('audio', 'wav'));
    setState(() {
      isLoading = true;
    });
    request.files.add(audio);
    request.headers.addAll({"content": "multipart/form-data"});
    print(url);
    http.Response response =
        await http.Response.fromStream(await request.send());
    // setState(() {
    //   isLoading = true;
    // });
    var temp = jsonDecode(response.body)['prediction'];
    List<String>? tags = temp != null ? List.from(temp) : null;
    if (response.statusCode == 200) {
      print(">> " + tags![0]);
      print('The result from the model is ${response.body}');
      print(' The suggested IDs of the reciters:- ${temp}');
      print(' The id of the main reciter:-- ${temp[0]}');

      await FirebaseFirestore.instance
          .collection('Data')
          .where("data no ", isEqualTo: temp[0])
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          name0 = doc["name"];
          url0 = doc["url"];
        });
      });
      await FirebaseFirestore.instance
          .collection('Data')
          .where("data no ", isEqualTo: temp[1])
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          name1 = doc["name"];
          url1 = doc["url"];
        });
      });
      await FirebaseFirestore.instance
          .collection('Data')
          .where("data no ", isEqualTo: temp[2])
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          name2 = doc["name"];
          url2 = doc["url"];
        });
      });
      if (identical(name0, 'none')) {
        Navigator.pushNamed(context, 'error');
      }
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => New(
                name0: name0,
                name1: name1,
                name2: name2,
                url0: url0,
                url1: url1,
                url2: url2,
              )));
    }
  }

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    recorder.closeAudioSession();
    super.dispose();
  }

  // This is function when we press the recorder button it will start

  // Automatically stop recording

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body:
          isLoading // if screen is on loading process then this column will be display
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: SpinKitThreeBounce(
                      color: Color(0XFFA9954D),
                      size: 30,
                    )),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${controller.text}',
                          style: TextStyle(
                              color: Color(0XFFA9954D),
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'الرجاء الانتظار',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                )
              : Stack(children: [
                  // if loading screen is not on loading process then this screen will be display
                  WaveWidget(
                    waveFrequency: 1.6,
                    isLoop: true,
                    config: CustomConfig(gradients: [
                      [
                        Color(0XFFA9954D).withOpacity(0.6),
                        Color(0XFFA9954D).withOpacity(0.6)
                      ],
                      [
                        Color(0XFFA9954D).withOpacity(0.4),
                        Color(0XFFA9954D).withOpacity(0.4)
                      ],
                      [
                        Color(0XFFA9954D).withOpacity(0.2),
                        Color(0XFFA9954D).withOpacity(0.2)
                      ],
                    ], durations: [
                      5000,
                      4000,
                      4500
                    ], heightPercentages: [
                      0.8,
                      0.77,
                      0.73
                    ]),
                    size: Size(double.infinity, double.infinity),
                  ),
                  ClipPath(
                    // this clippath id for decoraation
                    clipper: WaveClipperOne(),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2.5,
                      child: Center(
                        child: Stack(children: [
                          ClipPath(
                            clipper: WaveClipper4(),
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                Colors.white.withOpacity(0.4),
                                Colors.grey.withOpacity(0.1)
                              ])),
                            ),
                          ),
                          ClipPath(
                            // this clippath id for decoraation
                            clipper: WaveClipper6(),
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                Colors.white,
                                Colors.grey.withOpacity(0.1)
                              ])),
                            ),
                          ),
                          ClipPath(
                            // this clippath id for decoraation
                            clipper: WaveClipper3(),
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                Colors.white,
                                Colors.grey.withOpacity(0.1)
                              ])),
                            ),
                          ),
                          ClipPath(
                            // this clippath id for decoraation
                            clipper: WaveClipper2(),
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                Colors.white.withOpacity(0.2),
                                Colors.grey.withOpacity(0.1)
                              ])),
                            ),
                          ),
                          Center(
                            child: Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width / 1.5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Color(0XFFD4DD9C),
                                        spreadRadius: 5,
                                        blurRadius: 10)
                                  ],
                                  color: Color(0XFFD4DD9C)),
                              child: Center(
                                child:
                                    isListening // if screen is in recording process then this text will be display
                                        ? Text(
                                            'جاري التسجيل',
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Text(
                                            'إضغط هنا لبدأ التسجيل', // if screen is not in recording process then this text will be display
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: const [
                            Color(0XFFA9954D),
                            Color(0XFFA9954D)
                          ])),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: ()
                                // async {
                                //   uploadAsset(File('assets/justTest.wav'));
                                // },

                                async {
                              setState(() {
                                isListening = !isListening;
                              });

                              if (isListening) {
                                startTimer();
                              } else {
                                timer?.cancel();
                                seconds = 14;
                                stop2();
                              }
                              if (recorder.isRecording) {
                                await stop2();
                              } else {
                                await record();
                              }
                              setState(() {});
                            },
                            child: AvatarGlow(
                              endRadius: 120,
                              glowColor: isListening
                                  ? Colors.black
                                  : Colors.grey.shade200,
                              child: Container(
                                height: MediaQuery.of(context).size.height / 3,
                                width: MediaQuery.of(context).size.width / 3,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      !isListening ? Colors.blue : Colors.red,
                                ),
                                child: Center(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height /
                                        3.5,
                                    width:
                                        MediaQuery.of(context).size.width / 3.5,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        isListening
                                            ? Icon(Icons.stop,
                                                color: Colors.red, size: 35)
                                            : Icon(Icons.mic,
                                                color: Colors.blue, size: 35),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        !isListening
                                            ? Text('البداية',
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold))
                                            : Text('قف',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      isListening
                          ? Text(
                              'اقترب من مصدر الصوت',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            )
                          : Text('')
                    ],
                  ),

                  !isListening
                      ? Container()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 280),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    seconds.toString(),
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 45,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                ]),
    );
  }
}

class WaveClipper4 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addOval(
        Rect.fromCircle(center: Offset(size.width / 5, 0), radius: 100));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class WaveClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addOval(Rect.fromCircle(
        center: Offset(size.width / 1.5, size.height / 1.3), radius: 30));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addOval(Rect.fromCircle(
        center: Offset(size.width / 10, size.height / 1.1), radius: 70));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class WaveClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addOval(Rect.fromCircle(
        center: Offset(size.width / 1.47, size.height / 3.5), radius: 30));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class WaveClipper6 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addOval(Rect.fromCircle(center: Offset(size.width, 50), radius: 100));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class WaveClipper5 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addOval(
        Rect.fromCircle(center: Offset(size.width / 2, 50), radius: 20));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
