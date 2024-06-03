import 'dart:io';

class Advert {
  String? status;
  String? image;
  String? description;
  String? category;
  String? advertiserName;
  String? advertiserId;
  String? advertTitle;
  String? icon;
  double? latitude;
  double? longitude;
  double? price;
  bool? isFree;
  String? advertId;
  File? imageAsFile;

  Advert(
      {this.status,
      this.image,
      this.description,
      this.category,
      this.advertiserName,
      this.advertiserId,
      this.advertTitle,
      this.icon,
      this.latitude,
      this.longitude,
      this.isFree,
      this.price,
      this.advertId,
      this.imageAsFile});

  Advert.fromJson(Map<String, dynamic> json) {
    advertId = json['advertId'];
    status = json['status'];
    image = json['image'];
    description = json['description'];
    category = json['category'];
    advertiserName = json['advertiserName'];
    advertiserId = json['advertiserId'];
    advertTitle = json['advertTitle'];
    icon = json['icon'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    price = json['price'] != null ? json['price'].toDouble() : null;
    isFree = json['isFree'];
  }

  Map<String, dynamic> toJson(Advert advert) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = advert.status;
    data['image'] = advert.image;
    data['description'] = advert.description;
    data['category'] = advert.category;
    data['advertiserName'] = advert.advertiserName;
    data['advertiserId'] = advert.advertiserId;
    data['advertTitle'] = advert.advertTitle;
    data['icon'] = advert.icon;
    data['latitude'] = advert.latitude;
    data['longitude'] = advert.longitude;
    data['isFree'] = advert.isFree;
    data['price'] = advert.price;

    return data;
  }
}
