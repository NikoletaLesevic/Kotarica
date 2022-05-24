// To parse this JSON data, do
//
//     final komentar = komentarFromJson(jsonString);

import 'dart:convert';

List<Komentar> komentarFromJson(String str) => List<Komentar>.from(json.decode(str).map((x) => Komentar.fromJson(x)));

String komentarToJson(List<Komentar> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Komentar {
  Komentar({
    this.id,
    this.idOglasa,
    this.nazivOglasa,
    this.korisnik,
    this.tekst,
  });

  String id;
  int idOglasa;
  String nazivOglasa;
  String korisnik;
  String tekst;

  factory Komentar.fromJson(Map<String, dynamic> json) => Komentar(
    id: json["id"],
    idOglasa: json["idOglasa"],
    nazivOglasa: json["nazivOglasa"],
    korisnik: json["korisnik"],
    tekst: json["tekst"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "idOglasa": idOglasa,
    "nazivOglasa": nazivOglasa,
    "korisnik": korisnik,
    "tekst": tekst,
  };
}
