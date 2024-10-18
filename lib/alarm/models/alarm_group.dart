
class AlarmGroup {
  int? id;
  String name;

  AlarmGroup({
    this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory AlarmGroup.fromJson(Map<String, dynamic> json) {
    return AlarmGroup(
      id: json['id'],
      name: json['name'],
    );
  }
}
