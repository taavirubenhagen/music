import 'package:audioplayers/audioplayers.dart';
import 'package:audiotags/audiotags.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:v1/shelf/collection.dart';


class Album extends StatelessWidget {
  Album(this._songs, {super.key}) {
    exampleTag = _songs.firstOrNull?.tag;
    cover = exampleTag?.pictures.where(
      (p) => p.pictureType == PictureType.coverFront
    ).map((p) => p.bytes).firstOrNull ?? exampleTag?.pictures.map((p) => p.bytes).firstOrNull;
  }
  
  final Set<Song> _songs;
  Tag? exampleTag;
  Uint8List? cover;
  
  List<Song> get songs {
    List<Song> sortedSongs = _songs.toList();
    sortedSongs.sort((a, b) => a.path.compareTo(b.path));
    debugPrint("Sorted: ${sortedSongs.map((s) => s.tag?.title)}");
    return sortedSongs;
  }
  List<DeviceFileSource> get sources => _songs.map((s) => DeviceFileSource(s.path)).toList();
  bool get complete => _songs.length == exampleTag?.trackTotal;
  
  void add(Song song) => _songs.add(song);
  
  @override
  operator ==(other) {
    if (other is! Album) return false;
    return exampleTag?.album == other.exampleTag?.album && exampleTag?.albumArtist == other.exampleTag?.albumArtist;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => ( exampleTag?.album ?? ""  ).hashCode ^ ( exampleTag?.albumArtist ?? ""  ).hashCode;

  @override
  Widget build(BuildContext context) => cover == null
  ? SizedBox()
  : ClipRRect(
    borderRadius: BorderRadius.circular(96),
    child: Image.memory(
      cover!,
      width: 192,
      height: 192,
    ),
  );
}
