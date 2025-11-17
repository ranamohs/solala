class FamilyModel {
  final int id;
  final String name;

  FamilyModel({required this.id, required this.name});

  factory FamilyModel.fromJson(Map<String, dynamic> json) {
    return FamilyModel(
      id: json['id'],
      name: json['name']['ar'],
    );
  }
}
