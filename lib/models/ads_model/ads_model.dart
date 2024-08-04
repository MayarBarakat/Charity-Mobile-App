class AdsModel {
  int? id;
  String? title;
  String? description;
  String? imageUrl;

  AdsModel({this.id, this.title, this.description, this.imageUrl});

  AdsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['imageUrl'] = imageUrl;
    return data;
  }
  static List<AdsModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => AdsModel.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<AdsModel> campaigns) {
    return campaigns.map((campaign) => campaign.toJson()).toList();
  }
}
