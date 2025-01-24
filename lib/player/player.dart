import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:v1/main.dart';
import 'package:v1/player/album.dart';
import 'package:v1/shelf/shelf.dart';
import 'package:v1/ui/design/theme.dart';


class RecordPlayer extends StatefulWidget {
  RecordPlayer({super.key});
  
  static const double height = 288;
  
  final player = AudioPlayer();
  Album? album;
  double speed = 1;
  int songIndex = 0;
  
  void setAlbum(Album? a, [BuildContext? context]) {
    album = a;
    play(-songIndex);
    if (context != null) {
      Shelf.setState(context);
    }
  }
  
  void play(int d) {
    player.stop();
    if (album != null) {
      songIndex += d;
      if (songIndex < 0 || songIndex >= album!.songs.length) {
        songIndex = 0;
      }
      player.play(DeviceFileSource(album!.songs[songIndex].path));
    }
  }

  @override
  State<RecordPlayer> createState() => _RecordPlayerState();
}

class _RecordPlayerState extends State<RecordPlayer> {
  
  late Timer _timer;
  final int _turnTime = 60_000 / ( 100 / 3 ) ~/ 100;
  double _turns = 0;
  
  @override
  initState() {
    super.initState();
    
    widget.player.onPlayerStateChanged.listen((state) async {
      switch (state) {
        case PlayerState.completed: {
          widget.play(1);
          if (widget.songIndex == 0) {
            widget.player.pause();
          }
          break;
        }
        default: break;
      }
      try {
        setState(() {});
      } finally {}
    });
    
    // 100/3/min
    _timer = Timer.periodic(Duration(milliseconds: _turnTime), (timer) {
      if (widget.player.state == PlayerState.playing) {
        //debugPrint(_turnTime.toString());
        setState(() => _turns += 1/3/100);
      }
    });
  }
  
  @override
  void dispose() async {
    //widget.setAlbum(null);
    //await widget.player.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(40),
        color: Surfaces.darkWood,
        child: Container(
          width: 192 + 2 * 48,
          padding: EdgeInsets.all(16),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      top: 16,
                      bottom: 32,
                    ),
                    child: AnimatedRotation(
                      duration: Duration(milliseconds: _turnTime),
                      turns: _turns,
                      child: Material(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(96)),
                        color: Surfaces.black,
                        child: widget.album?.cover == null
                        ? SizedBox.square(
                          dimension: 192,
                        )
                        : GestureDetector(
                          onTap: () => switch(widget.player.state) {
                            PlayerState.playing => widget.player.pause(),
                            PlayerState.paused => widget.player.resume(),
                            _ => (() {
                              widget.player.setSource(DeviceFileSource(widget.album!.songs[widget.songIndex].path));
                              widget.player.resume();
                            })(),
                          },
                          /*alignment: Alignment.center,
                          child: Material(
                            shape: CircleBorder(),
                            color: Surfaces.metal,
                            child: SizedBox.square(
                              dimension: 4,
                            ),
                          ),*/
                          child: widget.album,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => widget.setAlbum(null, context),
                        child: Material(
                          elevation: widget.album == null ? 0 : 1,
                          borderRadius: BorderRadius.circular(24),
                          color: Surfaces.metal,
                          child: SizedBox(
                            width: 48,
                            height: 48,
                            child: Icon(
                              Icons.close_rounded,
                              color: Surfaces.floor,
                            ),
                          ),
                        ),
                      ),
                      Material(
                        elevation: widget.album == null ? 0 : 1,
                        borderRadius: BorderRadius.circular(24),
                        color: Surfaces.metal,
                        child: SizedBox(
                          height: 48,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => widget.play(-1),
                                onLongPress: () {}, // seek back and forth inside song
                                child: Container(
                                  height: 48,
                                  padding: EdgeInsets.only(
                                    left: 24,
                                    right: 16,
                                  ),
                                  child: Icon(
                                    Icons.skip_previous_rounded,
                                    color: Surfaces.floor,
                                  ),
                                ),
                              ),
                              VerticalDivider(
                                width: 2,
                                thickness: 2,
                                indent: 8,
                                endIndent: 8,
                                color: Surfaces.floor,
                              ),
                              GestureDetector(
                                onTap: () => widget.play(1),
                                onLongPress: () {}, // seek back and forth inside song
                                child: Container(
                                  height: 48,
                                  padding: EdgeInsets.only(
                                    left: 16,
                                    right: 24,
                                  ),
                                  child: Icon(
                                    Icons.skip_next_rounded,
                                    color: Surfaces.floor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {}, // skip
                        onLongPress: () {}, // seek back and forth inside song
                        child: Material(
                          elevation: widget.album == null ? 0 : 1,
                          borderRadius: BorderRadius.circular(24),
                          color: Surfaces.metal,
                          child: SizedBox(
                            width: 48,
                            height: 48,
                            child: Icon(
                              Icons.info_outline_rounded,
                              color: Surfaces.floor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Material(
                      elevation: 1,
                      shape: CircleBorder(),
                      color: Surfaces.blackMetal,
                      child: SizedBox.square(
                        dimension: 32,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 16,
                      ),
                      child: AnimatedRotation(
                        alignment: Alignment.centerRight,
                        duration: Duration.zero,
                        turns: -0.15,
                        child: Material(
                          elevation: 1,
                          shape: StadiumBorder(),
                          color: Surfaces.blackMetal,
                          child: SizedBox(
                            width: 128 + 32,
                            height: 8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
