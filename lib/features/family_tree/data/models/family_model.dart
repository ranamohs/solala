class FamilyTreeModel {
  bool? status;
  Message? message;
  List<FamilyMember>? data;

  FamilyTreeModel({this.status, this.message, this.data});

  FamilyTreeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message =
    json['message'] != null ? Message.fromJson(json['message']) : null;
    if (json['data'] != null) {
      data = <FamilyMember>[];
      json['data'].forEach((v) {
        data!.add(FamilyMember.fromJson(v));
      });
    }
  }
}

class Message {
  String? ar;
  String? en;

  Message({this.ar, this.en});

  Message.fromJson(Map<String, dynamic> json) {
    ar = json['ar'];
    en = json['en'];
  }
}

class FamilyMember {
  int? id;
  String? name;
  String? relation;
  String? gender;
  String? avatar;
  List<FamilyMember>? children;

  FamilyMember(
      {this.id,
        this.name,
        this.relation,
        this.gender,
        this.avatar,
        this.children});

  FamilyMember.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    relation = json['relation'];
    gender = json['gender'];
    avatar = json['avatar'];
    if (json['children'] != null) {
      children = <FamilyMember>[];
      json['children'].forEach((v) {
        children!.add(FamilyMember.fromJson(v));
      });
    }
  }
}
