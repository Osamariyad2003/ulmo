import 'package:flutter/material.dart';

import '../../../../core/models/product.dart';

class ProductInformationScreen extends StatelessWidget {
  final Product product;

  const ProductInformationScreen({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Product Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Measurements',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Height', '${product.measurements.height} cm'),
            _buildInfoRow('Width', '${product.measurements.width} cm'),
            _buildInfoRow('Depth', '${product.measurements.depth} cm'),
            _buildInfoRow('Weight', '${product.measurements.weight} kg'),

            const SizedBox(height: 16),
            const Text(
              'Composition',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Main material', product.composition.mainMaterial ?? 'N/A'),
            _buildInfoRow('Weight', product.composition.secondaryMaterial ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
