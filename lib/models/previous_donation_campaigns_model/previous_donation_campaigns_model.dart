class PreviousDonationCampaignsModel {
  int? id;
  String? title;
  int? status;

  PreviousDonationCampaignsModel({this.id, this.title, this.status});

  PreviousDonationCampaignsModel.fromJson(Map<String, dynamic> json) {
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
  static List<PreviousDonationCampaignsModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PreviousDonationCampaignsModel.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<PreviousDonationCampaignsModel> campaigns) {
    return campaigns.map((campaign) => campaign.toJson()).toList();
  }
}
