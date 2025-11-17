import '../../../../../core/constants/end_points.dart';

class CategoriesModel {
  final List<CategoryData> data;
  final LinksModel links;
  final Meta meta;

  CategoriesModel({
    required this.data,
    required this.links,
    required this.meta,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      data: List<CategoryData>.from(
        json[ApiKey.data].map((x) => CategoryData.fromJson(x)),
      ),
      links: LinksModel.fromJson(json[ApiKey.links]),
      meta: Meta.fromJson(json[ApiKey.meta]),
    );
  }
}

class CategoryData {
  final int id;
  final CategoryName name;
  final String? image;

  CategoryData({
    required this.id,
    required this.name,
    this.image,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      id: json[ApiKey.id],
      name: CategoryName.fromJson(json[ApiKey.name]),
      image: json[ApiKey.image],
    );
  }
}

class CategoryName {
  final String ar;
  final String en;

  CategoryName({
    required this.ar,
    required this.en,
  });

  factory CategoryName.fromJson(Map<String, dynamic> json) {
    return CategoryName(
      ar: json[ApiKey.ar],
      en: json[ApiKey.en],
    );
  }
}

class LinksModel {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  LinksModel({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  factory LinksModel.fromJson(Map<String, dynamic> json) {
    return LinksModel(
      first: json[ApiKey.first],
      last: json[ApiKey.last],
      prev: json[ApiKey.prev],
      next: json[ApiKey.next],
    );
  }
}

class Meta {
  final int currentPage;
  final int? from;
  final int lastPage;
  final List<MetaLink> links;
  final String path;
  final int perPage;
  final int? to;
  final int total;

  Meta({
    required this.currentPage,
    this.from,
    required this.lastPage,
    required this.links,
    required this.path,
    required this.perPage,
    this.to,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: json[ApiKey.currentPage],
      from: json[ApiKey.from],
      lastPage: json[ApiKey.lastPage],
      links: List<MetaLink>.from(
        json[ApiKey.links].map((x) => MetaLink.fromJson(x)),
      ),
      path: json[ApiKey.path],
      perPage: json[ApiKey.perPage],
      to: json[ApiKey.to],
      total: json[ApiKey.total],
    );
  }
}

class MetaLink {
  final String? url;
  final String label;
  final bool active;

  MetaLink({
    this.url,
    required this.label,
    required this.active,
  });

  factory MetaLink.fromJson(Map<String, dynamic> json) {
    return MetaLink(
      url: json[ApiKey.url],
      label: json[ApiKey.label],
      active: json['active'],
    );
  }
}
