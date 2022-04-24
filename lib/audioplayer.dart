import 'package:audioplayers/audioplayers.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Audio extends StatefulWidget {
  const Audio({Key? key}) : super(key: key);

  @override
  State<Audio> createState() => _AudioState();
}

class _AudioState extends State<Audio> {
  final audioplayer = AudioPlayer();
  String url2 = 'loading';
  String getaudiofile = 'loading';
  String fid = '';
  bool isLoading = false;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(00);
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  // Future setAudio() async {
  //   audioplayer.setReleaseMode(ReleaseMode.LOOP);
  //   await FirebaseFirestore.instance
  //       .collection('audio')
  //       .where('value', isEqualTo: '1')
  //       .get()
  //       .then((QuerySnapshot snapshot) {
  //     snapshot.docs.forEach((DocumentSnapshot doc) {
  //       var idid = doc.id;
  //       setState(() {
  //         fid = idid;
  //       });
  //     });
  //   }).whenComplete(() async {
  //     var vari =
  //         await FirebaseFirestore.instance.collection('audio').doc(fid).get();
  //     setState(() {
  //       getaudiofile = vari.data()?['audio'];
  //     });
  //   });

  //String url =
  //    'https://firebasestorage.googleapis.com/v0/b/shajyy-522d2.appspot.com/o/chatAudios%2F1650386167606?alt=media&token=ef6b0480-b1cd-45ac-861b-24e6fb8f3c6e';
  //  setState(() {
  //    url2=url;
  //  });
  //   audioplayer.setUrl(getaudiofile);
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    super.initState();
//    setAudio();

    audioplayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.PLAYING;
      });
    });

    audioplayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioplayer.onAudioPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  void dispose() async {
    audioplayer.dispose();
    // await FirebaseFirestore.instance.collection('audio').doc(fid).delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(
              child: SpinKitThreeBounce(
                size: 30,
                color: Color(0XFFA9954D),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Slider(
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds.toDouble(),
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await audioplayer.seek(position);
                      await audioplayer.resume();
                    }),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatTime(position)),
                      Text(formatTime(duration - position)),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (isPlaying) {
                      await audioplayer.pause();
                    } else {
                      await audioplayer.play(getaudiofile);
                      // String url='https://firebasestorage.googleapis.com/v0/b/shajyy-522d2.appspot.com/o/chatAudios%2F1650386627096?alt=media&token=1a9d0d3d-d1c9-4428-9cc0-dce9394ad39e';
                      // await audioplayer.play(url);
                    }
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        color: Colors.black, shape: BoxShape.circle),
                    child: Center(
                      child: isPlaying
                          ? Icon(
                              Icons.pause,
                              color: Colors.white,
                              size: 30,
                            )
                          : Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 30,
                            ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
