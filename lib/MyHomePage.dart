import 'dart:io';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chewie/chewie.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MyHomePage> {
  final List<String> _photoList = [];
  final List<String> _videoList = [];
  bool _isShowingImages = true;
  //List<bool> _selectedItems = [];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 174, 57),
        title: const Text("PhotoCut Pro"),
        leading: IconButton(
          icon: const Icon(Icons.menu), // Hamburger icon
          onPressed: () {
            // Add your menu functionality here
          },
        ),
      ),
      body: Column(
        children: [
          Container(color: const Color.fromARGB(255, 18, 123, 169),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isShowingImages = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _isShowingImages ? Colors.black : Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.photo, size: 24),
                        SizedBox(width: 5),
                        Text('Photos', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isShowingImages = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: !_isShowingImages ? Colors.black : Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.video_library, size: 24),
                        SizedBox(width: 5),
                        Text('Videos', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: _isShowingImages
                  ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
                itemCount: _photoList.length,
                itemBuilder: (context, index) {
                  return _buildMediaItem2(_photoList[index], index);

                },
              )
                  : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
                itemCount: _videoList.length,
                itemBuilder: (context, index) {
                  return _buildMediaItem(_videoList[index], index);
                },
              ),
            ),
          ),
      ],
    ),
      floatingActionButton: FloatingActionButton(backgroundColor: const Color.fromARGB(
          255, 252, 154, 0),

        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Gallery'),
                    onTap: () {
                      _addMedia(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Capture'),
                    onTap: () {
                      _addMedia(ImageSource.camera);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.video_library),
                    title: const Text('Video Gallery'),
                    onTap: () {
                      _addMedia(ImageSource.gallery, isVideo: true);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.video_camera_back),
                    title: const Text('Video Camera'),
                    onTap: () {
                      _addMedia(ImageSource.camera, isVideo: true);
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMediaItem(String path, int index) {
    return ListTile(
      title: _buildVideoItem(path),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          setState(() {
            _videoList.removeAt(index);
          });
        },
      ),
    );
  }
  Widget _buildMediaItem2(String path, int index) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FullScreenImagePage(imagePath: _photoList[index]),),
            );
          },
          child: GridTile(
            child: Image.file(
              File(_photoList[index]),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 8.0,
          right: 8.0,
          child: IconButton(
            icon: const Icon(Icons.delete_forever_outlined),
            onPressed: () {
              setState(() {
                _photoList.removeAt(index);
              });
            },
          ),
        ),
      ],
    );
  }


  Widget _buildVideoItem(String path) {
    final VideoPlayerController videoPlayerController = VideoPlayerController.file(File(path));
    final ChewieController chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      looping: true,
      allowFullScreen: true,
      allowMuting: true,
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown, DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
    );

    return Chewie(controller: chewieController);
  }

  void _addMedia(ImageSource source, {bool isVideo = false}) async {
    final picker = ImagePicker();
    final pickedFile = isVideo ? await picker.getVideo(source: source) : await picker.getImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (isVideo) {
          _videoList.add(pickedFile.path);
        } else {
          _photoList.add(pickedFile.path);
        }
      });
    }
  }
}

//////////////////////IMAGE VIEW///////////////////////////////////////////////////////////
class FullScreenImagePage extends StatefulWidget {
  final String imagePath;

  const FullScreenImagePage({Key? key, required this.imagePath}) : super(key: key);

  @override
  _FullScreenImagePageState createState() => _FullScreenImagePageState();
}

class _FullScreenImagePageState extends State<FullScreenImagePage> {
  double _rotation = 0.0;
  double _scale = 1.0;

  void _rotateLeft() {
    setState(() {
      _rotation -= 90;
    });
  }

  void _rotateRight() {
    setState(() {
      _rotation += 90;
    });
  }
  void _zoomIn() {
    setState(() {
      _scale += 0.1;
    });
  }

  void _zoomOut() {
    setState(() {
      if (_scale > 0.2) {
        _scale -= 0.1;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 174, 57),
        title: Text('PhotoCut Pro'),
      ),
      body: Stack(
        children: [
          Center(
            child: Transform.rotate(
              angle: _rotation * (3.1415926535897932 / 180),
              child: Transform.scale(
                scale: _scale,
                child: Image.file(
                  File(widget.imagePath),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(color: const Color.fromARGB(255, 250, 174, 57),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    child: const Icon(Icons.zoom_in),
                    onPressed: _zoomIn,
                  ),
                  FloatingActionButton(
                    child: const Icon(Icons.rotate_left),
                    onPressed: _rotateLeft,
                  ),
                  FloatingActionButton(
                    child: const Icon(Icons.rotate_right),
                    onPressed: _rotateRight,
                  ),
                  FloatingActionButton(
                    child: const Icon(Icons.zoom_out),
                    onPressed: _zoomOut,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}