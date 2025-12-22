import 'package:flutter/material.dart';
import '../models/costume_model.dart';
import '../data/cart_data.dart';

class DetailScreen extends StatefulWidget {
  final Costume costume;

  const DetailScreen({super.key, required this.costume});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String selectedSize = 'M';
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ===== IMAGE =====
            Stack(
              children: [
                Container(
                  height: 320,
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  child: Image.network(
                    widget.costume.image,
                    fit: BoxFit.contain,
                  ),
                ),

                // BACK
                Positioned(
                  top: 12,
                  left: 12,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: _circleIcon(Icons.arrow_back),
                  ),
                ),

                // CART
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cart clicked')),
                      );
                    },
                    child: _circleIcon(Icons.shopping_bag_outlined),
                  ),
                ),
              ],
            ),

            // ===== CONTENT =====
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  children: [
                    Text(
                      widget.costume.name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Rp ${widget.costume.price.toInt()}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // SIZE
                    const Text(
                      'Size',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        'S',
                        'M',
                        'L',
                        'XL',
                        '2XL',
                      ].map((size) => _sizeItem(size)).toList(),
                    ),

                    const SizedBox(height: 24),

                    // QUANTITY
                    const Text(
                      'Quantity',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (quantity > 1) {
                              setState(() => quantity--);
                            }
                          },
                          child: const Icon(
                            Icons.remove_circle_outline,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          quantity.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () {
                            setState(() => quantity++);
                          },
                          child: const Icon(Icons.add_circle_outline, size: 32),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // DESCRIPTION
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      widget.costume.description,
                      style: const TextStyle(color: Colors.grey, height: 1.6),
                    ),
                  ],
                ),
              ),
            ),

            // ===== RENT BUTTON =====
            GestureDetector(
              onTap: () {
                CartData.add(widget.costume, selectedSize, quantity);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added $quantity item(s) to cart'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: Container(
                height: 64,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black, Color(0xFF1A1A1A)],
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(
                      color: Color(0xFFD4AF37),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== COMPONENT =====

  Widget _circleIcon(IconData icon) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: Icon(icon, color: Colors.black),
    );
  }

  Widget _sizeItem(String size) {
    final bool isSelected = selectedSize == size;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSize = size;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 56,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          size,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? const Color(0xFFD4AF37) : Colors.black,
          ),
        ),
      ),
    );
  }
}
