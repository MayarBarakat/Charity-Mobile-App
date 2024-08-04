class PreviousDonationRequestsModel {
  int? id;
  String? title;
  int? status;

  PreviousDonationRequestsModel({this.id, this.title, this.status});

  PreviousDonationRequestsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['status'] = this.status;
    return data;
  }
  static List<PreviousDonationRequestsModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PreviousDonationRequestsModel.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<PreviousDonationRequestsModel> campaigns) {
    return campaigns.map((campaign) => campaign.toJson()).toList();
  }
}
