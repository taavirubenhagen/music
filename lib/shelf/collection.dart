import 'dart:io';

import 'package:audiotags/audiotags.dart';
import 'package:flutter/material.dart';
import 'package:v1/player/album.dart';


class Song {
  Song(this.path, this.tag);
  
  final String path;
  final Tag? tag;
  
  @override
  operator ==(other) {
    if (other is! Song) return false;
    return tag?.title == other.tag?.title && tag?.trackArtist == other.tag?.trackArtist;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => ( tag?.title ?? ""  ).hashCode ^ ( tag?.trackArtist ?? ""  ).hashCode;
}


abstract class Collection {
  
  static Future<Song> songAt(String path) async => Song(path, await AudioTags.read(path));
  static Future<List<Song>> get songs async {
    final files = Directory("/storage/emulated/0/Music").listSync(recursive: true)
      .where((file) => file.path.endsWith('.mp3') || file.path.endsWith('.wav') || file.path.endsWith('.flac'));
    Set<Song> songs = {};
    for (FileSystemEntity file in files) {
      songs.add(await songAt(file.path));
    }
    for (final song in songs) debugPrint(song.tag?.trackNumber.toString());
    return songs.toList();
  }
  static Future<List<Album>> get albums async {
    List<Album> albums = [];
    for (Song song in await songs) {
      if (!albums.contains(Album({song}))) albums.add(Album({song}));
    }
    for (Song song in await songs) {
      albums.firstWhere((a) => a == Album({song})).add(song);
    }
    return albums;
  }
}