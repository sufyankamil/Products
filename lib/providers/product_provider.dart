import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      description: json['description'],
      image: json['image'],
    );
  }
}

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  bool isLoading = false;

  List<Product> get products => _products;

  getData() async {
    isLoading = true;
    notifyListeners();
    await fetchProducts();
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    try {
      print("in try");
      final response =
          await http.get(Uri.parse('https://fakestoreapi.com/products'));
      print("");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        print("in 200");

        _products = jsonData.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      print("in catch");
      print(e);
    }
  }
}
