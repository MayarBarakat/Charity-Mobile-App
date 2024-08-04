class AboutUsModel {
  String? imageUrl;
  String? text1;
  String? text2;
  String? text3;
  String? text4;
  String? text5;
  String? contactUs;

  AboutUsModel(
      {this.imageUrl,
        this.text1,
        this.text2,
        this.text3,
        this.text4,
        this.text5,
        this.contactUs});

  AboutUsModel.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
    text1 = json['text1'];
    text2 = json['text2'];
    text3 = json['text3'];
    text4 = json['text4'];
    text5 = json['text5'];
    contactUs = json['contactUs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageUrl'] = this.imageUrl;
    data['text1'] = this.text1;
    data['text2'] = this.text2;
    data['text3'] = this.text3;
    data['text4'] = this.text4;
    data['text5'] = this.text5;
    data['contactUs'] = this.contactUs;
    return data;
  }
  static List<AboutUsModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => AboutUsModel.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<AboutUsModel> campaigns) {
    return campaigns.map((campaign) => campaign.toJson()).toList();
  }
}
