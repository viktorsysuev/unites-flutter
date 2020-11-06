import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NetworkConnection {
  BuildContext context;

  NetworkConnection({@required this.context});

  bool networkConnection;
  Connectivity _connectivity;
  StreamSubscription<ConnectivityResult> _subscription;
  final lostConnectionSnackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Устанавливаем соединение',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: SizedBox(
              child: CircularProgressIndicator(strokeWidth: 2.0),
              height: 12.0,
              width: 12.0,
            ),
          )
        ],
      ),
      duration: Duration(hours: 1));

  final returnConnectionSnackBar = SnackBar(
      backgroundColor: Colors.green,
      content: Text("Соединение установлено!",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 12)),
      duration: Duration(seconds: 2));

  checkConnect() async {
    _connectivity = new Connectivity();
    _subscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          print("result $result");
      if (result == ConnectivityResult.none) {
        Scaffold.of(context).showSnackBar(lostConnectionSnackBar);
        networkConnection = false;
        print('NO INTERNET');
      } else {
        if(networkConnection != null) {
          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context).showSnackBar(returnConnectionSnackBar);
        }
        networkConnection = true;
        print('INTERNET IS TURNED ON');
      }
    });
  }

  getConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      networkConnection = false;
      // Fluttertoast.showToast(
      //   msg: captions["connect_off"],
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.BOTTOM,
      // );
    } else {
      networkConnection = true;
    }
  }

  void dispose() {
    _subscription.cancel();
  }
}
