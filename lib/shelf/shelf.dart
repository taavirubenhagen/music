import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:v1/main.dart';
import 'package:v1/player/player.dart';
import 'package:v1/shelf/collection.dart';
import 'package:v1/ui/design/theme.dart';


class Shelf extends StatefulWidget {
  const Shelf({super.key, required this.title});

  final String title;

  @override
  State<Shelf> createState() => _ShelfState();
  
  static void setState(BuildContext context, [Function()? function]) {
    _ShelfState? ancestorState = context.findAncestorStateOfType<_ShelfState>();
    if (ancestorState == null) {
      debugPrint("Shelf.setState(): ancestorState == null");
      return;
    }
    // ignore: invalid_use_of_protected_member
    ancestorState.setState(function ?? () {});
  }
}

class _ShelfState extends State<Shelf> {
  
  @override
  initState() {
    super.initState();
    
    () async {
      var status = await Permission.manageExternalStorage.status;
      if (!status.isGranted || true) {
        await Permission.manageExternalStorage.request();
        await Permission.storage.request();
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Surfaces.floor,
      appBar: AppBar(
        backgroundColor: Surfaces.floor,
        toolbarHeight: 0,
      ),
      body: SizedBox(
        width: Tavy.width(context),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              width: Tavy.width(context),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 64,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.help_outline_rounded,
                        size: 32,
                        color: Surfaces.metal,
                      ),
                      SizedBox(width: 32),
                      Icon(
                        Icons.settings_rounded,
                        size: 32,
                        color: Surfaces.metal,
                      ),
                      SizedBox(width: 32),
                      Icon(
                        Icons.arrow_upward_rounded,
                        size: 32,
                        color: Surfaces.metal,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        recordPlayer,
                      ],
                    ),
                  ),
                ),
                Material(
                  color: Surfaces.lightWood,
                  child: SafeArea(
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 800),
                      curve: Curves.easeInOut,
                      width: Tavy.width(context),
                      height: recordPlayer.album == null || !true ? Tavy.paddedHeight(context) - RecordPlayer.height - 128 : 0,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 48 + 2 * 32,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      top: 32,
                                      bottom: 32,
                                    ),
                                    child: Material(
                                      shape: CircleBorder(
                                        side: BorderSide(
                                          color: Surfaces.metal,
                                        ),
                                      ),
                                      color: Colors.transparent,
                                      child: SizedBox(
                                        width: 48,
                                        child: Icon(
                                          Icons.settings_rounded,
                                          size: 24,
                                          color: Surfaces.metal,
                                        ),
                                      ),
                                    ),
                                  ),
                                  for (final genreName in ["Hip Hop", "Pop / Rock", "EDM"])
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      top: 32,
                                      bottom: 32,
                                    ),
                                    child: Material(
                                      shape: StadiumBorder(
                                        side: BorderSide(
                                          color: Surfaces.metal,
                                        ),
                                      ),
                                      color: Colors.transparent,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                        ),
                                        child: Stack(
                                          alignment: Alignment.centerLeft,
                                          children: [
                                            Text(
                                              genreName,
                                              style: GoogleFonts.lexend(
                                                color: Surfaces.metal,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: recordPlayer.album == null || true ? Tavy.paddedHeight(context) - RecordPlayer.height - 128 - 32 - 48 - 32 : 0,
                              child: FutureBuilder(
                                future: (() async => ( await Collection.albums ) + ( await Collection.albums ) + ( await Collection.albums ) + ( await Collection.albums ))(),
                                builder: (context, snapshot) {
                                  return !snapshot.hasData
                                  ? Center(
                                    child: CircularProgressIndicator(
                                      color: Surfaces.floor,
                                    ),
                                  )
                                  : GridView.builder(
                                    scrollDirection: Axis.horizontal,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 16,
                                      crossAxisSpacing: 16,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ).copyWith(
                                      bottom: 32,
                                    ),
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, i) {
                                      return snapshot.data![i].cover == null
                                      ? SizedBox()
                                      : GestureDetector(
                                        onTap: () => debugPrint("info"),
                                        onDoubleTap: () => recordPlayer.setAlbum(snapshot.data![i], context),
                                        onLongPress: () => debugPrint("drag"),
                                        child: Material(
                                          elevation: 2,
                                          borderRadius: BorderRadius.circular(8),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.memory(snapshot.data![i].cover!),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}