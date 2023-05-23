// Purpose: Home Page Screen for the app which displays the list of products from the API

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:meragi_data/screens/product_details.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      productProvider.getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              productProvider.getData();
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: productProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: productProvider.products.length,
                itemBuilder: (context, index) {
                  final product = productProvider.products[index];
                  return ListTile(
                      title: Text(product.title),
                      subtitle: Text('Price: \$${product.price.toString()}'),
                      leading: Image.network(
                        product.image,
                        width: 100,
                        height: 100,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailScreen(product: product),
                          ),
                        );
                      });
                },
              ),
            ),
    );
  }
}
