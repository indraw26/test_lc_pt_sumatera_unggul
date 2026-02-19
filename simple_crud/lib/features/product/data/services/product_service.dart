import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simple_crud/core/constants/app_constants.dart';
import 'package:simple_crud/features/product/data/models/product.dart';

class ProductService {
  final String _baseUrl = '${AppConstants.baseUrl}/products';

  // ngrok requires this header to skip the browser warning page
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'ngrok-skip-browser-warning': 'true',
  };

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(_baseUrl), headers: _headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List list = data['data'] ?? data;
      return list.map((e) => Product.fromJson(e)).toList();
    }
    throw Exception('Failed to load products (${response.statusCode})');
  }

  Future<Product> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: _headers,
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Product.fromJson(data['data'] ?? data);
    }
    throw Exception('Failed to create product (${response.statusCode})');
  }

  Future<Product> updateProduct(int id, Product product) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: _headers,
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Product.fromJson(data['data'] ?? data);
    }
    throw Exception('Failed to update product (${response.statusCode})');
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$id'),
      headers: _headers,
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete product (${response.statusCode})');
    }
  }
}
