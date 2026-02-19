import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_crud/features/product/bloc/product_bloc.dart';
import 'package:simple_crud/features/product/presentation/screens/product_list_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple CRUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => ProductBloc(),
        child: const ProductListScreen(),
      ),
    );
  }
}
