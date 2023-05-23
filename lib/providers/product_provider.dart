// Purpose: Product provider to fetch data from API and notify listeners when data is fetched and when it is loading data from API

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Modal for the product data from API
class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String image;
  final String category;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      description: json['description'],
      image: json['image'],
      category: json['category'],
    );
  }
}

// Product provider to fetch data from API and notify listeners when data is fetched and when it is loading data from API
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

  // API call to fetch products
  Future<void> fetchProducts() async {
    try {
      final response =
          await http.get(Uri.parse('https://fakestoreapi.com/products'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;

        _products = jsonData.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
