class Product {
  int? id;
  String? name;
  int? wholesalePrice;
  int? retailPrice;

  Product({this.id, this.name, this.wholesalePrice, this.retailPrice});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    wholesalePrice = json['wholesale_price'];
    retailPrice = json['retail_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['wholesale_price'] = this.wholesalePrice;
    data['retail_price'] = this.retailPrice;
    return data;
  }
}

class Sale {
  int? id;
  String? name;
  double? pricePerProduct;
  double? totalPrice;
  int? quantity;
  String? date;

  Sale(
      {this.id,
      this.name,
      this.pricePerProduct,
      this.totalPrice,
      this.quantity,
      this.date});

  Sale.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pricePerProduct = json['price_per_product'];
    totalPrice = json['total_price'];
    quantity = json['quantity'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price_per_product'] = this.pricePerProduct;
    data['total_price'] = this.totalPrice;
    data['quantity'] = this.quantity;
    data['date'] = this.date;
    return data;
  }
}
