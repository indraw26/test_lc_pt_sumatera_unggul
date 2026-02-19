import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_crud/core/widgets/empty_state_widget.dart';
import 'package:simple_crud/features/product/bloc/product_bloc.dart';
import 'package:simple_crud/features/product/bloc/product_event.dart';
import 'package:simple_crud/features/product/bloc/product_state.dart';
import 'package:simple_crud/features/product/presentation/screens/product_form_screen.dart';
import 'package:simple_crud/features/product/presentation/widgets/product_card.dart';
import 'package:simple_crud/features/product/presentation/widgets/product_error_view.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(const LoadProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: _onStateChanged,
        builder: _buildBody,
      ),
    );
  }

  void _onStateChanged(BuildContext context, ProductState state) {
    if (state is ProductActionSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Widget _buildBody(BuildContext context, ProductState state) {
    if (state is ProductLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ProductError) {
      return ProductErrorView(message: state.message);
    }

    final products = state is ProductLoaded
        ? state.products
        : state is ProductActionSuccess
            ? state.products
            : [];

    if (products.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.inventory_2_outlined,
        title: 'No Products Yet',
        subtitle: 'Tap the button below to add your first product.',
        actionLabel: 'Add Product',
        onAction: () => _navigateToForm(),
      );
    }

    return RefreshIndicator(
      onRefresh: () async =>
          context.read<ProductBloc>().add(const LoadProducts()),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(
            product: product,
            onEdit: () => _navigateToForm(product: product),
            onDelete: () => DeleteConfirmDialog.show(
              context,
              id: product.id!,
              name: product.name,
            ),
          );
        },
      ),
    );
  }

  void _navigateToForm({dynamic product}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<ProductBloc>(),
          child: ProductFormScreen(product: product),
        ),
      ),
    );
  }
}
