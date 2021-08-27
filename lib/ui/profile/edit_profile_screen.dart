import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:unites_flutter/ui/main.dart';
import 'package:unites_flutter/ui/bloc/user_bloc.dart';
import 'package:unites_flutter/domain/models/user_model.dart';
import 'package:unites_flutter/data/repository/user_repository_impl.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  static Color colorById(String id) {
    var colors = [
      Colors.deepPurpleAccent,
      Colors.cyanAccent,
      Colors.redAccent,
      Colors.deepOrange,
      Colors.pinkAccent,
      Colors.indigoAccent
    ];
    var substring = id.substring(0, 2);
    var hash = substring.hashCode;
    var index = hash % colors.length;
    return colors[index];
  }

  @override
  _EditProfileScreen createState() => _EditProfileScreen();
}

class _EditProfileScreen extends State<EditProfileScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final aboutController = TextEditingController();
  final interestsController = TextEditingController();
  final companyController = TextEditingController();
  final usefulController = TextEditingController();

  var userRepository = getIt<UserRepositoryImpl>();
  final userBloc = getIt<UsersBloc>();

  File? _image;
  String? avatarUrl;

  @override
  void didChangeDependencies() {
    userBloc.fetchCurrentUser();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    userBloc.dispose();
    super.dispose();
  }

  Future getImage() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 85);
    setState(() {
      if (image != null) {
        _image = File(image.path);
      }
    });
  }

  void _onLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              CircularProgressIndicator(),
              Text('Loading'),
            ],
          ),
        );
      },
    );
  }

  Future uploadImage(BuildContext context) async {
    var user = UserModel();
    user.firstName = firstNameController.text;
    user.lastName = lastNameController.text;
    user.company = companyController.text;
    user.useful = usefulController.text;
    user.interests = interestsController.text;
    user.aboutMe = aboutController.text;
    user.avatar = avatarUrl;

    if (_image != null) {
      _onLoading(context);
      var fileName = basename(_image!.path);
      var firebaseStorage = FirebaseStorage.instance.ref().child(fileName);
      var task = await firebaseStorage.putFile(_image!);
      // await task.onComplete;
      var url = await firebaseStorage.getDownloadURL();
      avatarUrl = url;
      user.avatar = avatarUrl;
      userRepository.updateUser(user);
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      userRepository.updateUser(user);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Мой профиль')),
        body: StreamBuilder(
          stream: userBloc.getUser,
          builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
            if (snapshot.hasData) {
              firstNameController.text = '${snapshot.data?.firstName}';
              lastNameController.text = '${snapshot.data?.lastName}';
              aboutController.text = '${snapshot.data?.aboutMe}';
              interestsController.text = '${snapshot.data?.interests}';
              companyController.text = '${snapshot.data?.company}';
              usefulController.text = '${snapshot.data?.useful}';
              avatarUrl = snapshot.data?.avatar;
              return buildInfo(snapshot, context);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          },
        ));
  }

  Widget buildInfo(AsyncSnapshot<UserModel> snapshot, BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
      Container(margin: EdgeInsets.only(top: 16.0, bottom: 8.0)),
      GestureDetector(
        onTap: () {
          getImage();
        },
        child: CircleAvatar(
          radius: 84,
          backgroundColor: EditProfileScreen.colorById(snapshot.data!.userId),
          child: Stack(
            children: [
              Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: _image == null && snapshot.data?.avatar == null,
                child: Text(
                    '${snapshot.data?.firstName[0] ?? ''}${snapshot.data?.lastName[0] ?? ''}',
                    style: TextStyle(fontSize: 44, color: Colors.white),
                    textAlign: TextAlign.center),
              ),
              if (snapshot.data?.avatar != null)
                ClipOval(
                    child: SizedBox(
                        width: 300,
                        height: 300,
                        child: Image.network(snapshot.data!.avatar!,
                            fit: BoxFit.cover))),
              if (_image != null)
                ClipOval(
                    child: SizedBox(
                        width: 300,
                        height: 300,
                        child: Image.file(
                          _image!,
                          fit: BoxFit.cover,
                        )))
            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(20.0),
        child: TextFormField(
          controller: firstNameController,
          decoration: InputDecoration(
            labelText: "Имя",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          // The validator receives the text that the user has entered.
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Введите имя';
            }
            return null;
          },
        ),
      ),
      Padding(
        padding: EdgeInsets.all(20.0),
        child: TextFormField(
          controller: lastNameController,
          decoration: InputDecoration(
            labelText: "Фамилия",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          // The validator receives the text that the user has entered.
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Введите фамилию';
            }
            return null;
          },
        ),
      ),
      Padding(
        padding: EdgeInsets.all(20.0),
        child: TextFormField(
          controller: aboutController,
          decoration: InputDecoration(
            labelText: "Обо мне",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          // The validator receives the text that the user has entered.
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Напишите информацию о себе';
            }
            return null;
          },
        ),
      ),
      Padding(
        padding: EdgeInsets.all(20.0),
        child: TextFormField(
          controller: interestsController,
          decoration: InputDecoration(
            labelText: "Я ищу (каких людей/товары/услуги)",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          // The validator receives the text that the user has entered.
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Заполните поле';
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
            labelText: "Компания",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          // The validator receives the text that the user has entered.
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Заполните поле';
            }
            return null;
          },
        ),
      ),
      Padding(
        padding: EdgeInsets.all(20.0),
        child: TextFormField(
          controller: usefulController,
          decoration: InputDecoration(
            labelText: "Чем могу быть полезен",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          // The validator receives the text that the user has entered.
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Заполните поле';
            }
            return null;
          },
        ),
      ),
      Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                color: Colors.lightBlue,
                onPressed: () {
                  uploadImage(context);
                },
                child: Text('Сохранить'),
              ),
            ],
          )),
    ])));
  }
}
