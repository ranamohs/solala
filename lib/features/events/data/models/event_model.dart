class EventModel {
  int? id;
  MultiLangText? type;
  MultiLangText? decription;
  MultiLangText? title;
  MultiLangText? address;
  FamilyDetails? familyDetails;
  String? eventDate;
  String? image;

  EventModel({
    this.id,
    this.type,
    this.decription,
    this.title,
    this.address,
    this.familyDetails,
    this.eventDate,
    this.image,
  });

  EventModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'] != null ? MultiLangText.fromJson(json['type']) : null;
    decription = json['decription'] != null
        ? MultiLangText.fromJson(json['decription'])
        : null;
    title =
    json['title'] != null ? MultiLangText.fromJson(json['title']) : null;
    address =
    json['address'] != null ? MultiLangText.fromJson(json['address']) : null;
    familyDetails = json['family_details'] != null
        ? FamilyDetails.fromJson(json['family_details'])
        : null;
    eventDate = json['event_date'];
    image = json['image'];
  }
}

class MultiLangText {
  String? ar;
  String? en;

  MultiLangText({this.ar, this.en});

  MultiLangText.fromJson(Map<String, dynamic> json) {
    ar = json['ar'];
    en = json['en'];
  }
}

class FamilyDetails {
  int? id;
  MultiLangText? name;
  String? code;
  String? negotiatorId;
  String? negotiator;
  String? image;

  FamilyDetails({
    this.id,
    this.name,
    this.code,
    this.negotiatorId,
    this.negotiator,
    this.image,
  });

  FamilyDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] != null ? MultiLangText.fromJson(json['name']) : null;
    code = json['code'];
    negotiatorId = json['negotiator_id'];
    negotiator = json['negotiator'];
    image = json['image'];
  }
}
