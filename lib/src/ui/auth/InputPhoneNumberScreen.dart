import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unites_flutter/src/resources/UserRepository.dart';
import 'package:unites_flutter/src/ui/auth/RegistrationScreen.dart';
import 'package:unites_flutter/src/ui/profile/EditProfileScreen.dart';

import '../../Home.dart';

class InputPhoneNumberScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _InputPhoneNumberScreen();
}

class _InputPhoneNumberScreen extends State<InputPhoneNumberScreen> {
  final _formKey = new GlobalKey<FormState>();

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
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
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
        validator: (value) =>
            value.isEmpty ? 'Поле не может быть пустым' : null,
        onSaved: (value) => _phone = value.trim(),
      ),
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
              loginUser(phone, context);
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
              showPhoneInput(),
              showButton(),
            ],
          ),
        ));
  }

  Future<bool> loginUser(String phone, BuildContext context) async {
    var _auth = FirebaseAuth.instance;

    await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();

          var result = await _auth.signInWithCredential(credential);

          var user = result.user;

          if (user != null) {
            final userExist = await userRepository.isUserExist();
            if (userExist) {
              await Navigator.of(context)
                  .pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  Home()), (Route<dynamic> route) => false);
            } else {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegistrationScreen()));
            }
          } else {
            print('Error');
          }
        },
        verificationFailed: (AuthException exception) {
          print(exception.message);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text('Получили код?'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _codeController,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Подтвердить'),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () async {
                        final code = _codeController.text.trim();
                        var credential =
                            PhoneAuthProvider.getCredential(
                                verificationId: verificationId, smsCode: code);

                        var result =
                            await _auth.signInWithCredential(credential);

                        var user = result.user;

                        if (user != null) {
                          final userExist = await userRepository.isUserExist();
                          if (userExist) {
                            await Navigator.of(context)
                                .pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                Home()), (Route<dynamic> route) => false);
                          } else {
                            await Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RegistrationScreen()));
                          }
                        } else {
                          print("Error");
                        }
                      },
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: null);
  }
}
