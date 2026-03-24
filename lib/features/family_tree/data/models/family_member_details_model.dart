class FamilyMemberDetailsModel {
  final int? id;
  final String? name;
  final String? relation;
  final String? gender;
  final String? birthDate;
  final String? birthPlace;
  final bool? isLive;
  final String? phone;
  final String? job;
  final String? description;
  final String? avatar;

  FamilyMemberDetailsModel({
    this.id,
    this.name,
    this.relation,
    this.gender,
    this.birthDate,
    this.birthPlace,
    this.isLive,
    this.phone,
    this.job,
    this.description,
    this.avatar,
  });

  factory FamilyMemberDetailsModel.fromJson(Map<String, dynamic> json) {
    return FamilyMemberDetailsModel(
      id: json['id'],
      name: json['name'],
      relation: json['relation'],
      gender: json['gender'],
      birthDate: json['birth_date'],
      birthPlace: json['birth_place'],
      isLive: json['is_live'],
      phone: json['phone'],
      job: json['job'],
      description: json['description'],
      avatar: json['avatar'],
    );
  }
}
