class QuotationListModel {
  bool? status;
  String? message;
  List<QuotationListData>? data;

  QuotationListModel({this.status, this.message, this.data});

  QuotationListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <QuotationListData>[];
      json['data'].forEach((v) {
        data!.add(new QuotationListData.fromJson(v));
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

class QuotationListData {
  int? id;
  int? revisedFromId;
  String? quotationNumber;
  int? userId;
  int? leadId;
  String? transactionDate;
  String? validTill;
  String? quotationType;
  int? rate;
  int? advanceMonth;
  int? securityPrice;
  int? status;
  String? createdAt;
  String? updatedAt;
  Lead? lead;
  List<QuotationProducts>? quotationProducts;

  QuotationListData(
      {this.id,
      this.revisedFromId,
      this.quotationNumber,
      this.userId,
      this.leadId,
      this.transactionDate,
      this.validTill,
      this.quotationType,
      this.rate,
      this.advanceMonth,
      this.securityPrice,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.lead,
      this.quotationProducts});

  QuotationListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    revisedFromId = json['revised_from_id'];
    quotationNumber = json['quotation_number'];
    userId = json['user_id'];
    leadId = json['lead_id'];
    transactionDate = json['transaction_date'];
    validTill = json['valid_till'];
    quotationType = json['quotation_type'];
    rate = json['rate'];
    advanceMonth = json['advance_month'];
    securityPrice = json['security_price'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    lead = json['lead'] != null ? new Lead.fromJson(json['lead']) : null;
    if (json['quotation_products'] != null) {
      quotationProducts = <QuotationProducts>[];
      json['quotation_products'].forEach((v) {
        quotationProducts!.add(new QuotationProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['revised_from_id'] = this.revisedFromId;
    data['quotation_number'] = this.quotationNumber;
    data['user_id'] = this.userId;
    data['lead_id'] = this.leadId;
    data['transaction_date'] = this.transactionDate;
    data['valid_till'] = this.validTill;
    data['quotation_type'] = this.quotationType;
    data['rate'] = this.rate;
    data['advance_month'] = this.advanceMonth;
    data['security_price'] = this.securityPrice;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.lead != null) {
      data['lead'] = this.lead!.toJson();
    }
    if (this.quotationProducts != null) {
      data['quotation_products'] =
          this.quotationProducts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Lead {
  int? id;
  String? leadNumber;
  int? userId;
  String? leadName;
  String? leadType;
  String? company;
  String? phone;
  String? email;
  int? source;
  dynamic designation;
  dynamic gender;
  int? status;
  dynamic noOfProject;
  String? description;
  dynamic regionalOfc;
  dynamic referenceDetails;
  dynamic image;
  dynamic type;
  dynamic addressType;
  dynamic addressLine1;
  dynamic addressLine2;
  dynamic cityTown;
  dynamic postalCode;
  dynamic sectorLocality;
  dynamic country;
  dynamic state;
  dynamic visitingCard;
  String? latitude;
  String? longitude;
  dynamic peopleAdded;
  dynamic assignedTo;
  int? isDeleted;
  String? createdAt;
  String? updatedAt;

  Lead(
      {this.id,
      this.leadNumber,
      this.userId,
      this.leadName,
      this.leadType,
      this.company,
      this.phone,
      this.email,
      this.source,
      this.designation,
      this.gender,
      this.status,
      this.noOfProject,
      this.description,
      this.regionalOfc,
      this.referenceDetails,
      this.image,
      this.type,
      this.addressType,
      this.addressLine1,
      this.addressLine2,
      this.cityTown,
      this.postalCode,
      this.sectorLocality,
      this.country,
      this.state,
      this.visitingCard,
      this.latitude,
      this.longitude,
      this.peopleAdded,
      this.assignedTo,
      this.isDeleted,
      this.createdAt,
      this.updatedAt});

  Lead.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leadNumber = json['lead_number'];
    userId = json['user_id'];
    leadName = json['lead_name'];
    leadType = json['lead_type'];
    company = json['company'];
    phone = json['phone'];
    email = json['email'];
    source = json['source'];
    designation = json['designation'];
    gender = json['gender'];
    status = json['status'];
    noOfProject = json['no_of_project'];
    description = json['description'];
    regionalOfc = json['regional_ofc'];
    referenceDetails = json['reference_details'];
    image = json['image'];
    type = json['type'];
    addressType = json['address_type'];
    addressLine1 = json['address_line1'];
    addressLine2 = json['address_line2'];
    cityTown = json['city_town'];
    postalCode = json['postal_code'];
    sectorLocality = json['sector_locality'];
    country = json['country'];
    state = json['state'];
    visitingCard = json['visiting_card'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    peopleAdded = json['people_added'];
    assignedTo = json['assigned_to'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lead_number'] = this.leadNumber;
    data['user_id'] = this.userId;
    data['lead_name'] = this.leadName;
    data['lead_type'] = this.leadType;
    data['company'] = this.company;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['source'] = this.source;
    data['designation'] = this.designation;
    data['gender'] = this.gender;
    data['status'] = this.status;
    data['no_of_project'] = this.noOfProject;
    data['description'] = this.description;
    data['regional_ofc'] = this.regionalOfc;
    data['reference_details'] = this.referenceDetails;
    data['image'] = this.image;
    data['type'] = this.type;
    data['address_type'] = this.addressType;
    data['address_line1'] = this.addressLine1;
    data['address_line2'] = this.addressLine2;
    data['city_town'] = this.cityTown;
    data['postal_code'] = this.postalCode;
    data['sector_locality'] = this.sectorLocality;
    data['country'] = this.country;
    data['state'] = this.state;
    data['visiting_card'] = this.visitingCard;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['people_added'] = this.peopleAdded;
    data['assigned_to'] = this.assignedTo;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class QuotationProducts {
  int? id;
  int? quotationId;
  int? productId;
  int? quantity;
  dynamic priceType;
  String? quotedPrice;
  String? createdAt;
  String? updatedAt;
  Product? product;

  QuotationProducts(
      {this.id,
      this.quotationId,
      this.productId,
      this.quantity,
      this.priceType,
      this.quotedPrice,
      this.createdAt,
      this.updatedAt,
      this.product});

  QuotationProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quotationId = json['quotation_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    priceType = json['price_type'];
    quotedPrice = json['quoted_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quotation_id'] = this.quotationId;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['price_type'] = this.priceType;
    data['quoted_price'] = this.quotedPrice;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}

class Product {
  int? id;
  int? userId;
  String? name;
  String? purchasePrice;
  double? length;
  String? weight;
  dynamic diameter;
  String? rentalPrice;
  String? unit;
  String? image;
  int? status;
  int? isDeleted;
  String? createdAt;
  String? updatedAt;

  Product(
      {this.id,
      this.userId,
      this.name,
      this.purchasePrice,
      this.length,
      this.weight,
      this.diameter,
      this.rentalPrice,
      this.unit,
      this.image,
      this.status,
      this.isDeleted,
      this.createdAt,
      this.updatedAt});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    purchasePrice = json['purchase_price'];
    length = json['length'];
    weight = json['weight'];
    diameter = json['diameter'];
    rentalPrice = json['rental_price'];
    unit = json['unit'];
    image = json['image'];
    status = json['status'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['purchase_price'] = this.purchasePrice;
    data['length'] = this.length;
    data['weight'] = this.weight;
    data['diameter'] = this.diameter;
    data['rental_price'] = this.rentalPrice;
    data['unit'] = this.unit;
    data['image'] = this.image;
    data['status'] = this.status;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
