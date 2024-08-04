class PreviousRequestsModel {
  int? id;
  String? description1;
  int? status;

  PreviousRequestsModel({this.id, this.description1, this.status});

  PreviousRequestsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description1 = json['description1'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['description1'] = description1;
    data['status'] = status;
    return data;
  }
  static List<PreviousRequestsModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PreviousRequestsModel.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<PreviousRequestsModel> campaigns) {
    return campaigns.map((campaign) => campaign.toJson()).toList();
  }
}
