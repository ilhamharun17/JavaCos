import 'package:flutter/material.dart';
import '../data/cart_data.dart';
import '../data/address_data.dart';
import 'address_screen.dart';
import 'order_confirmed_screen.dart';
import '../services/notification_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Map<String, dynamic>? addressData;

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    final data = await AddressData.load();
    setState(() {
      addressData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = CartData.items;

    final double subtotal = CartData.subtotal;
    final double shippingCost = subtotal > 0 ? 10000 : 0;
    final double total = subtotal + shippingCost;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _appBar(),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 12),

                  // ===== CART ITEMS =====
                  ...items.map((item) => _cartItem(item)).toList(),

                  const SizedBox(height: 24),

                  // ===== ADDRESS =====
                  _sectionLabel('Delivery Address'),
                  _deliverySection(),

                  const SizedBox(height: 24),

                  // ===== ORDER INFO =====
                  _orderInfo(subtotal, shippingCost, total),
                ],
              ),
            ),

            _checkoutButton(total),
          ],
        ),
      ),
    );
  }

  // ================= APP BAR =================

  Widget _appBar() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        'Cart',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ================= CART ITEM =================

  Widget _cartItem(item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Image.network(
            item.costume.image,
            width: 70,
            height: 70,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 12),

          // ===== INFO =====
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.costume.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),

                // SIZE
                Text(
                  'Size: ${item.size}',
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 4),
                Text(
                  'Rp ${item.costume.price.toInt()}',
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 8),

                // ===== QTY BUTTON =====
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (item.quantity > 1) {
                          await CartData.updateQty(item, item.quantity - 1);
                          setState(() {});
                        }
                      },
                      child: const Icon(Icons.remove_circle_outline),
                    ),
                    const SizedBox(width: 8),
                    Text(item.quantity.toString()),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () async {
                        await CartData.updateQty(item, item.quantity + 1);
                        setState(() {});
                      },
                      child: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ===== DELETE =====
          GestureDetector(
            onTap: () async {
              await CartData.remove(item);
              setState(() {});
            },
            child: const Icon(Icons.delete_outline, color: Colors.red),
          ),
        ],
      ),
    );
  }

  // ================= ADDRESS =================

  Widget _deliverySection() {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddressScreen()),
        );
        _loadAddress();
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: addressData == null
            ? const Text(
                'Set delivery address',
                style: TextStyle(color: Colors.grey),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ADDRESS
                  Text(
                    addressData!['address'] ?? 'Pinned location',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),

                  // NAME + PHONE (INI YANG TADI HILANG)
                  Text(
                    '${addressData!['name'] ?? '-'} • ${addressData!['phone'] ?? '-'}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
      ),
    );
  }

  // ================= ORDER INFO =================

  Widget _orderInfo(double subtotal, double shipping, double total) {
    return Column(
      children: [
        _infoRow('Subtotal', subtotal),
        _infoRow('Shipping', shipping),
        const Divider(),
        _infoRow('Total', total),
      ],
    );
  }

  Widget _infoRow(String title, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.black54)),
          Text(
            'Rp ${value.toInt()}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // ================= CHECKOUT =================

  Widget _checkoutButton(double total) {
    return GestureDetector(
      onTap: () async {
        await NotificationService.showOrderSuccess();

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OrderConfirmedScreen()),
        );
      },
      child: Container(
        height: 60,
        width: double.infinity,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            'Checkout (Rp ${total.toInt()})',
            style: const TextStyle(
              color: Color(0xFFD4AF37),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // ================= SECTION LABEL =================

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
