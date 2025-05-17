import 'package:assessmentapp/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductController controller = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    final int productId = Get.arguments;

    return Scaffold(
      appBar: AppBar(title: Text("Product Details")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: controller.fetchProduct(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading product details"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("Product not found"));
          }

          final productJson = snapshot.data!;
          // You can also convert productJson to a Products model if you want

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail
                if (productJson['thumbnail'] != null)
                  Image.network(
                    productJson['thumbnail'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                SizedBox(height: 16),

                // Title
                Text(
                  productJson['title'] ?? "No Title",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 8),

                // Price & Discount
                Text(
                  "\$${productJson['price']}  -  Discount: ${productJson['discountPercentage']}%",
                  style: TextStyle(fontSize: 18, color: Colors.green),
                ),

                SizedBox(height: 8),

                // Description
                Text(
                  productJson['description'] ?? "No description",
                  style: TextStyle(fontSize: 16),
                ),

                SizedBox(height: 16),

                // Category, Brand, SKU
                Text("Category: ${productJson['category'] ?? 'N/A'}"),
                Text("Brand: ${productJson['brand'] ?? 'N/A'}"),
                Text("SKU: ${productJson['sku'] ?? 'N/A'}"),

                SizedBox(height: 16),

                // Dimensions
                if (productJson['dimensions'] != null)
                  Text(
                    "Dimensions (WxHxD): ${productJson['dimensions']['width']} x ${productJson['dimensions']['height']} x ${productJson['dimensions']['depth']}",
                  ),

                SizedBox(height: 16),

                // Reviews
                if (productJson['reviews'] != null &&
                    (productJson['reviews'] as List).isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Reviews:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      ...((productJson['reviews'] as List).map((review) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(review['reviewerName'] ?? "Anonymous"),
                            subtitle: Text(review['comment'] ?? ""),
                            trailing: Text("${review['rating'] ?? 0}/5"),
                          ),
                        );
                      }).toList()),
                    ],
                  ),

                SizedBox(height: 16),

                // Images gallery
                if (productJson['images'] != null &&
                    (productJson['images'] as List).isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Images:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children:
                              (productJson['images'] as List).map<Widget>((
                                imgUrl,
                              ) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: Image.network(
                                    imgUrl,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
