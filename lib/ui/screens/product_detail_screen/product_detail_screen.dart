import 'package:ecommerce/utils/currency_formater.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/checkout_bloc/checkout_bloc.dart';
import '../../../blocs/product_bloc/product_bloc.dart';
import '../../../data/models/product.dart';
import '../../widgets/my_icon_button.dart';
import '../cart_screen/cart_screen.dart';
import 'widgets/image_slider.dart';
import 'widgets/shopping_bottom_bar.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedIndex = -1;

  void updateIndex(int index) {
    _selectedIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Product product = widget.product;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyIconButton(
              icon: Icons.arrow_back,
              onTap: () => Navigator.pop(context),
            ),
            const Text(
              'Detail Produk',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            BlocBuilder<CheckoutBloc, CheckoutState>(
              builder: (context, state) {
                if (state.products.isEmpty) {
                  return MyIconButton(
                    icon: Icons.shopping_cart_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(isBack: true),
                        ),
                      );
                    },
                  );
                }

                return Badge(
                  backgroundColor: Colors.red,
                  offset:
                      Offset((state.products.length >= 10) ? -6.5 : 0.1, 1.0),
                  label: Text('${state.products.length}'),
                  child: MyIconButton(
                    icon: Icons.shopping_cart_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(isBack: true),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ProductBloc>().add(GetProductsEvent());
        },
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state.status == ProductStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: [
                ImageSlider(product: product),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.attributes.brand,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        product.attributes.name,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        product.attributes.price.toRupiah(),
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      const Text(
                        'Pilih Ukuran',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Wrap(
                        spacing: 8.0,
                        children: product.attributes.sizes
                            .asMap()
                            .entries
                            .map((entry) {
                          final index = entry.key;
                          final item = entry.value;

                          return ActionChip(
                            label: Text(item.size.toString()),
                            shape: const RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.zero,
                              ),
                            ),
                            backgroundColor: index == _selectedIndex
                                ? Colors.black
                                : Colors.white,
                            labelStyle: TextStyle(
                              color: index == _selectedIndex
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            onPressed: () => updateIndex(index),
                          );
                        }).toList(),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      const Text(
                        'Deskripsi Produk',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(product.attributes.description ?? '-'),
                      const SizedBox(
                        height: 16.0,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: ShoppingBottomBar(
        selectedIndex: _selectedIndex,
        product: product,
      ),
    );
  }
}
