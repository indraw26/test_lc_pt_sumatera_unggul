import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_crud/features/product/bloc/product_event.dart';
import 'package:simple_crud/features/product/bloc/product_state.dart';
import 'package:simple_crud/features/product/data/services/product_service.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductService _productService;

  ProductBloc({ProductService? productService})
      : _productService = productService ?? ProductService(),
        super(const ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<CreateProduct>(_onCreateProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    try {
      final products = await _productService.getProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onCreateProduct(
    CreateProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    try {
      await _productService.createProduct(event.product);
      final products = await _productService.getProducts();
      emit(ProductActionSuccess('Product created successfully', products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    try {
      await _productService.updateProduct(event.id, event.product);
      final products = await _productService.getProducts();
      emit(ProductActionSuccess('Product updated successfully', products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    try {
      await _productService.deleteProduct(event.id);
      final products = await _productService.getProducts();
      emit(ProductActionSuccess('Product deleted successfully', products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
