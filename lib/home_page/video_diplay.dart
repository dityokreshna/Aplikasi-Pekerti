import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class ChewieListItem extends StatefulWidget {
  // final VideoPlayerController videoPlayerController;
  // final bool looping;
  final String namaCCTV;
  final String deskripsiCCTV;
  final String urlCCTV;

  ChewieListItem({
    // @required this.videoPlayerController,
    //  this.looping,
    this.namaCCTV,
    this.deskripsiCCTV, 
    this.urlCCTV,
  }) ;

  @override
  _ChewieListItemState createState() => _ChewieListItemState();
}

class _ChewieListItemState extends State<ChewieListItem> {
  VlcPlayerController vlcController;
  @override
  void initState() {
    super.initState();
    vlcController = new VlcPlayerController(onInit: () {
      vlcController.play();
    });
    // _chewieController = ChewieController(
    //   videoPlayerController: widget.videoPlayerController,
    //   aspectRatio: 16 / 9,
    //   autoInitialize: true,
    //   errorBuilder: (context, errorMessage) {
    //     return Center(
    //       child: Text(
    //         errorMessage,
    //         style: TextStyle(color: Colors.white),
    //       ),
    //     );
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Card(
          elevation: 20,
          child: Column(
            children: <Widget>[
              VlcPlayer(
                  controller: vlcController,
                  aspectRatio: 5 / 4.1,
                  url: widget.urlCCTV,
                  placeholder: Center(child: CircularProgressIndicator()),
                  ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.namaCCTV,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.deskripsiCCTV),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // widget.videoPlayerController.dispose();

    vlcController.dispose();
  }
}
