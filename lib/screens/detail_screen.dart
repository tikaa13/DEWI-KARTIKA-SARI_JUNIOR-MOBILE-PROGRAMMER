import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'order_form.dart';

class DetailScreen extends StatelessWidget {
  final Product product;
  const DetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 260,
              child: product.image.isNotEmpty
                  ? Image.asset(product.image, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.bakery_dining, size: 80))
                  : const Icon(Icons.bakery_dining, size: 80),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Rp ${product.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 12),
                  Text(product.description),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => OrderForm(product: product)));
                      },
                      child: const Text('Pesan Sekarang'),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
