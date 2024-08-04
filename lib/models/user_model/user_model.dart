class UserModel {
  String? idKey;
  String? name;
  String? email;
  String? number;
  String? address;
  String? date;

  UserModel(
      {this.idKey,
        this.name,
        this.email,
        this.number,
        this.address,
        this.date});

  UserModel.fromJson(Map<String, dynamic> json) {
    idKey = json['idKey'];
    name = json['name'];
    email = json['email'];
    number = json['number'];
    address = json['address'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idKey'] = this.idKey;
    data['name'] = this.name;
    data['email'] = this.email;
    data['number'] = this.number;
    data['address'] = this.address;
    data['date'] = this.date;
    return data;
  }
  static List<UserModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => UserModel.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<UserModel> campaigns) {
    return campaigns.map((campaign) => campaign.toJson()).toList();
  }
}
