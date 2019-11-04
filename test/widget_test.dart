import 'package:cek_akreditasi/attributes/institusi.dart';
import 'package:cek_akreditasi/function.dart';
import 'package:cek_akreditasi/values/Env.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simplehttpconnection/simplehttpconnection.dart';

main() {
  test('Get Akreditasi', () async {
    var resp = await HttpConnection.doConnection(Env.endPoint);
    if (MainFunction.validasiKoneksi(resp)) {
      InstitusiAttrb itAttrb =
          InstitusiAttrb.fromJson(resp.content.asJson()["data"][1]);

      print(itAttrb);
    }
  });
}
