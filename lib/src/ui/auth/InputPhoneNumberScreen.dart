import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unites_flutter/src/resources/UserRepository.dart';
import 'package:unites_flutter/src/ui/auth/InputCodeScreen.dart';
import 'package:unites_flutter/src/ui/auth/RegistrationScreen.dart';
import 'package:unites_flutter/src/ui/profile/EditProfileScreen.dart';

import '../../Home.dart';

class InputPhoneNumberScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _InputPhoneNumberScreen();
}

class _InputPhoneNumberScreen extends State<InputPhoneNumberScreen> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  final UserRepository userRepository = UserRepository();

  String _phone;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        _showForm(),
      ],
    ));
  }

  Widget showPhoneInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
      child: TextFormField(
          controller: _phoneController,
          maxLines: 1,
          keyboardType: TextInputType.phone,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'Телефон',
              icon: Icon(
                Icons.phone,
                color: Colors.grey,
              )),
          validator: (value) {
            if (value.isEmpty) {
              return 'Введите номер';
            }
            return null;
          }),
    );
  }

  Widget showButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: Text('Отправить',
                style: TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: () {
              final phone = _phoneController.text.trim();
              if (phone.isNotEmpty) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InputCodeScreen(
                              phoneNumber: phone,
                            )));
              }
//              loginUser(phone, context);
            },
          ),
        ));
  }

  Widget _showForm() {
    return Container(
        margin: const EdgeInsets.only(top: 140.0),
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                  child: Text(
                'Вход',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              )),
              Container(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    'Мы отправим Вам проверочный код на указанный номер',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  )),
              showPhoneInput(),
              showButton(),
            ],
          ),
        ));
  }
}
