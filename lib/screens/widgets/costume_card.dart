import 'package:flutter/material.dart';
import '../../models/costume_model.dart';
import '../detail_screen.dart';
import '../../data/favorite_data.dart';

class CostumeCard extends StatefulWidget {
  final Costume costume;
  const CostumeCard({super.key, required this.costume});

  @override
  State<CostumeCard> createState() => _CostumeCardState();
}

class _CostumeCardState extends State<CostumeCard> {
  @override
  Widget build(BuildContext context) {
    final isFav = FavoriteData.isFavorite(widget.costume);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailScreen(costume: widget.costume),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== IMAGE (FIX OVERFLOW)
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    child: Image.network(
                      widget.costume.image,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover, // 🔥 penting
                    ),
                  ),

                  // ❤️ FAVORITE
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          FavoriteData.toggle(widget.costume);
                        });
                      },
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ===== INFO
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.costume.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${widget.costume.price.toInt()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
