import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:unites_flutter/domain/models/image_collection.dart';
import 'package:unites_flutter/ui/main.dart';
import 'package:unites_flutter/ui/bloc/event_bloc.dart';
import 'package:unites_flutter/domain/models/event_model.dart';

import '../home.dart';
import 'map/select_addrees_screen.dart';

class CreateEventScreen extends StatefulWidget {
  CreateEventScreen({Key? key}) : super(key: key);

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  Completer<GoogleMapController> _controller = Completer();

  final eventBloc = getIt<EventsBloc>();

  final List<File> _images = [];

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final companyController = TextEditingController();
  final ownerPhoneController = TextEditingController();
  final ownerEmailController = TextEditingController();
  final addressController = TextEditingController();

  DateTime startDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  DateTime endDate = DateTime.now();
  TimeOfDay endTime = TimeOfDay.now();
  GeoPoint? coordinates;

  _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectAddressScreen()),
    );
    var arrString = result.toString().split(" ");
    var res = "";

    coordinates = GeoPoint(double.parse(arrString[arrString.length - 2]),
        double.parse(arrString[arrString.length - 1]));
    arrString.forEach((element) {
      if (element != arrString[arrString.length - 2] &&
          element != arrString[arrString.length - 1]) {
        res += '$element ';
      }
    });
    addressController.text = res;
  }

  TextStyle linkStyle = TextStyle(color: Colors.blue);

  Future<Null> _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = DateTime(picked.year, picked.month, picked.day,
            startTime.hour, startTime.minute);
      });
    }
  }

  Future<Null> _selectStartTime(BuildContext context) async {
    final picked =
    await showTimePicker(context: context, initialTime: startTime);
    if (picked != null && picked != startTime) {
      setState(() {
        startDate = DateTime(startDate.year, startDate.month, startDate.day,
            picked.hour, picked.minute);
      });
    }
  }

  Future<Null> _selectEndDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: endDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = DateTime(picked.year, picked.month, picked.day, endTime.hour,
            endTime.minute);
      });
    }
  }

  Future<Null> _selectEndTime(BuildContext context) async {
    final picked = await showTimePicker(context: context, initialTime: endTime);
    if (picked != null && picked != endTime) {
      setState(() {
        endDate = DateTime(endDate.year, endDate.month, endDate.day,
            picked.hour, picked.minute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Новое мепроприятие')),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Название',
                    helperText: '*Обязательно поле',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите название';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Описание мероприятия',
                    helperText: '*Обязательно поле',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите описание';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: companyController,
                  decoration: InputDecoration(
                    labelText: 'Компания-организатор',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: ownerPhoneController,
                  decoration: InputDecoration(
                    labelText: 'Телефон организатора',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: ownerEmailController,
                  decoration: InputDecoration(
                    labelText: 'E-mail организатора',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  onTap: () async {
                    _navigateAndDisplaySelection(context);
                  },
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Адрес места проведения',
                    helperText: '*Обязательно поле',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Заполните адрес';
                    }
                    return null;
                  },
                ),
              ),
              Row(
                children: [
                  Container(
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text('Начало: '),
                    ),
                  ),
                  Container(
                    child: RichText(
                      text: TextSpan(
                          text: '${startDate.toLocal()}'.split(' ')[0],
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _selectStartDate(context);
                            }),
                    ),
                  ),
                  Container(margin: EdgeInsets.only(left: 12.0)),
                  Container(
                    child: RichText(
                      text: TextSpan(
                          text:
                          '${startDate.hour}:${startDate.minute}'.split(' ')[0],
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _selectStartTime(context);
                            }),
                    ),
                  ),
                ],
              ),
              Container(margin: EdgeInsets.only(bottom: 12.0)),
              Row(
                children: [
                  Container(
                    child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text('Завершение: '),
                      ),
                    ]),
                  ),
                  Container(
                    child: RichText(
                      text: TextSpan(
                          text: '${endDate.toLocal()}'.split(' ')[0],
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _selectEndDate(context);
                            }),
                    ),
                  ),
                  Container(margin: EdgeInsets.only(left: 12.0)),
                  Container(
                    child: RichText(
                      text: TextSpan(
                          text: '${endDate.hour}:${endDate.minute}',
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _selectEndTime(context);
                            }),
                    ),
                  ),
                ],
              ),
              _photoPicker(),
              Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.lightBlue,
                        onPressed: () => createEvent(context),
                        child: Text('Создать'),
                      ),
                    ],
                  )),
            ])));
  }

  Future<void> createEvent(BuildContext context) async {
    var event = EventModel();
    event.name = nameController.text;
    event.description = descriptionController.text;
    event.company = companyController.text;
    event.phoneNumber = ownerPhoneController.text;
    event.email = ownerEmailController.text;
    event.address = addressController.text;
    event.start = startDate;
    event.end = endDate;
    event.coordinates = coordinates;

    final images = await sendImages();
    print(images?.toJson());

    eventBloc.createEvent(event, images: images);

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  Future<EventImagesModel?> sendImages() async{
    var links = <String>[];

    for(var element in _images){
      print('Start sending image $element');
      var fileName = basename(element.path);
      var firebaseStorage = FirebaseStorage.instance.ref().child(fileName);

      await firebaseStorage.putFile(element);
      final url = await firebaseStorage.getDownloadURL();

      print('Element upload and send in location $url');
      links.add(url);
    }

    print('sending finish');
    if(links.isNotEmpty) {
      print('sendImages: ${links.length}');
      return EventImagesModel(id: 'id', imagesPath: links);
    }else{
      print('sendImages: EMPTY');
      return null;
    }
  }

  Widget _photoPicker() {
    return Column(
      children: [
        MaterialButton(
            onPressed: _images.length >= 10
                ? null
                : () async {
              getImage();
            },
            child: Text('Добавить картинку +')),
        Text('Изображений загружено ${_images.length}/10'),
        // _photoList(),
      ],
    );
  }

  Widget _photoList() {
    return ListView.builder(scrollDirection: Axis.horizontal, itemCount: _images.length, itemBuilder: (BuildContext context, int index) {
      return _photoItem(_images[index]);
    });
  }

  Widget _photoItem(File image){
    return Container(
      width: 100,
      height: 100,
      child: Image.file(image),
    );
  }

  getImage() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (image == null) {
      return;
    }

    final imageSize = await image.length();

    if (imageSize <= maxImageSize) {
      print('$imageSize is good');
      setState(() {
        _images.add(File(image.path));
      });
    } else {
      print('image size is $imageSize more then expected $maxImageSize');
      // TODO("Compressed")
    }
  }

  final int maxImageSize = 524280; // 512 KB
}
