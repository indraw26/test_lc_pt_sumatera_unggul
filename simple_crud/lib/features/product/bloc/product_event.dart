import 'package:equatable/equatable.dart';
import 'package:simple_crud/features/product/data/models/product.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {
  const LoadProducts();
}

class CreateProduct extends ProductEvent {
  final Product product;
  const CreateProduct(this.product);

  @override
  List<Object?> get props => [product];
}

class UpdateProduct extends ProductEvent {
  final int id;
  final Product product;
  const UpdateProduct(this.id, this.product);

  @override
  List<Object?> get props => [id, product];
}

class DeleteProduct extends ProductEvent {
  final int id;
  const DeleteProduct(this.id);

  @override
  List<Object?> get props => [id];
}
