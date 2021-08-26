import 'package:flutter/material.dart';
import 'package:unites_flutter/ui/main.dart';
import 'package:unites_flutter/domain/models/user_model.dart';
import 'package:unites_flutter/data/repository/user_repository_impl.dart';

import '../home.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreen createState() => _RegistrationScreen();
}

class _RegistrationScreen extends State<RegistrationScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final aboutController = TextEditingController();
  final interestsController = TextEditingController();
  final companyController = TextEditingController();
  final usefulController = TextEditingController();

  var userRepository = getIt<UserRepositoryImpl>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Регистрация')),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
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
                      var user = UserModel();
                      user.firstName = firstNameController.text;
                      user.lastName = lastNameController.text;
                      user.company = companyController.text;
                      user.useful = usefulController.text;
                      user.interests = interestsController.text;
                      user.aboutMe = aboutController.text;
                      userRepository.createNewUser(user);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    },
                    child: Text('Зарегистрироваться'),
                  ),
                ],
              )),
        ])));
  }
}
