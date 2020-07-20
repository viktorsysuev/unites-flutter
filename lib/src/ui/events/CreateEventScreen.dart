import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unites_flutter/src/blocs/EventsBloc.dart';
import 'package:unites_flutter/src/models/EventModel.dart';
import 'package:google_map_location_picker/generated/i18n.dart'
    as location_picker;
import 'package:google_map_location_picker/google_map_location_picker.dart';

import '../../Home.dart';
import 'SelectAddreesScreen.dart';

class CreateEventScreen extends StatefulWidget {
  CreateEventScreen({Key key}) : super(key: key);

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  Completer<GoogleMapController> _controller = Completer();

  final eventBloc = EventsBloc();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
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

  _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectAddressScreen()),
    );

    addressController.text = result;
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
    final picked =
        await showTimePicker(context: context, initialTime: endTime);
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
                if (value.isEmpty) {
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
                if (value.isEmpty) {
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
//                await Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => SelectAddressScreen()),
//                );
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
                if (value.isEmpty) {
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
          Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.lightBlue,
                    onPressed: () {
                      var event = EventModel();
                      event.name = nameController.text;
                      event.description = descriptionController.text;
                      event.company = companyController.text;
                      event.phoneNumber = ownerPhoneController.text;
                      event.email = ownerEmailController.text;
                      event.address = addressController.text;
                      event.start = startDate;
                      event.end = endDate;
                      eventBloc.createEvent(event);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    },
                    child: Text('Создать'),
                  ),
                ],
              )),
        ])));
  }
}
