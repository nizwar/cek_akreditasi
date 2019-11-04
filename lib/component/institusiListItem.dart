import 'package:cek_akreditasi/attributes/institusi.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';

class InstitusiListItem extends StatelessWidget {
  const InstitusiListItem({
    Key key,
    @required this.data,
  }) : super(key: key);

  final InstitusiAttrb data;

  @override
  Widget build(BuildContext context) {
    Color warnaAkreditasi = Colors.green;
    switch (data.peringkat.toUpperCase()) {
      case "A":
        warnaAkreditasi = Colors.green;
        break;
      case "B":
        warnaAkreditasi = Colors.green;
        break;
      case "C":
        warnaAkreditasi = Colors.yellow;
        break;
      case "D":
        warnaAkreditasi = Colors.red;
        break;
      default:
        warnaAkreditasi = Colors.grey;
    }
    return Card(
      child: ListTile(
        onTap: () async {
          TextStyle title = TextStyle(color: Colors.grey, fontSize: 12);
          await showDialog(
              context: context,
              builder: (context) {
                return NAlertDialog(
                  title: Text("Informasi Institusi"),
                  actions: <Widget>[
                    FlatButton(
                        child: Text("Tutup"),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Nama Institusi",
                        style: title,
                      ),
                      Text(data.institusi),
                      Divider(),
                      Text(
                        "No SK",
                        style: title,
                      ),
                      Text(data.noSk),
                      Divider(),
                      Text(
                        "Peringkat Institusi",
                        style: title,
                      ),
                      Text(data.peringkat),
                      Divider(),
                      Text(
                        "Tahun SK - Kadaluarsa",
                        style: title,
                      ),
                      Text(data.tahunSK + " - " + data.tglKadaluarsa),
                      Divider(),
                      Text(
                        "Status Kadaluarsa",
                        style: title,
                      ),
                      Text(
                        data.status,
                      ),
                      Divider(),
                    ],
                  ),
                );
              });
        },
        leading: CircleAvatar(
          backgroundColor: warnaAkreditasi,
          child: Text(
            data.peringkat,
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          data.institusi,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(data.noSk),
      ),
    );
  }
}
