import 'package:cek_akreditasi/attributes/institusi.dart';
import 'package:cek_akreditasi/component/customDivider.dart';
import 'package:cek_akreditasi/component/institusiListItem.dart';
import 'package:cek_akreditasi/function.dart';
import 'package:cek_akreditasi/values/Env.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:simplehttpconnection/simplehttpconnection.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<InstitusiAttrb> _data = [], _pureData = [];
  ScrollController _scrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();
  bool _error = false, _loading = true;
  FocusNode _focusSearch = FocusNode();

  int _page = 1, _showTotal = 0;

  @override
  void initState() {
    _getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 80) {
        if (_page < ((_data.length / 10)).floor()) {
          _page++;
          _setTotalPage(_page);
        } else {
          setState(() {
            _showTotal = _data.length;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: _mainAppbar(context),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[sliverFilterSearch(context), sliverContentList()],
        ));
  }

  AppBar _mainAppbar(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text("Akreditasi Institusi"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          tooltip: "Segarkan",
          onPressed: () {
            _getData();
          },
        ),
        PopupMenuButton(
          icon: Icon(Icons.more_vert),
          tooltip: "Bantuan",
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text("Sumber Data"),
                value: 1,
              ),
              PopupMenuItem(
                child: Text("Tentang Aplikasi"),
                value: 2,
              ),
            ];
          },
          onSelected: (value) {
            if (value == 1) {
              MainFunction.showNDialog(
                  context: context,
                  message:
                      "Sumber data yang digunakan pada aplikasi ini didapat dari situs Banpt, sehingga dapat menjamin akurasi akreditasi yang ditampilkan.",
                  title: "Informasi Sumber Data");
            } else {
              MainFunction.showNDialog(
                  context: context,
                  message:
                      "Aplikasi ini dibuat dengan Cinta, oleh Mochamad Nizwar Syafuan",
                  title: "Informasi Tentang Aplikasi");
            }
          },
        )
      ],
    );
  }

  dynamic sliverContentList() {
    dynamic output;
    if (_loading) {
      //Dibuat kaya gini biar ga bingung
      //Ketika loading
      output = SliverToBoxAdapter(
        child: Container(
          alignment: Alignment.center,
          height: 500,
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      if (_error) {
        //Dibuat kaya gini biar ga bingung
        //Loading selesai, tetapi terjadi error
        output = SliverToBoxAdapter(
          child: Container(
            alignment: Alignment.center,
            height: 500,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: <Widget>[
                Image.asset(
                  "assets/error.png",
                  height: 200,
                ),
                Text(
                  "Gagal mendapatkan informasi",
                  style: Theme.of(context).textTheme.title,
                  textAlign: TextAlign.center,
                ),
                Divider(),
                Text(
                  "Silahkan periksa koneksi internetmu",
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        );
      } else {
        if (_showTotal == 0) {
          //Loading selesai dan tidak ada error, tapi hasil yang ditampilkan kosong
          output = SliverToBoxAdapter(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              height: 500,
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets/empty.png",
                    height: 200,
                  ),
                  Text(
                    "Tidak ada institusi yang tersedia",
                    style: Theme.of(context).textTheme.title,
                    textAlign: TextAlign.center,
                  ),
                  Divider(),
                  Text(
                    "Sepertinya institusi yang anda maksud tidak tersedia",
                    style: Theme.of(context).textTheme.subtitle,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          );
        } else {
          //Loading selesai dan tidak ada error, hasil yang ditampilkan tersedia
          output = SliverList(
            delegate:
                SliverChildListDelegate(List.generate(_showTotal, (index) {
              return InstitusiListItem(data: _data[index]);
            }, growable: true)),
          );
        }
      }
    }

    return output;
  }

  dynamic sliverFilterSearch(BuildContext context) {
    return SliverAppBar(
        floating: true,
        title: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.sort_by_alpha),
              onPressed: () {
                _sortListDialog(context);
              },
            ),
            RowDivider(),
            Expanded(
                child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              clipBehavior: Clip.antiAlias,
              child: GestureDetector(
                onTap: () {
                  _focusSearch.requestFocus();
                },
                child: Container(
                  height: 40,
                  padding: EdgeInsets.only(left: 10.0),
                  color: Colors.black.withOpacity(.2),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(color: Colors.white),
                          textInputAction: TextInputAction.search,
                          autofocus: false,
                          focusNode: _focusSearch,
                          onSubmitted: (value) => _cariData(value),
                          decoration: InputDecoration(
                              hintText: "Cari institusi...",
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(.4)),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only()),
                          cursorColor: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                        width: 40.0,
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _cariData(_searchController.text);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ))
          ],
        ));
  }

//Pembatas widget (atas) dan fungsi (bawah)

  void _cariData(String value) {
    _data.clear();
    if (value == null || value.trim() == "") {
      if (_pureData.length > 0) {
        _data.addAll(_pureData);
        _setTotalPage(1);
      } else {
        _getData();
      }
    } else {
      _pureData.forEach((item) {
        if (item.toString().toLowerCase().contains(value.toLowerCase())) {
          _data.add(item);
        }
      });
      if ((_data.length / 10).floor() == 0) {
        setState(() {
          _showTotal = _data.length;
        });
      } else {
        _setTotalPage(1);
      }
    }
    setState(() {});
  }

  void _getData() async {
    //Bersihin dulu sebelum ambil data
    setState(() {
      _loading = true;
      _setTotalPage(0);
      _searchController.text = "";
      _data.clear();
      _pureData.clear();
    });

    //Ambil data
    var resp;
    try {
      resp = await HttpConnection.doConnection(Env.endPoint);
    } catch (e) {
      resp = ResponseHttp(400, {}, null);
    }

    if (MainFunction.validasiKoneksi(resp)) {
      for (var item in resp.content.asJson()["data"]) {
        _data.add(InstitusiAttrb.fromJson(item));
      }
    } else {
      setState(() {
        _error = true;
        _loading = false;
      });
      return;
    }

    //Urut berdasarkan String institusi
    _data.sort((a, b) => a.institusi.compareTo(b.institusi));
    _pureData.addAll(_data);

    //Ubah lagi disini
    setState(() {
      _setTotalPage(1);
      _error = false;
      _loading = false;
    });
  }

  void _sortListDialog(context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return NAlertDialog(
            title: Text("Urut Berdasarkan"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: FlatButton(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.sort_by_alpha),
                        RowDivider(),
                        Text("Nama institusi")
                      ],
                    ),
                    onPressed: () {
                      //Urut berdasarkan String institusi
                      _data.sort((a, b) => a.institusi.compareTo(b.institusi));
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: FlatButton(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.sort_by_alpha),
                        RowDivider(),
                        Text("Peringkat institusi")
                      ],
                    ),
                    onPressed: () {
                      //Urut berdasarkan String peringkat
                      _data.sort((a, b) => a.peringkat.compareTo(b.peringkat));
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          );
        });
    if (((_data.length / 10)).floor() > 0) {
      _setTotalPage(1);
    } else {
      setState(() {
        _showTotal = _data.length;
      });
    }
  }

  void _setTotalPage(int page) {
    this._page = page;
    _showTotal = page * 10;
    setState(() {});
  }

  @override
  void dispose() {
    _focusSearch.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
