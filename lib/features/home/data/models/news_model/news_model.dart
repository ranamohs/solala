import 'dart:io';

import 'package:dio/dio.dart';

class NewsModel {
  bool? status;
  Message? message;
  List<ReportData>? data;
  Links? links;
  Meta? meta;

  NewsModel({this.status, this.message, this.data, this.links, this.meta});

  NewsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message =
    json['message'] != null ? Message.fromJson(json['message']) : null;
    if (json['data'] != null) {
      data = <ReportData>[];
      json['data'].forEach((v) {
        data!.add(ReportData.fromJson(v));
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

class ReportData {
  int? id;
  Description? description;
  Title? title;
  FamilyDetails? familyDetails;
  String? image;

  ReportData(
      {this.id, this.description, this.title, this.familyDetails, this.image});

  ReportData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'] != null
        ? Description.fromJson(json['description'])
        : null;
    title = json['title'] != null ? Title.fromJson(json['title']) : null;
    familyDetails = json['family_details'] != null
        ? FamilyDetails.fromJson(json['family_details'])
        : null;
    image = json['image'];
  }
}

class Description {
  String? ar;
  String? en;

  Description({this.ar, this.en});

  Description.fromJson(Map<String, dynamic> json) {
    ar = json['ar'];
    en = json['en'];
  }
}

class Title {
  String? ar;
  String? en;

  Title({this.ar, this.en});

  Title.fromJson(Map<String, dynamic> json) {
    ar = json['ar'];
    en = json['en'];
  }
}

class FamilyDetails {
  int? id;
  Name? name;
  String? code;
  String? negotiatorId;
  String? negotiator;
  String? image;

  FamilyDetails(
      {this.id,
        this.name,
        this.code,
        this.negotiatorId,
        this.negotiator,
        this.image});

  FamilyDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] != null ? Name.fromJson(json['name']) : null;
    code = json['code'];
    negotiatorId = json['negotiator_id'];
    negotiator = json['negotiator'];
    image = json['image'];
  }
}

class Name {
  String? ar;
  String? en;

  Name({this.ar, this.en});

  Name.fromJson(Map<String, dynamic> json) {
    ar = json['ar'];
    en = json['en'];
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

class NewsDetailsModel {
  bool? status;
  Message? message;
  ReportData? data;

  NewsDetailsModel({this.status, this.message, this.data});

  NewsDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message =
    json['message'] != null ? Message.fromJson(json['message']) : null;
    data = json['data'] != null ? ReportData.fromJson(json['data']) : null;
  }


}





class CreateNewsRequestModel {
  final String titleAr;
  final String titleEn;
  final String descriptionAr;
  final String descriptionEn;
  final File? image;

  CreateNewsRequestModel({
    required this.titleAr,
    required this.titleEn,
    required this.descriptionAr,
    required this.descriptionEn,
    this.image,
  });

  Future<Map<String, dynamic>> toJson() async {
    final Map<String, dynamic> data = {
      'title[ar]': titleAr,
      'title[en]': titleEn,
      'description[ar]': descriptionAr,
      'description[en]': descriptionEn,
    };
    if (image != null) {
      data['image'] = await MultipartFile.fromFile(image!.path);
    }
    return data;
  }
}
