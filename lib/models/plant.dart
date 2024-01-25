class Plant {
  int? id;
  late String name;
  late String type;
  late String description;
  late String imgURL;
  late String actualName;
  late DateTime datePlanted;

  Plant({
    this.id, // Accept nullable id in the constructor
    required this.name,
    required this.type,
    required this.description,
    required this.imgURL,
    required this.actualName,
    required this.datePlanted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'imgURL': imgURL,
      'actualName': actualName,
      'datePlanted': datePlanted.toLocal().toString().split(' ')[0],
    };
  }

  Plant.fromMap(Map<String, dynamic> map) {
    id = map['id'] as int?;
    name = map['name']!;
    type = map['type']!;
    description = map['description']!;
    imgURL = map['imgURL']!;
    actualName = map['actualName']!;
    datePlanted = DateTime.parse(map['datePlanted']!);
  }
}
