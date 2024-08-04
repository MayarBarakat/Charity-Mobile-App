class RequestsModel {
  int? id;
  String? title;

  RequestsModel({this.id, this.title});

  RequestsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
  static List<RequestsModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => RequestsModel.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<RequestsModel> campaigns) {
    return campaigns.map((campaign) => campaign.toJson()).toList();
  }
}
