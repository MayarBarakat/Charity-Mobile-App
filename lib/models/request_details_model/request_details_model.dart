class RequestDetailsModel {
  String? description2;
  int? priority;

  RequestDetailsModel({this.description2, this.priority});

  RequestDetailsModel.fromJson(Map<String, dynamic> json) {
    description2 = json['description2'];
    priority = json['priority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description2'] = this.description2;
    data['priority'] = this.priority;
    return data;
  }
  static List<RequestDetailsModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => RequestDetailsModel.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<RequestDetailsModel> campaigns) {
    return campaigns.map((campaign) => campaign.toJson()).toList();
  }
}
