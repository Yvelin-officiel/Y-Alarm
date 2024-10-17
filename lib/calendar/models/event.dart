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

  factory Event.fromIcs(String ics) {
    List<String> lines = ics.split('\n');
    String categories = '';
    DateTime dtstamp = DateTime.now();
    DateTime lastModified = DateTime.now();
    String uid = '';
    DateTime dtstart = DateTime.now();
    DateTime dtend = DateTime.now();
    String summary = '';

    for (String line in lines) {
      if (line.startsWith('CATEGORIES:')) {
        categories = line.substring(11);
      } else if (line.startsWith('DTSTAMP:')) {
        String data = line.substring(8);
        dtstamp = DateTime(
          int.parse(data.substring(0, 4)),
          int.parse(data.substring(4, 6)),
          int.parse(data.substring(6, 8)),
          int.parse(data.substring(9, 11)),
          int.parse(data.substring(11, 13)),
          int.parse(data.substring(13, 15)),
        );
      } else if (line.startsWith('LAST-MODIFIED:')) {
        String data = line.substring(14);
        lastModified = DateTime(
          int.parse(data.substring(0, 4)),
          int.parse(data.substring(4, 6)),
          int.parse(data.substring(6, 8)),
          int.parse(data.substring(9, 11)),
          int.parse(data.substring(11, 13)),
          int.parse(data.substring(13, 15)),
        );
      } else if (line.startsWith('UID:')) {
        uid = line.substring(4);
      } else if (line.startsWith('DTSTART')) {
        String data = line.substring(7);
        if (data.startsWith(':')) {
          data = data.substring(1);
          dtstart = DateTime(
            int.parse(data.substring(0, 4)),
            int.parse(data.substring(4, 6)),
            int.parse(data.substring(6, 8)),
            int.parse(data.substring(9, 11)),
            int.parse(data.substring(11, 13)),
            int.parse(data.substring(13, 15)),
          );
        } else if (data.startsWith(';VALUE=DATE:')) {
          data = data.substring(12);
          dtstart = DateTime(
            int.parse(data.substring(0, 4)),
            int.parse(data.substring(4, 6)),
            int.parse(data.substring(6, 8)),
          );
        }
      } else if (line.startsWith('DTEND')) {
        String data = line.substring(5);
        if (data.startsWith(':')) {
          data = data.substring(1);
          dtend = DateTime(
            int.parse(data.substring(0, 4)),
            int.parse(data.substring(4, 6)),
            int.parse(data.substring(6, 8)),
            int.parse(data.substring(9, 11)),
            int.parse(data.substring(11, 13)),
            int.parse(data.substring(13, 15)),
          );
        } else if (data.startsWith(';VALUE=DATE:')) {
          data = data.substring(12);
          dtend = DateTime(
            int.parse(data.substring(0, 4)),
            int.parse(data.substring(4, 6)),
            int.parse(data.substring(6, 8)),
          );
        }
      } else if (line.startsWith('SUMMARY;LANGUAGE=fr:')) {
        summary = line.substring(20);
      }
    }

    return Event(
      categories: categories,
      dtstamp: dtstamp,
      lastModified: lastModified,
      uid: uid,
      dtstart: dtstart,
      dtend: dtend,
      summary: summary,
    );
  }
}