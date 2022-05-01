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
import 'package:flutter_sound/flutter_sound.dart' as rec;
//import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shajyy/audioplayer.dart';
import 'package:shajyy/errorpage.dart';
import 'package:shajyy/new.dart';
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
    title: 'Shajyy',
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // initial values
  Timer? timer;
  String fid = '';
  String arabicname = 'loading';
  String englishname = 'loading';
  String pageUrl = 'loading';
  String? text;
  bool isListening = false;
  bool isLoading = false;
  bool timerSt = false;

  // This controller is for handle the voice which we say
  TextEditingController controller = TextEditingController();

  final recorder = rec.FlutterSoundRecorder();
  bool isRecorderReady = false;
  int seconds = 10;
  void sendMethod() async {
    if (recorder.isRecording) {
      await stop();
    } else {
      await record();
    }
    setState(() {});
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) async {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
        if (seconds == 6) {
          if (recorder.isRecording) stop();
          if (!recorder.isRecording) await record();
          print('This is the 6');
        }
        // if (seconds == 2) {
        //   stop();
        //   // if (recorder.isRecording) stop();
        //   //if (!recorder.isRecording) await record();
        //   print('This is the 2');
        // }
      } else {
        setState(() {
          isListening = !isListening;
        });
        timer?.cancel();
        if (recorder.isRecording) stop2();
        print('This is the ZERO');
        seconds = 10;
      }
    });
  }

  Future record() async {
    if (!isRecorderReady) return;
    var tempDir = await getTemporaryDirectory();
    String path = '${tempDir.path}/audio.aac';
    await recorder.startRecorder(
      toFile: path,
      //  codec: rec.Codec.pcm16WAV,
    );
  }

  Future stop() async {
    if (!isRecorderReady) return;
    final path = await recorder.stopRecorder();
    final audioFiles = File(path!);
    print('Recorder Audio: $audioFiles');
    uploadAudioToAPI(audioFiles);
  }

  Future stop2() async {
    if (!isRecorderReady) return;
    final path = await recorder.stopRecorder();
    print('The Audio is stopped: ');
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
    await recorder.openRecorder();
    isRecorderReady = true;
    recorder.setSubscriptionDuration(Duration(milliseconds: 300));
  }

  Future uploadAudioToAPI(File audioFile) async {
    final url = Uri.http("10.0.2.2:8000", "predict");
    var request = http.MultipartRequest('POST', url);
    var audio = await (http.MultipartFile.fromPath("file", audioFile.path,
        contentType: new MediaType('audio', 'wav'), filename: 'test.wav'));
    request.files.add(audio);
    // request.files.add(await http.MultipartFile.fromPath("file", audioFile.path,
    //     contentType: new MediaType('audio', 'wav'), filename: 'test.wav'));
    request.headers.addAll({"content": "multipart/form-data"});
    print(url);
    print(audio.contentType);
    http.Response response =
        await http.Response.fromStream(await request.send());
    if (response.statusCode == 200) {
      print(
          'Uploaded! ${audio.filename}  ////${audio.length}//// ${response.body}');
    }
    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => New(
    //         id: fid,
    //         url: pageUrl,
    //         englishname: englishname,
    //         arabicname: arabicname)));
  }

  Future uploadAsset(File audioFile) async {
    final url = Uri.http("10.0.2.2:8000", "predict");
    var request = http.MultipartRequest('POST', url);
    var audio = http.MultipartFile.fromBytes('file',
        (await rootBundle.load("assets/justTest.wav")).buffer.asInt8List(),
        filename: 'test.wav', contentType: new MediaType('audio', 'wav'));
    request.files.add(audio);
    request.headers.addAll({"content": "multipart/form-data"});
    print(url);
    http.Response response =
        await http.Response.fromStream(await request.send());
    var temp = jsonDecode(response.body)['prediction'];
    List<String>? tags = temp != null ? List.from(temp) : null;
    if (response.statusCode == 200) {
      print(">> " + tags![0]);
      print(' //////// ${audio.contentType}');
    }
    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => New(
    //         id: fid,
    //         url: pageUrl,
    //         englishname: englishname,
    //         arabicname: arabicname)));
  }

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
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
                          'ارجوك انتظر',
                          style: TextStyle(fontSize: 17),
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
                                  boxShadow: [
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
                              colors: [Color(0XFFA9954D), Color(0XFFA9954D)])),
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
                                //  uploadAsset(File('assets/justTest.wav'));
                                // },
                                async {
                              setState(() {
                                isListening = !isListening;
                              });

                              if (isListening)
                                startTimer();
                              else {
                                timer?.cancel();
                                seconds = 10;
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

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => New(
                                        id: fid,
                                        url: pageUrl,
                                        englishname: englishname,
                                        arabicname: arabicname)));
                              },
                              child: Container(
                                height: 50,
                                width: 100,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    'Only for testing go to answer page(click this)',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Audio()));
                              },
                              child: Container(
                                height: 50,
                                width: 100,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    'Only for testing go to audio page(click here)',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
