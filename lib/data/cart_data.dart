import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/costume_model.dart';

class CartItem {
  final Costume costume;
  final String size;
  int quantity;

  CartItem({required this.costume, required this.size, this.quantity = 1});

  Map<String, dynamic> toJson() => {
    'costume': costume.toJson(),
    'size': size,
    'quantity': quantity,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      costume: Costume.fromJson(json['costume']),
      size: json['size'],
      quantity: json['quantity'],
    );
  }
}

class CartData {
  static List<CartItem> items = [];

  // ================= LOAD CART =================
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('cart_items');

    if (raw != null) {
      final List decoded = jsonDecode(raw);
      items = decoded.map((e) => CartItem.fromJson(e)).toList();
    }
  }

  // ================= SAVE CART =================
  static Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = items.map((e) => e.toJson()).toList();
    await prefs.setString('cart_items', jsonEncode(jsonList));
  }

  // ================= ADD ITEM =================
  static Future<void> add(
    Costume costume,
    String size, [
    int quantity = 1,
  ]) async {
    final index = items.indexWhere(
      (e) => e.costume.id == costume.id && e.size == size,
    );

    if (index >= 0) {
      items[index].quantity += quantity;
    } else {
      items.add(CartItem(costume: costume, size: size, quantity: quantity));
    }

    await save();
  }

  // ================= REMOVE ITEM =================
  static Future<void> remove(CartItem item) async {
    items.remove(item);
    await save();
  }

  // ================= UPDATE QTY =================
  static Future<void> updateQty(CartItem item, int qty) async {
    item.quantity = qty;
    await save();
  }

  // ================= TOTAL =================
  static double get subtotal {
    return items.fold(
      0,
      (sum, item) => sum + (item.costume.price * item.quantity),
    );
  }
}
