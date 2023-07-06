class UserModel {
  int? id;
  String? name;
  double? weight;
  double? height;
  double? consumptionTarget;
  static double defaultConsumptionTarget = 20;
  UserModel(
      {this.id = 0,
      this.name,
      this.weight,
      this.height,
      this.consumptionTarget});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    weight = json['weight'];
    height = json['height'];
    consumptionTarget = json['consumption_target'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['weight'] = weight;
    data['height'] = height;
    data['consumption_target'] = consumptionTarget;
    return data;
  }
}
