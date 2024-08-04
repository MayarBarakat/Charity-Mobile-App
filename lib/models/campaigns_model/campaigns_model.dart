class CampaignsModel {
  int? id;
  String? title;
  String? imageUrl;

  CampaignsModel({this.id, this.title, this.imageUrl});

  CampaignsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['imageUrl'] = imageUrl;
    return data;
  }
  static List<CampaignsModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => CampaignsModel.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<CampaignsModel> campaigns) {
    return campaigns.map((campaign) => campaign.toJson()).toList();
  }
}
