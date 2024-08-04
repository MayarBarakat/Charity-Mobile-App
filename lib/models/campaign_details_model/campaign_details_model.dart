class CampaignDetailsModel {
  int? budget;
  String? targetGroup;
  String? reason;
  String? description;

  CampaignDetailsModel(
      {this.budget, this.targetGroup, this.reason, this.description});

  CampaignDetailsModel.fromJson(Map<String, dynamic> json) {
    budget = json['budget'];
    targetGroup = json['targetGroup'];
    reason = json['reason'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['budget'] = budget;
    data['targetGroup'] = targetGroup;
    data['reason'] = reason;
    data['description'] = description;
    return data;
  }
  static List<CampaignDetailsModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => CampaignDetailsModel.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<CampaignDetailsModel> campaigns) {
    return campaigns.map((campaign) => campaign.toJson()).toList();
  }
}
