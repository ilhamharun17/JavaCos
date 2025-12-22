import 'package:flutter/material.dart';
import '../data/favorite_data.dart';
import 'widgets/costume_card.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = FavoriteData.items;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Favorite',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            const Text(
              'Your saved costumes',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: items.isEmpty
                  ? const Center(
                      child: Text(
                        'No favorite items',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : GridView.builder(
                      itemCount: items.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.65,
                          ),
                      itemBuilder: (context, index) {
                        return CostumeCard(costume: items[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
