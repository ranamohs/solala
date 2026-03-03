class FamilyTreeModel {
  bool? status;
  Message? message;
  List<FamilyMember>? data;
  Links? links;
  Meta? meta;

  FamilyTreeModel({this.status, this.message, this.data, this.links, this.meta});

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
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
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
  String? birthDate;
  String? birthPlace;
  int? isLive;
  String? phone;
  String? job;
  List<FamilyMember>? children;

  FamilyMember({
    this.id,
    this.name,
    this.relation,
    this.gender,
    this.avatar,
    this.birthDate,
    this.birthPlace,
    this.isLive,
    this.phone,
    this.job,
    this.children,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FamilyMember && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  FamilyMember.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    relation = json['relation'];
    gender = json['gender'];
    avatar = json['avatar'];
    birthDate = json['birth_date'];
    birthPlace = json['birth_place'];
    if (json['is_live'] is bool) {
      isLive = json['is_live'] ? 1 : 0;
    } else {
      isLive = json['is_live'];
    }
    phone = json['phone'];
    job = json['job'];
    if (json['children'] != null) {
      children = <FamilyMember>[];
      json['children'].forEach((v) {
        children!.add(FamilyMember.fromJson(v));
      });
    }
  }
}

class Links {
  String? first;
  String? last;
  String? prev;
  String? next;

  Links({this.first, this.last, this.prev, this.next});

  Links.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    prev = json['prev'];
    next = json['next'];
  }
}

class Meta {
  int? currentPage;
  int? from;
  int? lastPage;
  List<MetaLink>? links;
  String? path;
  int? perPage;
  int? to;
  int? total;

  Meta(
      {this.currentPage,
        this.from,
        this.lastPage,
        this.links,
        this.path,
        this.perPage,
        this.to,
        this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    if (json['links'] != null) {
      links = <MetaLink>[];
      json['links'].forEach((v) {
        links!.add(MetaLink.fromJson(v));
      });
    }
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }
}

class MetaLink {
  String? url;
  String? label;
  bool? active;

  MetaLink({this.url, this.label, this.active});

  MetaLink.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }
}
