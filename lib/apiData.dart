// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Reports reports;

  Welcome({
    this.reports,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        reports: Reports.fromJson(json["feed"]),
      );

  Map<String, dynamic> toJson() => {
        "reports": reports.toJson(),
      };
}

class Reports {
  List<Entry> entry;

  Reports({
    this.entry,
  });

  factory Reports.fromJson(Map<String, dynamic> json) => Reports(
        entry: List<Entry>.from(json["entry"].map((x) => Entry.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "entry": List<dynamic>.from(entry.map((x) => x.toJson())),
      };
}

class Entry {
  GeorssPoint title;
  GeorssPoint updated;
  Link link;

  Entry({
    this.title,
    this.updated,
    this.link,
  });

  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
        title: GeorssPoint.fromJson(json["title"]),
        updated: GeorssPoint.fromJson(json["updated"]),
        link: Link.fromJson(json["link"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title.toJson(),
        "updated": updated.toJson(),
        "link": link.toJson(),
      };
}

class GeorssPoint {
  String t;

  GeorssPoint({
    this.t,
  });

  factory GeorssPoint.fromJson(Map<String, dynamic> json) => GeorssPoint(
        t: json["\u0024t"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024t": t,
      };
}

class Link {
  String rel;
  String href;

  Link({
    this.rel,
    this.href,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        rel: json["rel"],
        href: json["href"],
      );

  Map<String, dynamic> toJson() => {
        "rel": rel,
        "href": href,
      };
}
