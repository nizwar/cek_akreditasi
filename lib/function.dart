import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:simplehttpconnection/simplehttpconnection.dart';

class MainFunction {
  static bool validasiKoneksi(ResponseHttp resp) {
    if (resp.statusCode >= 200 && resp.statusCode < 400) {
      if (resp.content.asJson() != null) {
        return true;
      }
    }
    return false;
  }

  static Future showNDialog({context, String title, String message}) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return NAlertDialog(
            actions: <Widget>[
              FlatButton(
                child: Text("Tutup"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
            content: Text(message ?? ""),
            title: Text(title ?? ""),
          );
        });
  }
}
