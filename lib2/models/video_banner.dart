import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class VideoBanner extends StatelessWidget {
  final File _videoFile;

  VideoBanner(this._videoFile);

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxHeight: 200.0),
        decoration: BoxDecoration(color: Colors.transparent),
        padding: EdgeInsets.all(5.0),
        child: VideoPlayerScreen(videoFile: _videoFile)
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  File videoFile;

  VideoPlayerScreen({Key key, @required this.videoFile}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.file(
      widget.videoFile
    )..initialize().then((_) {
      setState(() {});
    });

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the video.
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // Use the VideoPlayer widget to display the video.
              child: Column(

                children:
                  [VideoPlayer(_controller),
                    RaisedButton.icon(
                        onPressed: (){
                          // Wrap the play or pause in a call to `setState`. This ensures the
                          // correct icon is shown.
                          setState(() {
                            // If the video is playing, pause it.
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                            } else {
                              // If the video is paused, play it.
                              _controller.play();
                            }
                          });
                        },
                        icon: _controller.value.isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                        label: Text(''),
                    )
                  ]));
          }
          else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
                return Center(child: CircularProgressIndicator());
          }
        },
      );

  }
}