import 'dart:ffi';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:unites_flutter/ui/bloc/story_bloc.dart';
import 'package:unites_flutter/domain/models/story_model.dart';
import 'package:unites_flutter/data/repository/user_repository_impl.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../home.dart';
import '../main.dart';

class CreateStoryScreen extends StatefulWidget {
  @override
  _CreateStoryScreenState createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  List<CameraDescription>? _cameras;
  CameraController? cameraController;
  File? _file;
  File? videoThumb;
  var storyBloc = StoryBloc();
  final userRepository = getIt<UserRepositoryImpl>();

  var indicator = false;

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      cameraController =
          CameraController(_cameras![0], ResolutionPreset.ultraHigh);
      await cameraController?.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController != null) {
      if (cameraController != null && !cameraController!.value.isInitialized) {
        return Container(width: 0.0, height: 0.0);
      } else {
        return Scaffold(
          extendBody: true,
          bottomNavigationBar:
              _file == null ? buildBottomNavigationBar() : null,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              alignment: FractionalOffset.center,
              children: <Widget>[
                _file != null ? Image.file(_file!) : _buildCameraPreview(),
                videoThumb != null
                    ? Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Image.file(videoThumb!, fit: BoxFit.contain))
                    : Container(),
                _file != null
                    ? Padding(
                        padding: const EdgeInsets.only(
                            top: 44.0, left: 8.0, right: 8.0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _file = null;
                                    videoThumb = null;
                                    setState(() {});
                                  },
                                  iconSize: 34.0,
                                  icon: Icon(Icons.close, color: Colors.white),
                                ),
                                IconButton(
                                  onPressed: () {
                                    indicator = true;
                                    setState(() {});
                                    createStory();
                                  },
                                  iconSize: 34.0,
                                  icon: Icon(Icons.done, color: Colors.white),
                                ),
                              ]),
                        ),
                      )
                    : Container(),
                indicator == true
                    ? Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator())
                    : Container()
              ],
            ),
          ),
        );
      }
    } else {
      return Container(width: 0.0, height: 0.0);
    }
    ;
  }

  Widget _buildCameraPreview() {
    final size = MediaQuery.of(context).size;
    return ClipRect(
      child: Container(
        child: Transform.scale(
          scale: cameraController!.value.aspectRatio / size.aspectRatio,
          child: Center(
            child: AspectRatio(
              aspectRatio: cameraController!.value.aspectRatio,
              child: CameraPreview(cameraController!),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onCameraSwitch() async {
    final cameraDescription = (cameraController!.description == _cameras![0])
        ? _cameras![1]
        : _cameras![0];
    if (cameraController != null) {
      await cameraController!.dispose();
    }
    cameraController =
        CameraController(cameraDescription, ResolutionPreset.medium);
    cameraController?.addListener(() {
      if (mounted) setState(() {});
      if (cameraController!.value.hasError) {
        final snackBar = SnackBar(
            content: Text(
                'Camera error ${cameraController?.value.errorDescription}'));
        Scaffold.of(context).showSnackBar(snackBar);
      }
    });

    try {
      await cameraController?.initialize();
    } on CameraException catch (e) {
      final snackBar = SnackBar(content: Text('$e'));
      Scaffold.of(context).showSnackBar(snackBar);
      ;
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget buildBottomNavigationBar() {
    return Container(
      color: Colors.black,
      height: 80.0,
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
            onTap: () => pickFromGallery(),
            child: Container(
              width: 40.0,
              height: 40.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Icon(Icons.perm_media),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 28.0,
              child: IconButton(
                  icon: Icon(
                    Icons.camera_alt,
                    size: 28.0,
                    color: Colors.black54,
                  ),
                  onPressed: captureImage),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.switch_camera,
              color: Colors.white,
            ),
            onPressed: onCameraSwitch,
          )
        ],
      ),
    );
  }

  // Future<FileSystemEntity> getLastImage() async {
  //   final extDir = await getApplicationDocumentsDirectory();
  //   final dirPath = '${extDir.path}/media';
  //   final myDir = Directory(dirPath);
  //   List<FileSystemEntity> _images;
  //   _images = myDir.listSync(recursive: true, followLinks: false);
  //   _images.sort((a, b) {
  //     return b.path.compareTo(a.path);
  //   });
  //   var lastFile = _images[0];
  //   var extension = path.extension(lastFile.path);
  //   if (extension == '.jpeg') {
  //     return lastFile;
  //   } else {
  //     var thumb = await Thumbnails.getThumbnail(videoFile: lastFile.path, imageType: ThumbFormat.PNG, quality: 30);
  //     return File(thumb);
  //   }
  // }

  Future<void> pickFromGallery() async {
    var videoPath;
    var file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'mp4', 'wmv', 'webm', 'mov', 'gif']);
    if (file != null && file.count >= 1) {
      if (getMediaType(file.paths[0]!) == MediaType.VIDEO) {
        videoPath = await VideoThumbnail.thumbnailFile(
            video: file.paths[0]!, quality: 30);
      }

      setState(() {
        final path = file.paths[0]!;
        _file = File(path);
        if (videoPath != null) {
          if (getMediaType(path) == MediaType.VIDEO) {
            videoThumb = File(videoPath);
          }
        }
      });
    }
  }

  void captureImage() async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      await SystemSound.play(SystemSoundType.click);
      final xFile = await cameraController!.takePicture();
      final filePath = xFile.path;
      setState(() {
        _file = File(filePath);
      });
    }
  }

  void createStory() async {
    if (userRepository.currentUser == null) {
      throw Exception('User not init');
    }

    var metadata = SettableMetadata(contentType: lookupMimeType(_file!.path));
    var firebaseStorage =
        FirebaseStorage.instance.ref().child(path.basename(_file!.path));
    await firebaseStorage.putFile(_file!, metadata);
    var url = await firebaseStorage.getDownloadURL();
    var story = StoryModel();
    story.userId = userRepository.currentUser!.userId;
    story.url = url;
    story.mediaType = getMediaType(_file!.path);
    storyBloc.createStory(story);
    Navigator.of(context).pop();
    await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()),
        (Route<dynamic> route) => false);
  }

  MediaType getMediaType(String path) {
    var type = lookupMimeType(path);
    if (type?.split('/')[0] == 'image') {
      return MediaType.IMAGE;
    } else {
      return MediaType.VIDEO;
    }
  }
}
