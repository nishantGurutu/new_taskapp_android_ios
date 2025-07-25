class ExpenseTypeListModel {
  bool? status;
  String? message;
  List<ExpenseListData>? data;

  ExpenseTypeListModel({this.status, this.message, this.data});

  ExpenseTypeListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ExpenseListData>[];
      json['data'].forEach((v) {
        data!.add(new ExpenseListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ExpenseListData {
  int? id;
  String? name;
  int? status;
  String? createdAt;
  String? updatedAt;

  ExpenseListData(
      {this.id, this.name, this.status, this.createdAt, this.updatedAt});

  ExpenseListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
