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
    return new Scaffold(
        body: Stack(
          children: <Widget>[
            _showForm(),
          ],
        ));
  }

  Widget showPhoneInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        controller: _phoneController,
        maxLines: 1,
        keyboardType: TextInputType.phone,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Телефон',
            icon: new Icon(
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
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text('Отправить',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: (){
              final phone = _phoneController.text.trim();
              loginUser(phone, context);
            },
          ),
        ));
  }


  Widget _showForm() {
    return new Container(
        margin: const EdgeInsets.only(top: 140.0),
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showPhoneInput(),
              showButton(),
            ],
          ),
        ));
  }


  Future<bool> loginUser(String phone, BuildContext context) async{
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async{
          Navigator.of(context).pop();

          AuthResult result = await _auth.signInWithCredential(credential);

          FirebaseUser user = result.user;

          if(user != null){
            final userExist = await userRepository.isUserExist();
            if(userExist) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Home()
              ));
            } else {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => RegistrationScreen()
              ));
            }
          }else{
            print("Error");
          }

        },
        verificationFailed: (AuthException exception){
          print(exception.message);
        },

        codeSent: (String verificationId, [int forceResendingToken]){
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Получили код?"),
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
                      child: Text("Подтвердить"),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () async{
                        final code = _codeController.text.trim();
                        AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: code);

                        AuthResult result = await _auth.signInWithCredential(credential);

                        FirebaseUser user = result.user;

                        if(user != null){
                          final userExist = await userRepository.isUserExist();
                          if(userExist) {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => Home()
                            ));
                          } else {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => RegistrationScreen()
                            ));
                          }
                        }else{
                          print("Error");
                        }
                      },
                    )
                  ],
                );
              }
          );
        },
        codeAutoRetrievalTimeout: null
    );
  }
}
