import 'package:equatable/equatable.dart';
import 'package:simple_crud/features/product/data/models/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductLoaded extends ProductState {
  final List<Product> products;
  const ProductLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductActionSuccess extends ProductState {
  final String message;
  final List<Product> products;
  const ProductActionSuccess(this.message, this.products);

  @override
  List<Object?> get props => [message, products];
}

class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}
