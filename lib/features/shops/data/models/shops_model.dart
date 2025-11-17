import 'package:solala/core/constants/end_points.dart';

class ShopsModel {
  final List<ShopData> data;
  final Links links;
  final Meta meta;

  ShopsModel({
    required this.data,
    required this.links,
    required this.meta,
  });

  factory ShopsModel.fromJson(Map<String, dynamic> json) {
    return ShopsModel(
      data: List<ShopData>.from(
        json[ApiKey.data].map((x) => ShopData.fromJson(x)),
      ),
      links: Links.fromJson(json[ApiKey.links]),
      meta: Meta.fromJson(json[ApiKey.meta]),
    );
  }
}

class ShopData {
  final int id;
  final LocalizedText name;
  final LocalizedText description;
  final Category category;
  final String phone;
  final String image;
  final List<GalleryItem> gallery;
  final double latitude;
  final double longitude;
  final String address;
  final String offWorking;
  final String onWorkingHourse;
  final String onWorkingDay;
  final List<Service> services;
  final bool isInWishlist;

  ShopData({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.phone,
    required this.image,
    required this.gallery,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.offWorking,
    required this.onWorkingHourse,
    required this.onWorkingDay,
    required this.services,
    required this.isInWishlist,
  });

  factory ShopData.fromJson(Map<String, dynamic> json) {
    return ShopData(
      id: json['id'],
      name: LocalizedText.fromJson(json['name']),
      description: LocalizedText.fromJson(json['description']),
      category: Category.fromJson(json['category']),
      phone: json['phone'],
      image: json['image'],
      gallery: List<GalleryItem>.from(
        json['gallery'].map((x) => GalleryItem.fromJson(x)),
      ),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'],
      offWorking: json['off_working'],
      onWorkingHourse: json['on_working_hourse'],
      onWorkingDay: json['on_working_day'],
      services: json['services'] != null
          ? List<Service>.from(
        json['services'].map((x) => Service.fromJson(x)),
      )
          : [],
      isInWishlist: json['is_favorite'] ?? false,
    );
  }

  ShopData copyWith({
    int? id,
    LocalizedText? name,
    LocalizedText? description,
    Category? category,
    String? phone,
    String? image,
    List<GalleryItem>? gallery,
    double? latitude,
    double? longitude,
    String? address,
    String? offWorking,
    String? onWorkingHourse,
    String? onWorkingDay,
    List<Service>? services,
    bool? isInWishlist,
  }) {
    return ShopData(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      gallery: gallery ?? this.gallery,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      offWorking: offWorking ?? this.offWorking,
      onWorkingHourse: onWorkingHourse ?? this.onWorkingHourse,
      onWorkingDay: onWorkingDay ?? this.onWorkingDay,
      services: services ?? this.services,
      isInWishlist: isInWishlist ?? this.isInWishlist,
    );
  }
}

class LocalizedText {
  final String ar;
  final String en;

  LocalizedText({
    required this.ar,
    required this.en,
  });

  factory LocalizedText.fromJson(Map<String, dynamic> json) {
    return LocalizedText(
      ar: json[ApiKey.ar],
      en: json[ApiKey.en],
    );
  }
}

class GalleryItem {
  final int id;
  final String? url;
  final String? name;

  GalleryItem({
    required this.id,
    this.url,
    this.name,
  });

  factory GalleryItem.fromJson(Map<String, dynamic> json) {
    return GalleryItem(
      id: json[ApiKey.id],
      url: json[ApiKey.url],
      name: json[ApiKey.name],
    );
  }
}

class Service {
  final int id;
  final String name;
  final int shopId;

  Service({
    required this.id,
    required this.name,
    required this.shopId,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      shopId: json['shop_id'],
    );
  }
}

class Category {
  final int id;
  final LocalizedText name;
  final String? image;

  Category({
    required this.id,
    required this.name,
    this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json[ApiKey.id],
      name: LocalizedText.fromJson(json[ApiKey.name]),
      image: json[ApiKey.image],
    );
  }
}

class Links {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  Links({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
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
  final List<PageLink> links;
  final String path;
  final int perPage;
  final int? to;
  final int? total;

  Meta({
    required this.currentPage,
    this.from,
    required this.lastPage,
    required this.links,
    required this.path,
    required this.perPage,
    this.to,
    this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: json[ApiKey.currentPage],
      from: json[ApiKey.from],
      lastPage: json[ApiKey.lastPage],
      links: List<PageLink>.from(
        json[ApiKey.links].map((x) => PageLink.fromJson(x)),
      ),
      path: json[ApiKey.path],
      perPage: json[ApiKey.perPage],
      to: json[ApiKey.to],
      total: json[ApiKey.total],
    );
  }
}

class PageLink {
  final String? url;
  final String label;
  final bool active;

  PageLink({
    this.url,
    required this.label,
    required this.active,
  });

  factory PageLink.fromJson(Map<String, dynamic> json) {
    return PageLink(
      url: json[ApiKey.url],
      label: json[ApiKey.label],
      active: json[ApiKey.active],
    );
  }
}
