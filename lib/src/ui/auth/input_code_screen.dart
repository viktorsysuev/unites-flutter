import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unites_flutter/main.dart';
import 'package:unites_flutter/src/resources/user_repository.dart';

import '../../home.dart';
import 'registration_screen.dart';

class InputCodeScreen extends StatefulWidget {
  String phoneNumber;

  InputCodeScreen({@required this.phoneNumber});

  @override
  _InputCodeScreenState createState() => _InputCodeScreenState();
}

class _InputCodeScreenState extends State<InputCodeScreen> {
  final _codeController = TextEditingController();
  var _verificationId = '';
  var userRepository = getIt<UserRepository>();
  final _auth = FirebaseAuth.instance;
  var progressVisible = false;
  final _formKey = GlobalKey<FormState>();

  String _code;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    loginUser(widget.phoneNumber, context);
    return Scaffold(
        body: Form(
        key: _formKey,
        child: Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(top: 160),
      padding: EdgeInsets.all(12.0),
      child: Column(
        children: [
          Text('Введите код',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 22)),
          Container(padding: EdgeInsets.only(top: 12.0)),
          Text(
              'Мы отправили СМС с проверочным кодом на Ваш телефон ${widget.phoneNumber}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey)),
          Container(padding: EdgeInsets.only(top: 12.0)),
          TextFormField(
            controller: _codeController,
            maxLines: 1,
            keyboardType: TextInputType.number,
            autofocus: false,
            decoration: InputDecoration(hintText: 'Проверочный код'),
            validator: (value) =>
                value.isEmpty ? 'Поле не может быть пустым' : null,
            onSaved: (value) => _code = value.trim(),
          ),
          Container(padding: EdgeInsets.only(top: 12.0)),
          RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: Text('Подтвердить',
                style: TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: () async {
              setState(() {
                progressVisible = true;
              });
              final code = _codeController.text.trim();
              var credential = PhoneAuthProvider.getCredential(
                  verificationId: _verificationId, smsCode: code);

              var result = await _auth.signInWithCredential(credential);

              var user = result.user;

              if (user != null) {
                final userExist = await userRepository.isUserExist();
                if (userExist) {
                  print('navigate to home');
                  await Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Home()),
                      (Route<dynamic> route) => false);
                } else {
                  await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationScreen()));
                }
              } else {
                print("Error");
              }
            },
          ),
          Container(padding: EdgeInsets.only(top: 12.0)),
          Visibility(
              visible: progressVisible,
              child: Align(
                  alignment: Alignment.center,
                  child: Wrap(children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.blue),
                    )
                  ]))),
        ],
      ),
    )));
  }

  Future<bool> loginUser(String phone, BuildContext context) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          var result = await _auth.signInWithCredential(credential);
          var user = result.user;
          if (user != null) {
            final userExist = await userRepository.isUserExist();
            if (userExist) {
              await Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Home()),
                  (Route<dynamic> route) => false);
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
          _verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: null);
  }
}
