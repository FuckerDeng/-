import "package:flutter/material.dart";
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:fijkplayer/fijkplayer.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';


class FindBookPage extends StatefulWidget{

  @override
  State createState() {
    // TODO: implement createState
    return new _FindBookPage();
  }


}

class _FindBookPage extends State<FindBookPage> {
  static final VideoPlayerController videoPlayerController = VideoPlayerController.network(
//    "http://47.93.0.72:8080/study/720P_1500K_217010182.mp4"
  "http://47.93.0.72:8080/study/mv.mp4"
  );

  static final ChewieController chewieController = new ChewieController(
    videoPlayerController: videoPlayerController,
    aspectRatio: 1,
    autoPlay: false,
    looping: true
  );

   Chewie chewie = new Chewie(
    controller: chewieController,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  void dispose() {
    // TODO: implement dispose

    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new Center(
        child: chewie,
      ),
    );
  }
}