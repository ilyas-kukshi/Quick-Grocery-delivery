class ProductModel {
  final String id;
  final String imageUrl;
  final String name;
  final String category;
  final String price;
  final String type;
  final String shopName;
  final String shopId;
  final bool addedToShop;
  int quantity;
  bool? available;
  String? dbProductId;

  ProductModel(
      this.id,
      this.imageUrl,
      this.name,
      this.category,
      this.price,
      this.type,
      this.shopName,
      this.shopId,
      this.addedToShop,
      this.quantity,
      this.available,
      this.dbProductId);
}

class UserProductModel {
  final String id;
  final String imageUrl;
  final String name;
  final String categoryId;
  final String category;
  final String price;
  final String type;
  final String shopName;
  final String shopId;
  bool addedToCart;
  bool? available;
  String? dbProductId;

  UserProductModel(
      this.id,
      this.imageUrl,
      this.name,
      this.categoryId,
      this.category,
      this.price,
      this.type,
      this.shopName,
      this.shopId,
      this.addedToCart,
      this.available,
      this.dbProductId);
}
