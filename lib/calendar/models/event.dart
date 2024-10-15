class Event {

  int? id;
  String categories;
  DateTime dtstamp;
  DateTime lastModified;
  String uid;
  DateTime dtstart;
  DateTime dtend;
  String summary;

  Event({
    this.id,
    required this.categories,
    required this.dtstamp,
    required this.lastModified,
    required this.uid,
    required this.dtstart,
    required this.dtend,
    required this.summary,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categories': categories,
      'dtstamp': dtstamp.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'uid': uid,
      'dtstart': dtstart.toIso8601String(),
      'dtend': dtend.toIso8601String(),
      'summary': summary,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      categories: json['categories'],
      dtstamp: DateTime.parse(json['dtstamp']),
      lastModified: DateTime.parse(json['lastModified']),
      uid: json['uid'],
      dtstart: DateTime.parse(json['dtstart']),
      dtend: DateTime.parse(json['dtend']),
      summary: json['summary'],
    );
  }
}