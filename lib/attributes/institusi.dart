class InstitusiAttrb {
  String institusi;
  String peringkat;
  String noSk;
  String tahunSK;
  String wilayah;
  String tglKadaluarsa;
  String status;

  InstitusiAttrb(
      {this.institusi,
      this.peringkat,
      this.noSk,
      this.tahunSK,
      this.wilayah,
      this.tglKadaluarsa,
      this.status});

  factory InstitusiAttrb.fromJson(dynamic arrJson) {
    return InstitusiAttrb(
        institusi: arrJson[0] ?? "Tidak diketahui",
        peringkat: arrJson[1] ?? "Tidak diketahui",
        noSk: arrJson[2] ?? "Tidak diketahui",
        tahunSK: arrJson[3] ?? "Tidak diketahui",
        wilayah: arrJson[4] ?? "Tidak diketahui",
        tglKadaluarsa: arrJson[5] ?? "Tidak diketahui",
        status: arrJson[6] ?? "Tidak diketahui");
  }

  Map<String, dynamic> toJson() => {
        "institusi": institusi,
        "peringkat": peringkat,
        "no_sk": noSk,
        "tahun_sk": tahunSK,
        "wilayah": wilayah,
        "tanggal_kadaluarsa": tglKadaluarsa,
        "status": status
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
