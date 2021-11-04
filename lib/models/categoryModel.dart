import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String? id;
  final String name;
  final String imageUrl;
  String? shopId;
  List<DocumentSnapshot>? shopDocs;

  CategoryModel(this.id, this.name, this.imageUrl, this.shopId, this.shopDocs);
}
