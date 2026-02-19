import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_crud/features/product/bloc/product_bloc.dart';
import 'package:simple_crud/features/product/bloc/product_event.dart';
import 'package:simple_crud/features/product/bloc/product_state.dart';
import 'package:simple_crud/features/product/data/models/product.dart';
import 'package:simple_crud/features/product/presentation/widgets/product_form_field.dart';
import 'package:simple_crud/features/product/presentation/widgets/product_submit_button.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _qtyController;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.product?.code ?? '');
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.product?.description ?? '');
    _priceController =
        TextEditingController(text: widget.product?.price.toString() ?? '');
    _qtyController =
        TextEditingController(text: widget.product?.qty.toString() ?? '');
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final product = Product(
      code: _codeController.text.trim(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      price: int.parse(_priceController.text.trim()),
      qty: int.parse(_qtyController.text.trim()),
    );

    if (_isEditing) {
      context
          .read<ProductBloc>()
          .add(UpdateProduct(widget.product!.id!, product));
    } else {
      context.read<ProductBloc>().add(CreateProduct(product));
    }
  }

  void _onStateChanged(BuildContext context, ProductState state) {
    if (state is ProductActionSuccess) {
      Navigator.pop(context);
    } else if (state is ProductError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Product' : 'Add Product'),
        centerTitle: true,
      ),
      body: BlocListener<ProductBloc, ProductState>(
        listener: _onStateChanged,
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            final isLoading = state is ProductLoading;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ProductFormField(
                      controller: _codeController,
                      label: 'Code',
                      hint: 'e.g. PRD-001',
                      icon: Icons.qr_code,
                      enabled: !isLoading,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Code is required' : null,
                    ),
                    const SizedBox(height: 16),
                    ProductFormField(
                      controller: _nameController,
                      label: 'Name',
                      hint: 'Product name',
                      icon: Icons.label_outline,
                      enabled: !isLoading,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 16),
                    ProductFormField(
                      controller: _descriptionController,
                      label: 'Description',
                      hint: 'Product description',
                      icon: Icons.description_outlined,
                      enabled: !isLoading,
                      maxLines: 3,
                      validator: (v) => v == null || v.isEmpty
                          ? 'Description is required'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    ProductFormField(
                      controller: _priceController,
                      label: 'Price',
                      hint: 'e.g. 50000',
                      icon: Icons.attach_money,
                      enabled: !isLoading,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Price is required';
                        if (int.tryParse(v) == null)
                          return 'Enter a valid number';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ProductFormField(
                      controller: _qtyController,
                      label: 'Quantity',
                      hint: 'e.g. 100',
                      icon: Icons.inventory_outlined,
                      enabled: !isLoading,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'Quantity is required';
                        if (int.tryParse(v) == null)
                          return 'Enter a valid number';
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    ProductSubmitButton(
                      isLoading: isLoading,
                      isEditing: _isEditing,
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
